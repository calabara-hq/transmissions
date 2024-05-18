// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IFees } from "../fees/CustomFees.sol";

import { ILogic } from "../logic/Logic.sol";

import { Multicall } from "../utils/Multicall.sol";
import { IUpgradePath, UpgradePath } from "../utils/UpgradePath.sol";
import { IUpgradePath, UpgradePath } from "../utils/UpgradePath.sol";

import { Channel } from "./Channel.sol";

import { AccessControlUpgradeable } from "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";
import { Initializable } from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { ERC1155Upgradeable } from "openzeppelin-contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";

import { ReentrancyGuardUpgradeable } from "openzeppelin-contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import { ERC1967Utils } from "openzeppelin-contracts/proxy/ERC1967/ERC1967Utils.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";

/**
 * @title InfiniteChannel
 * @author nick
 *
 * Infinite channels run "forever". The channel will indefinitely accept new tokens.
 * A global saleDuration is set, which is used to calculate the sale end for each new token.
 */
contract InfiniteChannel is Channel {
  error SaleOver();

  /// @notice duration of the public sale for each new token
  uint40 public saleDuration;
  /// @notice individual token sale end times based on duration
  mapping(uint256 => uint40) public saleEnd;

  /* -------------------------------------------------------------------------- */
  /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
  /* -------------------------------------------------------------------------- */

  constructor(address _updgradePath, address _weth) initializer Channel(_updgradePath, _weth) {}

  /**
   * @notice Set the sale duration for a channel
   * @param data encoded duration
   */
  function setTiming(bytes calldata data) public override {
    uint40 duration = abi.decode(data, (uint40));
    _setDuration(duration);
  }

  /* -------------------------------------------------------------------------- */
  /*                             INTERNAL FUNCTIONS                             */
  /* -------------------------------------------------------------------------- */

  function _setDuration(uint40 _duration) internal {
    require(_duration > 0, "Invalid duration");
    saleDuration = _duration;
  }

  function _processNewToken(uint256 tokenId) internal override {
    _setTokenSale(tokenId);
  }

  function _authorizeMint(uint256 tokenId) internal override {
    if (block.timestamp > saleEnd[tokenId]) {
      revert SaleOver();
    }
  }

  /**
   * @notice Set the token sale end time based on the global duration
   * @param tokenId token id
   */
  function _setTokenSale(uint256 tokenId) internal {
    uint80 _saleDuration = uint80(saleDuration);
    uint80 _currentTime = uint80(block.timestamp);

    // Calculate potential end time using uint80 to prevent overflow during calculation
    uint80 _potentialSaleEnd = _currentTime + _saleDuration;

    // Check if the potential end time exceeds the uint40 maximum value
    if (_potentialSaleEnd >= type(uint40).max) {
      // If the calculated end time is greater than what uint40 can store, set it to the maximum uint40 value
      saleEnd[tokenId] = type(uint40).max;
    } else {
      // Otherwise, safely cast the end time back to uint40 and store it
      saleEnd[tokenId] = uint40(_potentialSaleEnd);
    }
    //todo emit TokenSaleSet(msg.sender, tokenId, saleEnd[tokenId]);
  }
}
