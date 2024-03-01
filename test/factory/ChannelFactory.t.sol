// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract ChannelFactoryTest is Test {
    address nick = 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C;

    function test_createChannel() public {
        ChannelFactory channelFactory = new ChannelFactory();
        // Create a new ERC1155 contract
        address channelAddress = channelFactory.createChannel(
            "https://example.com/api/token/",
            nick
        );
        console.log("New ERC1155 channel address:", channelAddress);

        // Print the deployedChannels array
        console.log("Deployed channels:");
        for (uint256 i = 0; i < channelFactory.deployedChannelsLength(); i++) {
            address deployedChannelAddress = channelFactory.deployedChannels(i);
            console.log(deployedChannelAddress);
        }
    }
}
