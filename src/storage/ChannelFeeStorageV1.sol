// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IChannelTypesV1} from "../interfaces/IChannelTypesV1.sol";

/// @notice Channel Storage
/// @author @nickddsn

// fees are an upgradable / dynamic array of FeePair structs paid on each mint

contract ChannelFeeStorageV1 {
// struct FeePair {
//     address addr;
//     uint256 amount;
// }

// uint256 public channelMintFee;
// FeePair[] public constantChannelFees;
// uint256[] public runtimeChannelFees;

// function setChannelFees(bytes memory _constantChannelFees, bytes memory _runtimeChannelFees) public {
//     channelMintFee = 0;
//     setConstantFees(_constantChannelFees);
//     setRuntimeFees(_runtimeChannelFees);
// }

// function setConstantFees(bytes memory _constantChannelFees) internal {
//     FeePair[] memory fees = abi.decode(_constantChannelFees, (FeePair[]));
//     for (uint256 i = 0; i < fees.length; i++) {
//         constantChannelFees.push(fees[i]);
//         channelMintFee += fees[i].amount;
//     }
// }

// function setRuntimeFees(bytes memory _runtimeChannelFees) internal {
//     uint256[] memory decodedRuntimeFees = abi.decode(_runtimeChannelFees, (uint256[]));
//     for (uint256 i = 0; i < decodedRuntimeFees.length; i++) {
//         runtimeChannelFees.push(decodedRuntimeFees[i]);
//         channelMintFee += decodedRuntimeFees[i];
//     }
// }
}
