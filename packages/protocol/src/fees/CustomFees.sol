// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFees {
    enum NativeFeeActions {
        SEND_ETH
    }

    enum Erc20FeeActions {
        SEND_ERC20
    }

    struct NativeMintCommands {
        // Method for operation
        NativeFeeActions method;
        // Arguments used for this operation
        address recipient;
        uint256 amount;
    }

    struct Erc20MintCommands {
        // Method for operation
        Erc20FeeActions method;
        // Arguments used for this operation
        address erc20Contract;
        address recipient;
        uint256 amount;
    }

    struct Splits {
        uint16 uplinkBps;
        uint16 channelBps;
        uint16 creatorBps;
        uint16 mintReferralBps;
        uint16 sponsorBps;
    }

    struct Erc20MintConfig {
        uint256 erc20MintPrice;
        address erc20Contract;
    }

    struct FeeConfig {
        uint256 ethMintPrice;
        address channelTreasury;
        Splits splits;
        Erc20MintConfig tokenMintConfig;
    }

    event FeeConfigSet(address indexed channel, FeeConfig feeconfig);

    function setChannelFeeConfig(bytes calldata data) external;

    function getEthMintPrice() external view returns (uint256);
    function getErc20MintPrice() external view returns (uint256);

    function requestNativeMint(address creator, address referral, address sponsor) external view returns (NativeMintCommands[] memory);

    function requestErc20Mint(address creator, address referral, address sponsor) external view returns (Erc20MintCommands[] memory);

    function getSplits() external view returns (uint16, uint16, uint16, uint16, uint16);

    error InvalidBPS();
    error InvalidSplit();
}

