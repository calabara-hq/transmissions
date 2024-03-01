// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @notice Channel Factory
/// @author @nickddsn


interface IChannelFactory {
    function createChannel(string memory uri, address _treasury) external returns (address);
    function deployedChannelsLength() external view returns (uint256);
}