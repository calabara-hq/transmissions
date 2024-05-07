// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IChannel} from "../channel/Channel.sol";

/// @notice Channel Storage
/// @author @nickddsn

contract ChannelFactoryStorageV1 {
    IChannel public immutable channelImpl;
}
