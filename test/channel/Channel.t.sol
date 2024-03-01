// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {Channel} from "../../src/channel/ChannelImpl.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract ChannelTest is Test {
    ChannelFactory channelFactory;
    Channel channelInstance;
    address channelAddress;
    address nick = 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C;

    function setUp() public {
        channelFactory = new ChannelFactory();
        channelAddress = channelFactory.createChannel(
            "https://example.com/api/token/",
            nick
        );
        channelInstance = Channel(channelAddress);
    }

    function test_createToken() public {
        // Create a new token
        uint256 tokenId = channelInstance.createToken(
            "https://example.com/api/token/0",
            100
        );
        console.log("New ERC1155 token id:", tokenId);

        // get the token
        Channel.TokenConfig memory token = channelInstance.getTokens(tokenId);
        console.log("Token uri:", token.uri);
        console.log("Token maxSupply:", token.maxSupply);
        console.log("Token totalMinted:", token.totalMinted);

        // calculate balance of 
        uint256 balance = channelInstance.balanceOf(address(this), tokenId);
        console.log("Balance of token:", balance);

        address treasury = channelInstance.getTreasury();
        console.log("Treasury:", treasury);
    }

    function test_mint() public {
        // Create a new token
        uint256 tokenId = channelInstance.createToken(
            "https://example.com/api/token/0",
            100
        );

        // Mint some tokens
        channelInstance.mint(nick, tokenId, 10, "0x0");
        uint256 balance = channelInstance.balanceOf(nick, tokenId);
        console.log("Balance of token:", balance);

        // expect(
        //     "Channel: max supply reached",
        //     channelInstance.mint(nick, tokenId, 1000, "0x0")
        // );


    }
}
