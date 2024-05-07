// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
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
    }

    function test_managers_callerNotAdminAfterInitialization() external {
        address[] memory channelManagers = new address[](1);
        channelManagers[0] = sampleAdmin1;

        targetChannel.initialize("https://example.com/api/token/0", nick, channelManagers, new bytes[](0));

        // check managers after initialization
        assertTrue(targetChannel.isManager(nick));
        assertTrue(targetChannel.isManager(sampleAdmin1));

        assertFalse(targetChannel.isManager(makeAddr("non admin")));
        // ensure the initializer is no longer a manager
        assertFalse(targetChannel.isManager(address(this)));
    }

    function test_managers_shouldRevertIfCallerHasManagerRole() external {
        address[] memory channelManagers = new address[](1);
        channelManagers[0] = sampleAdmin1;

        targetChannel.initialize("https://example.com/api/token/0", nick, channelManagers, new bytes[](0));

        // verify that a manager cannot revoke another manager
        vm.startPrank(sampleAdmin1);
        assertTrue(targetChannel.isManager(sampleAdmin1));
        vm.expectRevert();
        targetChannel.revokeManager(sampleAdmin2);
        assertTrue(targetChannel.isManager(sampleAdmin1));
        vm.stopPrank();
    }

    // verify that a manager cannot grant another manager
    // vm.expectRevert();
    // vm.startPrank(sampleAdmin2);
    // targetChannel.revokeManager(sampleAdmin1);
    // vm.stopPrank();

    function test_managers_revokeManagerRoleWithAdminCaller() external {
        address[] memory channelManagers = new address[](1);
        channelManagers[0] = sampleAdmin1;

        targetChannel.initialize("https://example.com/api/token/0", nick, channelManagers, new bytes[](0));

        // verify that the admin can revoke another manager
        vm.startPrank(nick);
        assertTrue(targetChannel.isManager(sampleAdmin1));
        targetChannel.revokeManager(sampleAdmin1);
        assertFalse(targetChannel.isManager(sampleAdmin1));
        vm.stopPrank();
    }

    function test_managers_adminCanAddNewManager() external {
        address[] memory channelManagers = new address[](1);
        channelManagers[0] = sampleAdmin1;

        targetChannel.initialize("https://example.com/api/token/0", nick, channelManagers, new bytes[](0));

        address[] memory newManagers = new address[](1);
        newManagers[0] = makeAddr("new manager");

        // verify that admin can add another manager
        vm.startPrank(nick);
        targetChannel._setManagers(newManagers);
        vm.stopPrank();
    }

    function test_managers_revertManagerAddNewManager() external {
        address[] memory channelManagers = new address[](1);
        channelManagers[0] = sampleAdmin1;

        targetChannel.initialize("https://example.com/api/token/0", nick, channelManagers, new bytes[](0));

        address[] memory newManagers = new address[](1);
        newManagers[0] = makeAddr("new manager");

        // verify that a manager cannot add another manager
        vm.startPrank(sampleAdmin1);
        vm.expectRevert();
        targetChannel._setManagers(newManagers);
        vm.stopPrank();
    }
}
