// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";
import { InfiniteChannel } from "../../src/channel/InfiniteChannel.sol";
import { Test, console } from "forge-std/Test.sol";

import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";
import { Test, console } from "forge-std/Test.sol";

import { InfiniteUplink1155 } from "../../src/proxies/InfiniteUplink1155.sol";

import { ChannelHarness } from "../utils/ChannelHarness.t.sol";

contract ChannelTest is Test {
    address nick = makeAddr("nick");
    address admin = makeAddr("admin");

    ChannelHarness channelImpl;
    InfiniteChannel infChannel;

    IUpgradePath upgradePath;

    function setUp() public {
        upgradePath = new UpgradePath();
        upgradePath.initialize(admin);

        channelImpl = new ChannelHarness(address(upgradePath), address(0));
        infChannel = InfiniteChannel(payable(address(new InfiniteUplink1155(address(channelImpl)))));
        infChannel.initialize(
            "https://example.com/api/token/0", admin, new address[](0), new bytes[](0), abi.encode(100)
        );
    }

    function test_upgrade_infChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        infChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_upgradeUnauthorized_infChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        vm.stopPrank();

        vm.expectRevert();
        infChannel.upgradeToAndCall(newImpl, new bytes(0));
    }

    function test_upgradeUnregisteredPath_infChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        vm.expectRevert();
        infChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_storageAfterUpgrade_infChannel() external {
        //channelImpl.initialize(_uri, _defaultAdmin, _managers, _setupActions);
        infChannel.createToken("http://test/1", address(0), 100);

        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        infChannel.upgradeToAndCall(newImpl, new bytes(0));
        assertEq(infChannel.getToken(1).uri, "http://test/1");

        vm.stopPrank();
    }
}
