// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IFees } from "../interfaces/IFees.sol";

import { IVersionedContract } from "../interfaces/IVersionedContract.sol";
import { IRewards } from "../rewards/Rewards.sol";
import { Test, console } from "forge-std/Test.sol";

contract CustomFees is IFees, IVersionedContract {
    struct FeeConfig {
        address channelTreasury;
        uint16 uplinkBps;
        uint16 channelBps;
        uint16 creatorBps;
        uint16 mintReferralBps;
        uint16 sponsorBps;
        uint256 ethMintPrice;
        uint256 erc20MintPrice;
        address erc20Contract;
    }

    mapping(address => FeeConfig) public channelFees;
    address internal immutable uplinkRewardsAddress;

    address NATIVE_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor(address _uplinkRewardsAddress) {
        if (_uplinkRewardsAddress == address(0)) revert ADDRESS_ZERO();
        uplinkRewardsAddress = _uplinkRewardsAddress;
    }

    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Getter for the channel eth mint price.
     * @return uint256 eth mint price.
     */
    function getEthMintPrice() external view returns (uint256) {
        return channelFees[msg.sender].ethMintPrice;
    }

    /**
     * @notice Getter for the channel erc20 mint price.
     * @return uint256 erc20 mint price.
     */
    function getErc20MintPrice() external view returns (uint256) {
        return channelFees[msg.sender].erc20MintPrice;
    }

    function getFeeBps() external view returns (uint16, uint16, uint16, uint16, uint16) {
        FeeConfig memory feeConfig = channelFees[msg.sender];
        return (
            feeConfig.uplinkBps,
            feeConfig.channelBps,
            feeConfig.creatorBps,
            feeConfig.mintReferralBps,
            feeConfig.sponsorBps
        );
    }

    /**
     * @notice Setter for the channel fee configuration.
     * @param data abi encoded representation of the fee configuration.
     */
    function setChannelFees(bytes calldata data) external {
        (
            address channelTreasury,
            uint16 uplinkBps,
            uint16 channelBps,
            uint16 creatorBps,
            uint16 mintReferralBps,
            uint16 sponsorBps,
            uint256 ethMintPrice,
            uint256 erc20MintPrice,
            address erc20Contract
        ) = abi.decode(data, (address, uint16, uint16, uint16, uint16, uint16, uint256, uint256, address));

        // free mints are not handled by this contract. If the eth price is zero, always revert.
        if (ethMintPrice == 0) revert INVALID_ETH_MINT_PRICE();

        _verifyTotalBps(uplinkBps, channelBps, creatorBps, mintReferralBps, sponsorBps);
        _verifySplits(ethMintPrice, uplinkBps, channelBps, creatorBps, mintReferralBps, sponsorBps);

        if (erc20MintPrice > 0 && erc20Contract != address(0)) {
            _verifySplits(erc20MintPrice, uplinkBps, channelBps, creatorBps, mintReferralBps, sponsorBps);
        }

        channelFees[msg.sender] = FeeConfig(
            channelTreasury,
            uplinkBps,
            channelBps,
            creatorBps,
            mintReferralBps,
            sponsorBps,
            ethMintPrice,
            erc20MintPrice,
            erc20Contract
        );

        emit FeeConfigSet(msg.sender, channelFees[msg.sender]);
    }

    function requestEthMint(
        address creator,
        address referral,
        address sponsor,
        uint256 amount
    )
        external
        view
        returns (IRewards.Split memory)
    {
        FeeConfig memory feeConfig = channelFees[msg.sender];
        return _requestMint(NATIVE_TOKEN, feeConfig, creator, referral, sponsor, amount);
    }

    function requestErc20Mint(
        address creator,
        address referral,
        address sponsor,
        uint256 amount
    )
        external
        view
        returns (IRewards.Split memory)
    {
        FeeConfig memory feeConfig = channelFees[msg.sender];
        if (feeConfig.erc20Contract == address(0) || feeConfig.erc20MintPrice == 0) {
            revert ERC20_MINTING_DISABLED();
        }

        return _requestMint(feeConfig.erc20Contract, feeConfig, creator, referral, sponsor, amount);
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _requestMint(
        address token,
        FeeConfig memory feeConfig,
        address creator,
        address referral,
        address sponsor,
        uint256 amount
    )
        internal
        view
        returns (IRewards.Split memory)
    {
        if (creator == address(0) || sponsor == address(0)) revert ADDRESS_ZERO();

        address[] memory _recipients = new address[](5);
        uint256[] memory _allocations = new uint256[](5);

        uint8 commandCount = 0;

        bool isNative = _isNativeToken(token);

        if (feeConfig.mintReferralBps > 0) {
            if (referral == address(0)) {
                // if no referral, add it to the channel bps
                feeConfig.channelBps += feeConfig.mintReferralBps;
            } else {
                _recipients[commandCount] = referral;
                _allocations[commandCount] = amount
                    * _calculateSplitFromBps(
                        isNative ? feeConfig.ethMintPrice : feeConfig.erc20MintPrice, feeConfig.mintReferralBps
                    );
                commandCount++;
            }
        }

        if (feeConfig.sponsorBps > 0) {
            _recipients[commandCount] = sponsor;
            _allocations[commandCount] = amount
                * _calculateSplitFromBps(isNative ? feeConfig.ethMintPrice : feeConfig.erc20MintPrice, feeConfig.sponsorBps);
            commandCount++;
        }

        if (feeConfig.uplinkBps > 0) {
            _recipients[commandCount] = uplinkRewardsAddress;
            _allocations[commandCount] = amount
                * _calculateSplitFromBps(isNative ? feeConfig.ethMintPrice : feeConfig.erc20MintPrice, feeConfig.uplinkBps);
            commandCount++;
        }

        if (feeConfig.channelBps > 0) {
            if (feeConfig.channelTreasury == address(0)) {
                // if no channel treasury, add to creator bps
                feeConfig.creatorBps += feeConfig.channelBps;
            } else {
                _recipients[commandCount] = feeConfig.channelTreasury;
                _allocations[commandCount] = amount
                    * _calculateSplitFromBps(
                        isNative ? feeConfig.ethMintPrice : feeConfig.erc20MintPrice, feeConfig.channelBps
                    );
                commandCount++;
            }
        }

        if (feeConfig.creatorBps > 0) {
            _recipients[commandCount] = creator;
            _allocations[commandCount] = amount
                * _calculateSplitFromBps(isNative ? feeConfig.ethMintPrice : feeConfig.erc20MintPrice, feeConfig.creatorBps);
            commandCount++;
        }

        address[] memory recipients = new address[](commandCount);
        uint256[] memory allocations = new uint256[](commandCount);

        uint256 totalValue;

        for (uint256 i = 0; i < commandCount; i++) {
            recipients[i] = _recipients[i];
            allocations[i] = _allocations[i];
            totalValue += _allocations[i];
        }

        if (commandCount > 0) {
            if (totalValue != amount * (isNative ? feeConfig.ethMintPrice : feeConfig.erc20MintPrice)) {
                revert TOTAL_VALUE_MISMATCH();
            }
        }

        return IRewards.Split(recipients, allocations, totalValue, token);
    }

    function _isNativeToken(address token) internal view returns (bool) {
        return token == NATIVE_TOKEN;
    }

    function _verifyTotalBps(
        uint16 uplinkBps,
        uint16 channelBps,
        uint16 creatorBps,
        uint16 mintReferralBps,
        uint16 sponsorBps
    )
        internal
        pure
    {
        uint80 totalBps =
            uint80(uplinkBps) + uint80(channelBps) + uint80(creatorBps) + uint80(mintReferralBps) + uint80(sponsorBps);

        if (totalBps != 1e4) {
            revert INVAlID_BPS();
        }
    }

    function _verifySplits(
        uint256 mintPrice,
        uint16 uplinkBps,
        uint16 channelBps,
        uint16 creatorBps,
        uint16 mintReferralBps,
        uint16 sponsorBps
    )
        internal
        pure
    {
        if ((mintPrice * uplinkBps) % 1e4 != 0) {
            revert INVALID_SPLIT();
        }
        if ((mintPrice * channelBps) % 1e4 != 0) {
            revert INVALID_SPLIT();
        }
        if ((mintPrice * creatorBps) % 1e4 != 0) {
            revert INVALID_SPLIT();
        }
        if ((mintPrice * mintReferralBps) % 1e4 != 0) {
            revert INVALID_SPLIT();
        }
        if ((mintPrice * sponsorBps) % 1e4 != 0) {
            revert INVALID_SPLIT();
        }
    }

    function _calculateSplitFromBps(uint256 number, uint16 splitBps) internal pure returns (uint256) {
        return (number * splitBps) / 1e4;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  VERSIONING                                */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Returns the contract version
     * @return string contract version
     */
    function contractVersion() external pure returns (string memory) {
        return "1.0.0";
    }

    /**
     * @notice Returns the contract uri
     * @return string contract uri
     */
    function contractURI() external pure returns (string memory) {
        return "https://github.com/calabara-hq/transmissions/packages/protocol";
    }

    /**
     * @notice Returns the contract name
     * @return string contract name
     */
    function contractName() external pure returns (string memory) {
        return "Custom Fees";
    }
}
