// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IChannelTypesV1} from "../interfaces/IChannelTypesV1.sol";

/// @notice Channel Storage
/// @author @nickddsn

contract ChannelStorageV1 is IChannelTypesV1 {
    mapping(uint256 => TokenConfig) internal tokens;
    uint256 public nextTokenId;
    address internal uplinkFeeAddress;
}
