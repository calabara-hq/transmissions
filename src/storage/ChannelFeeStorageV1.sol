// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IChannelTypesV1} from "../interfaces/IChannelTypesV1.sol";

/// @notice Channel Storage
/// @author @nickddsn

// fees are an upgradable / dynamic array of FeePair structs paid on each mint

contract ChannelFeeStorageV1 {

    struct FeePair {
        address addr;
        uint256 amount;
    }

    address public treasury;
   // mapping(uint256 => address) public createReferral;
    FeePair[] public fees;
}