contract CustomFees is IFees {
    mapping(address => FeeConfig) public customFees;
    address internal immutable uplinkRewardsAddress;

    constructor(address _uplinkRewardsAddress) {
        if (_uplinkRewardsAddress == address(0)) revert("Invalid uplink rewards address");
        uplinkRewardsAddress = _uplinkRewardsAddress;
    }

    /**
     * @notice Setter for the channel fee configuration.
     * @param data abi encoded representation of the fee configuration.
     */
    function setChannelFeeConfig(bytes calldata data) external {
        (
            uint256 ethMintPrice,
            address channelTreasury,
            uint16 uplinkBps,
            uint16 channelBps,
            uint16 creatorBps,
            uint16 mintReferralBps,
            uint16 sponsorBps,
            uint256 erc20MintPrice,
            address erc20Contract
        ) = abi.decode(data, (uint256, address, uint16, uint16, uint16, uint16, uint16, uint256, address));

        _verifyTotalBps(uplinkBps, channelBps, creatorBps, mintReferralBps, sponsorBps);
        _verifySplits(ethMintPrice, uplinkBps, channelBps, creatorBps, mintReferralBps, sponsorBps);

        if (erc20MintPrice > 0 && erc20Contract != address(0)) {
            _verifySplits(erc20MintPrice, uplinkBps, channelBps, creatorBps, mintReferralBps, sponsorBps);
        }

        customFees[msg.sender] = FeeConfig(
            ethMintPrice,
            channelTreasury,
            Splits(uplinkBps, channelBps, creatorBps, mintReferralBps, sponsorBps),
            Erc20MintConfig(erc20MintPrice, erc20Contract)
        );

        emit FeeConfigSet(msg.sender, customFees[msg.sender]);
    }

    function _verifyTotalBps(uint16 uplinkBps, uint16 channelBps, uint16 creatorBps, uint16 mintReferralBps, uint16 sponsorBps) internal pure {
        if ((uplinkBps + channelBps + creatorBps + mintReferralBps + sponsorBps) % 1e4 != 0) {
            revert InvalidBPS();
        }
    }

    function _verifySplits(uint256 mintPrice, uint16 uplinkBps, uint16 channelBps, uint16 creatorBps, uint16 mintReferralBps, uint16 sponsorBps) internal pure {
        if ((mintPrice * uplinkBps) % 1e4 != 0) {
            revert InvalidSplit();
        }
        if ((mintPrice * channelBps) % 1e4 != 0) {
            revert InvalidSplit();
        }
        if ((mintPrice * creatorBps) % 1e4 != 0) {
            revert InvalidSplit();
        }
        if ((mintPrice * mintReferralBps) % 1e4 != 0) {
            revert InvalidSplit();
        }
        if ((mintPrice * sponsorBps) % 1e4 != 0) {
            revert InvalidSplit();
        }
    }

    /**
     * @notice Getter for the channel eth mint price.
     * @return uint256 eth mint price.
     */
    function getEthMintPrice() external view returns (uint256) {
        FeeConfig memory feeConfig = customFees[msg.sender];
        return feeConfig.ethMintPrice;
    }

    /**
     * @notice Getter for the channel erc20 mint price.
     * @return uint256 erc20 mint price.
     */
    function getErc20MintPrice() external view returns (uint256) {
        FeeConfig memory feeConfig = customFees[msg.sender];
        return feeConfig.tokenMintConfig.erc20MintPrice;
    }

    function getSplits() external view returns (uint16, uint16, uint16, uint16, uint16) {
        FeeConfig memory feeConfig = customFees[msg.sender];
        return (
            feeConfig.splits.uplinkBps,
            feeConfig.splits.channelBps,
            feeConfig.splits.creatorBps,
            feeConfig.splits.mintReferralBps,
            feeConfig.splits.sponsorBps
        );
    }

    function _calculateSplitFromBps(uint256 number, uint16 splitBps) internal pure returns (uint256) {
        return (number * splitBps) / 1e4;
    }

    function requestErc20Mint(address creator, address referral, address sponsor) external view returns (Erc20MintCommands[] memory) {
        if (creator == address(0)) revert("Invalid creator address");
        if (sponsor == address(0)) revert("Invalid sponsor address");

        FeeConfig memory feeConfig = customFees[msg.sender];

        if (feeConfig.tokenMintConfig.erc20Contract == address(0) || feeConfig.tokenMintConfig.erc20MintPrice == 0) {
            revert("ERC20 minting is not enabled");
        }

        uint256 commandCount = 0;
        Erc20MintCommands[] memory tempCommands = new Erc20MintCommands[](5); // Maximum size assuming all fees are applicable

        // Calculate mint referral fees
        if (feeConfig.splits.mintReferralBps > 0) {
            if (referral == address(0)) {
                feeConfig.splits.channelBps += feeConfig.splits.mintReferralBps; // Add to channel bps if no referral
            } else {
                tempCommands[commandCount++] = Erc20MintCommands(
                    Erc20FeeActions.SEND_ERC20,
                    feeConfig.tokenMintConfig.erc20Contract,
                    referral,
                    _calculateSplitFromBps(feeConfig.tokenMintConfig.erc20MintPrice, feeConfig.splits.mintReferralBps)
                );
            }
        }

        // Handle sponsor fees
        if (feeConfig.splits.sponsorBps > 0) {
            tempCommands[commandCount++] = Erc20MintCommands(
                Erc20FeeActions.SEND_ERC20,
                feeConfig.tokenMintConfig.erc20Contract,
                sponsor,
                _calculateSplitFromBps(feeConfig.tokenMintConfig.erc20MintPrice, feeConfig.splits.sponsorBps)
            );
        }

        // Handle uplink fees (assuming uplink address needs to be passed as parameter or managed elsewhere)
        if (feeConfig.splits.uplinkBps > 0) {
            // Placeholder for the uplink address; must be determined outside of this function or through another config
            tempCommands[commandCount++] = Erc20MintCommands(
                Erc20FeeActions.SEND_ERC20,
                feeConfig.tokenMintConfig.erc20Contract,
                uplinkRewardsAddress,
                _calculateSplitFromBps(feeConfig.tokenMintConfig.erc20MintPrice, feeConfig.splits.uplinkBps)
            );
        }

        /// Handle channel fees
        /// if channel treasury is address 0, route the treasury rewards to the creator
        /// otherwise set the channel mint command
        if (feeConfig.splits.channelBps > 0) {
            if (feeConfig.channelTreasury == address(0)) {
                feeConfig.splits.creatorBps += feeConfig.splits.channelBps;
            } else {
                tempCommands[commandCount++] = Erc20MintCommands(
                    Erc20FeeActions.SEND_ERC20,
                    feeConfig.tokenMintConfig.erc20Contract,
                    feeConfig.channelTreasury,
                    _calculateSplitFromBps(feeConfig.tokenMintConfig.erc20MintPrice, feeConfig.splits.channelBps)
                );
            }
        }

        /// Handle creator fees
        if (feeConfig.splits.creatorBps > 0) {
            tempCommands[commandCount++] = Erc20MintCommands(
                Erc20FeeActions.SEND_ERC20,
                feeConfig.tokenMintConfig.erc20Contract,
                creator,
                _calculateSplitFromBps(feeConfig.tokenMintConfig.erc20MintPrice, feeConfig.splits.creatorBps)
            );
        }

        // Compile the list of actual commands to return
        Erc20MintCommands[] memory transferCommands = new Erc20MintCommands[](commandCount);
        for (uint256 i = 0; i < commandCount; i++) {
            transferCommands[i] = tempCommands[i];
        }

        return transferCommands;
    }

    function requestNativeMint(address creator, address referral, address sponsor) external view returns (NativeMintCommands[] memory) {
        if (creator == address(0)) revert("Invalid creator address");
        if (sponsor == address(0)) revert("Invalid sponsor address");

        FeeConfig memory feeConfig = customFees[msg.sender];

        if (feeConfig.ethMintPrice == 0) return new NativeMintCommands[](0);

        uint256 commandCount = 0;
        NativeMintCommands[] memory tempCommands = new NativeMintCommands[](5); // Maximum size assuming all fees are applicable

        // Calculate mint referral fees
        if (feeConfig.splits.mintReferralBps > 0) {
            if (referral == address(0)) {
                feeConfig.splits.channelBps += feeConfig.splits.mintReferralBps; // Add to channel bps if no referral
            } else {
                tempCommands[commandCount++] = NativeMintCommands(
                    NativeFeeActions.SEND_ETH,
                    referral,
                    _calculateSplitFromBps(feeConfig.ethMintPrice, feeConfig.splits.mintReferralBps)
                );
            }
        }

        // Handle sponsor fees
        if (feeConfig.splits.sponsorBps > 0) {
            tempCommands[commandCount++] = NativeMintCommands(
                NativeFeeActions.SEND_ETH,
                sponsor,
                _calculateSplitFromBps(feeConfig.ethMintPrice, feeConfig.splits.sponsorBps)
            );
        }

        // Handle uplink fees (assuming uplink address needs to be passed as parameter or managed elsewhere)
        if (feeConfig.splits.uplinkBps > 0) {
            // Placeholder for the uplink address; must be determined outside of this function or through another config
            tempCommands[commandCount++] = NativeMintCommands(
                NativeFeeActions.SEND_ETH,
                uplinkRewardsAddress,
                _calculateSplitFromBps(feeConfig.ethMintPrice, feeConfig.splits.uplinkBps)
            );
        }

        /// Handle channel fees
        /// if channel treasury is address 0, route the treasury rewards to the creator
        /// otherwise set the channel fee command
        if (feeConfig.splits.channelBps > 0) {
            if (feeConfig.channelTreasury == address(0)) {
                feeConfig.splits.creatorBps += feeConfig.splits.channelBps;
            } else {
                tempCommands[commandCount++] = NativeMintCommands(
                    NativeFeeActions.SEND_ETH,
                    feeConfig.channelTreasury,
                    _calculateSplitFromBps(feeConfig.ethMintPrice, feeConfig.splits.channelBps)
                );
            }
        }

        /// Handle creator fees
        if (feeConfig.splits.creatorBps > 0) {
            tempCommands[commandCount++] = NativeMintCommands(
                NativeFeeActions.SEND_ETH,
                creator,
                _calculateSplitFromBps(feeConfig.ethMintPrice, feeConfig.splits.creatorBps)
            );
        }

        // Compile the list of actual commands to return
        NativeMintCommands[] memory transferCommands = new NativeMintCommands[](commandCount);
        for (uint256 i = 0; i < commandCount; i++) {
            transferCommands[i] = tempCommands[i];
        }

        return transferCommands;
    }
}
