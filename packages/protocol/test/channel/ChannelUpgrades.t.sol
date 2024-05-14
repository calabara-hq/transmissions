// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { InfiniteChannel } from "../../src/channel/InfiniteChannel.sol";
import { Test, console } from "forge-std/Test.sol";

import { IUpgradePath, UpgradePath } from "../../src/utils/UpgradePath.sol";
import { Test, console } from "forge-std/Test.sol";

import { InfiniteUplink1155 } from "../../src/proxies/InfiniteUplink1155.sol";

contract ChannelTest is Test {
    address nick = makeAddr("nick");
    address admin = makeAddr("admin");

    InfiniteChannel channelImpl;
    InfiniteChannel targetChannel;
    IUpgradePath upgradePath;

    function setUp() public {
        upgradePath = new UpgradePath();
        upgradePath.initialize(admin);

        channelImpl = new InfiniteChannel(address(upgradePath), address(0));
        targetChannel = InfiniteChannel(payable(address(new InfiniteUplink1155(address(channelImpl)))));
        targetChannel.initialize(
            "https://example.com/api/token/0", admin, new address[](0), new bytes[](0), abi.encode(100)
        );
    }

    function test_upgrade() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        targetChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_upgrade_unauthorized() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        vm.stopPrank();

        vm.expectRevert();
        targetChannel.upgradeToAndCall(newImpl, new bytes(0));
    }

    function test_upgrade_unregisteredPath() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        vm.expectRevert();
        targetChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_storageAfterUpgrade() external {
        //channelImpl.initialize(_uri, _defaultAdmin, _managers, _setupActions);
        targetChannel.createToken("http://test/1", address(0), 100);

        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(channelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        targetChannel.upgradeToAndCall(newImpl, new bytes(0));
        assertEq(targetChannel.getToken(1).uri, "http://test/1");

        vm.stopPrank();
    }
}
