// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {IChannel, Channel} from "../../src/channel/Channel.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {Uplink1155} from "../../src/proxies/Uplink1155.sol";
import {IUpgradePath, UpgradePath} from "../../src/utils/UpgradePath.sol";

contract ChannelTest is Test {
    address nick = makeAddr("nick");
    address uplinkRewardsAddr = makeAddr("uplinkRewardsAddr");
    address admin = makeAddr("admin");
    address sampleAdmin1 = makeAddr("sampleAdmin1");
    address sampleAdmin2 = makeAddr("sampleAdmin2");
    Channel channelImpl;
    Channel targetChannel;
    IUpgradePath upgradePath;

    function setUp() public {
        upgradePath = new UpgradePath();
        upgradePath.initialize(admin);

        channelImpl = new Channel(address(upgradePath));
        targetChannel = Channel(payable(address(new Uplink1155(address(channelImpl)))));
        targetChannel.initialize("https://example.com/api/token/0", admin, new address[](0), new bytes[](0));
    }

    function test_upgrade() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new Channel(address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        targetChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_upgrade_unauthorized() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new Channel(address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        vm.stopPrank();
        vm.startPrank(nick);
        vm.expectRevert();
        targetChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_upgrade_unregisteredPath() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new Channel(address(0)));

        vm.startPrank(admin);
        vm.expectRevert();
        targetChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }
}
