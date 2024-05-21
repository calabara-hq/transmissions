// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { IFees } from "../fees/CustomFees.sol";
import { ILogic } from "../logic/Logic.sol";

import { IUpgradePath } from "../utils/UpgradePath.sol";
/// @notice Channel Storage
/// @author @nickddsn

contract ChannelStorage {
    /// @dev channel tokens
    mapping(uint256 => TokenConfig) public tokens;
    /// @dev token id counter
    uint256 public nextTokenId;

    /// @dev channel fee contract
    IFees public feeContract;
    /// @dev channel logic contract
    ILogic public logicContract;

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
