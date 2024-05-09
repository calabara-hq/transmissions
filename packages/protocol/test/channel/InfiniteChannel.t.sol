// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { InfiniteChannel } from "../../src/channel/InfiniteChannel.sol";

import { IUpgradePath, UpgradePath } from "../../src/utils/UpgradePath.sol";
import { Test, console } from "forge-std/Test.sol";

import { InfiniteUplink1155 } from "../../src/proxies/InfiniteUplink1155.sol";

contract InfiniteChannelTest is Test {
    address nick = makeAddr("nick");
    address uplink = makeAddr("uplink");
    address uplinkRewardsAddr = makeAddr("uplink rewards");
    address admin = makeAddr("admin");
    address sampleAdmin1 = makeAddr("sampleAdmin1");
    address sampleAdmin2 = makeAddr("sampleAdmin2");
    InfiniteChannel channelImpl;
    InfiniteChannel targetChannel;
    // IFees customFeesImpl;
    // ILogic logicImpl;
    IUpgradePath upgradePath;

    function setUp() public {
        upgradePath = new UpgradePath();
        upgradePath.initialize(admin);

        channelImpl = new InfiniteChannel(address(upgradePath));
        targetChannel = InfiniteChannel(payable(address(new InfiniteUplink1155(address(channelImpl)))));
    }

    function test_initialize() external {
        InfiniteChannel newChannelImpl = new InfiniteChannel(address(upgradePath));
        InfiniteChannel sampleChannel = InfiniteChannel(payable(address(new InfiniteUplink1155(address(channelImpl)))));
        sampleChannel.initialize("https://example.com/api/token/0", nick, new address[](0), new bytes[](0));
        assertEq("https://example.com/api/token/0", sampleChannel.getToken(0).uri);
        assertEq(0, sampleChannel.getToken(0).maxSupply);
        assertEq(0, sampleChannel.getToken(0).totalMinted);
    }
}
