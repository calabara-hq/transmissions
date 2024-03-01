// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {IChannelFactory} from "../interfaces/IChannelFactory.sol";
import {Channel} from "../channel/ChannelImpl.sol";
import {IChannelTypesV1} from "../interfaces/IChannelTypesV1.sol";
import {ChannelFactoryStorageV1} from "../storage/ChannelFactoryStorageV1.sol";

contract ChannelFactory is IChannelFactory, ChannelFactoryStorageV1 {
    function createChannel(string memory uri, address treasury) public returns (address) {
        Channel newChannel = new Channel(uri, treasury);
        deployedChannels.push(address(newChannel));
        return address(newChannel);
    }

    function deployedChannelsLength() public view returns (uint256) {
        return deployedChannels.length;
    }
}
