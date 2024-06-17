// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IFees } from "../interfaces/IFees.sol";

import { NativeTokenLib } from "../libraries/NativeTokenLib.sol";
import { Rewards } from "../rewards/Rewards.sol";

/**
 * @title Custom Fees
 * @author nick
 * @notice This contract allows for the configuration of custom fees for minting.
 * @dev for free eth mints, calling contracts should short circuit and not call this contract.
 */
contract CustomFees is IFees {
  using NativeTokenLib for address;

  /* -------------------------------------------------------------------------- */
  /*                                   ERRORS                                   */
  /* -------------------------------------------------------------------------- */

  error InvalidBps();
  error InvalidSplit();
  error AddressZero();
  error ERC20MintingDisabled();
  error InvalidETHMintPrice();
  error TotalValueMismatch();

  /* -------------------------------------------------------------------------- */
  /*                                   EVENTS                                   */
  /* -------------------------------------------------------------------------- */

  event FeeConfigSet(address indexed channel, FeeConfig feeconfig);

  /* -------------------------------------------------------------------------- */
  /*                                   STRUCTS                                  */
  /* -------------------------------------------------------------------------- */

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

  /* -------------------------------------------------------------------------- */
  /*                                   STORAGE                                  */
  /* -------------------------------------------------------------------------- */

  mapping(address => FeeConfig) public channelFees;
  address internal immutable uplinkRewardsAddress;

  /* -------------------------------------------------------------------------- */
  /*                          CONSTRUCTOR & INITIALIZER                         */
  /* -------------------------------------------------------------------------- */

  constructor(address _uplinkRewardsAddress) {
    if (_uplinkRewardsAddress == address(0)) revert AddressZero();
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
    if (ethMintPrice == 0) revert InvalidETHMintPrice();

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
    address[] memory creators,
    address[] memory sponsors,
    uint256[] memory amounts,
    address mintReferral
  ) external view returns (Rewards.Split memory) {
    FeeConfig memory feeConfig = channelFees[msg.sender];
    if (feeConfig.ethMintPrice == 0) revert InvalidETHMintPrice();
    return _requestMint(NativeTokenLib.NATIVE_TOKEN, feeConfig, creators, sponsors, amounts, mintReferral);
  }

  function requestErc20Mint(
    address[] memory creators,
    address[] memory sponsors,
    uint256[] memory amounts,
    address mintReferral
  ) external view returns (Rewards.Split memory) {
    FeeConfig memory feeConfig = channelFees[msg.sender];
    if (feeConfig.erc20Contract == address(0) || feeConfig.erc20MintPrice == 0) {
      revert ERC20MintingDisabled();
    }

    return _requestMint(feeConfig.erc20Contract, feeConfig, creators, sponsors, amounts, mintReferral);
  }

  /* -------------------------------------------------------------------------- */
  /*                             INTERNAL FUNCTIONS                             */
  /* -------------------------------------------------------------------------- */

  function _requestMint(
    address token,
    FeeConfig memory feeConfig,
    address[] memory creators,
    address[] memory sponsors,
    uint256[] memory amounts,
    address mintReferral
  ) internal view returns (Rewards.Split memory) {
    bool isNative = token.isNativeToken();
    uint256 mintPrice = isNative ? feeConfig.ethMintPrice : feeConfig.erc20MintPrice;

    uint256 totalValue = 0;
    uint256 totalAmount = 0;

    /// @dev take care of mint referral, channel treasury, and uplink rewards outside of the loop to save gas

    address[] memory _staticRecipients = new address[](3);
    uint256[] memory _staticAllocations = new uint256[](3);
    uint8 _staticCommandCount = 0;

    if (feeConfig.mintReferralBps > 0) {
      if (mintReferral == address(0)) {
        /// @dev if mint referral is not set, forward rewards to the channel treasury
        feeConfig.channelBps += feeConfig.mintReferralBps;
      } else {
        _staticRecipients[_staticCommandCount] = mintReferral;
        _staticAllocations[_staticCommandCount] = _calculateSplitFromBps(mintPrice, feeConfig.mintReferralBps);
        _staticCommandCount++;
      }
    }

    if (feeConfig.uplinkBps > 0) {
      _staticRecipients[_staticCommandCount] = uplinkRewardsAddress;
      _staticAllocations[_staticCommandCount] = _calculateSplitFromBps(mintPrice, feeConfig.uplinkBps);
      _staticCommandCount++;
    }

    if (feeConfig.channelBps > 0) {
      address channelTreasury = feeConfig.channelTreasury;
      if (channelTreasury == address(0)) {
        /// @dev if channel treasury is not set, forward rewards to the creator
        feeConfig.creatorBps += feeConfig.channelBps;
      } else {
        _staticRecipients[_staticCommandCount] = channelTreasury;
        _staticAllocations[_staticCommandCount] = _calculateSplitFromBps(mintPrice, feeConfig.channelBps);
        _staticCommandCount++;
      }
    }

    uint256 creatorsLength = creators.length;
    address[] memory _runtimeRecipients = new address[](creatorsLength * 2);
    uint256[] memory _runtimeAllocations = new uint256[](creatorsLength * 2);

    uint256 _runtimeCommandCount = 0;

    /// @dev loop throgh creators and sponsors to calculate the runtime portion of the split

    for (uint256 i = 0; i < creatorsLength; i++) {
      address creator = creators[i];
      address sponsor = sponsors[i];
      uint256 amount = amounts[i];

      if (creator == address(0) || sponsor == address(0)) revert AddressZero();

      totalAmount += amount;

      if (feeConfig.sponsorBps > 0) {
        _runtimeRecipients[_runtimeCommandCount] = sponsor;
        _runtimeAllocations[_runtimeCommandCount] = amount * _calculateSplitFromBps(mintPrice, feeConfig.sponsorBps);
        _runtimeCommandCount++;
      }

      if (feeConfig.creatorBps > 0) {
        _runtimeRecipients[_runtimeCommandCount] = creator;
        _runtimeAllocations[_runtimeCommandCount] = amount * _calculateSplitFromBps(mintPrice, feeConfig.creatorBps);
        _runtimeCommandCount++;
      }
    }

    address[] memory recipients = new address[](_runtimeCommandCount + _staticCommandCount);
    uint256[] memory allocations = new uint256[](_runtimeCommandCount + _staticCommandCount);

    for (uint256 i = 0; i < _staticCommandCount; i++) {
      recipients[i] = _staticRecipients[i];

      /// @dev multiply by total amount
      uint256 allocation = _staticAllocations[i] * totalAmount;

      allocations[i] = allocation;
      totalValue += allocation;
    }

    for (uint256 i = _staticCommandCount; i < _runtimeCommandCount + _staticCommandCount; i++) {
      recipients[i] = _runtimeRecipients[i - _staticCommandCount];
      uint256 allocation = _runtimeAllocations[i - _staticCommandCount];
      allocations[i] = allocation;
      totalValue += allocation;
    }

    if (_runtimeCommandCount > 0) {
      if (totalValue != totalAmount * mintPrice) {
        revert TotalValueMismatch();
      }
    }

    return Rewards.Split(recipients, allocations, totalValue, token);
  }

  function _verifyTotalBps(
    uint16 uplinkBps,
    uint16 channelBps,
    uint16 creatorBps,
    uint16 mintReferralBps,
    uint16 sponsorBps
  ) internal pure {
    uint80 totalBps = uint80(uplinkBps) +
      uint80(channelBps) +
      uint80(creatorBps) +
      uint80(mintReferralBps) +
      uint80(sponsorBps);

    if (totalBps != 1e4) {
      revert InvalidBps();
    }
  }

  function _verifySplits(
    uint256 mintPrice,
    uint16 uplinkBps,
    uint16 channelBps,
    uint16 creatorBps,
    uint16 mintReferralBps,
    uint16 sponsorBps
  ) internal pure {
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
   * @notice Returns the contract source code repository
   * @return string repository uri
   */
  function codeRepository() external pure returns (string memory) {
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
