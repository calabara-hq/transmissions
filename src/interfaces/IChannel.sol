// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IChannelTypesV1} from "./IChannelTypesV1.sol";
import {IFees} from "../fees/IFees.sol";
/// @notice Channel
/// @author @nickddsn

interface IChannel {
    function initialize(
        string calldata uri,
        address defaultAdmin,
        address[] calldata admins,
        bytes[] calldata setupActions
    ) external;

    function setChannelFeeConfig(
        IFees feeContract,
        bytes calldata data
    ) external;

    function mintPrice() external view returns (uint256);
    function channelFees() external view returns (uint256, uint256, uint256, uint256, uint256);
}
