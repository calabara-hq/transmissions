// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {Channel} from "../../src/channel/ChannelImpl.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";

contract ChannelTest is Test {
    // ChannelFactory channelFactory;
    // Channel channelInstance;
    // address channelAddress;
    // address nick = 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C;
    // function setUp() public {
    //     ChannelFactory channelFactory = new ChannelFactory();
    //     // Create a new ERC1155 contract
    //     FeePair[] memory fees = new FeePair[](2);
    //     fees[0] = FeePair({addr: 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C, amount: 111000000000000});
    //     fees[1] = FeePair({addr: 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C, amount: 111000000000000});
    //     bytes memory encodedFixedFees = abi.encode(fees);
    //     uint256[] memory dynamicFees = new uint256[](3);
    //     dynamicFees[0] = 333000000000000;
    //     dynamicFees[1] = 111000000000000;
    //     dynamicFees[2] = 111000000000000;
    //     bytes memory encodedDynamicFees = abi.encode(dynamicFees);
    //     address channelAddress =
    //     channelFactory.createChannel("https://example.com/api/token/", encodedFixedFees, encodedDynamicFees);
    //     channelInstance = Channel(channelAddress);
    // }
    // function test_createToken() public {
    //     // Create a new token
    //     uint256 tokenId = channelInstance.createToken("https://example.com/api/token/0", nick, 100, nick);
    //     console.log("New ERC1155 token id:", tokenId);
    //     // get the token
    //     Channel.TokenConfig memory token = channelInstance.getTokens(tokenId);
    //     console.log("Token uri:", token.uri);
    //     console.log("Token maxSupply:", token.maxSupply);
    //     console.log("Token totalMinted:", token.totalMinted);
    //     console.log("Token author:", token.author);
    //     console.log("Token createReferral:", token.createReferral);
    //     console.log("Channel Mint Price With Mint Referral:", channelInstance.getTokenMintPrice(tokenId, true));
    //     console.log("Channel Mint Price Without Mint Referral:", channelInstance.getTokenMintPrice(tokenId, false));
    // }
    // function test_mint() public {
    //     // Create a new token
    //     uint256 tokenId = channelInstance.createToken("https://example.com/api/token/0", 100);
    //     // Mint some tokens
    //     channelInstance.mint(nick, tokenId, 10, "0x0");
    //     uint256 balance = channelInstance.balanceOf(nick, tokenId);
    //     console.log("Balance of token:", balance);
    // }
}
