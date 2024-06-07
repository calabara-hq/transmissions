// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { IFees } from "../interfaces/IFees.sol";
import { ILogic } from "../interfaces/ILogic.sol";
import { IUpgradePath } from "../interfaces/IUpgradePath.sol";

/// @notice Channel Storage
/// @author @nick

contract ChannelStorage {
  /// @dev channel tokens
  mapping(uint256 => TokenConfig) public tokens;
  /// @dev token id counter
  uint256 public nextTokenId;

  /// @dev channel fee contract
  IFees public feeContract;
  /// @dev channel logic contract
  ILogic public logicContract;

  /// @dev user stats
  mapping(address => UserStats) public userStats;

  struct UserStats {
    /// @dev number of tokens created by user
    uint256 numCreations;
    /// @dev number of tokens minted by user
    uint256 numMints;
  }

  struct TokenConfig {
    /// @dev token uri
    string uri;
    /// @dev token author
    address author;
    /// @dev token max supply
    uint256 maxSupply;
    /// @dev token total minted
    uint256 totalMinted;
    /// @dev token first minter
    address sponsor;
  }
}
