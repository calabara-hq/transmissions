// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";

import { FiniteChannel } from "../../src/channel/transport/FiniteChannel.sol";
import { InfiniteChannel } from "../../src/channel/transport/InfiniteChannel.sol";
import { Test, console } from "forge-std/Test.sol";

import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";
import { Test, console } from "forge-std/Test.sol";

import { FiniteUplink1155 } from "../../src/proxies/FiniteUplink1155.sol";
import { InfiniteUplink1155 } from "../../src/proxies/InfiniteUplink1155.sol";

contract ChannelTest is Test {
    event Upgraded(address indexed implementation);

    address nick = makeAddr("nick");
    address admin = makeAddr("admin");

    InfiniteChannel infChannelImpl;
    InfiniteChannel proxiedInfChannel;

    FiniteChannel finChannelImpl;
    FiniteChannel proxiedFinChannel;

    IUpgradePath upgradePath;

    function setUp() public {
        upgradePath = new UpgradePath();
        upgradePath.initialize(admin);

        infChannelImpl = new InfiniteChannel(address(upgradePath), address(0));
        proxiedInfChannel = InfiniteChannel(payable(address(new InfiniteUplink1155(address(infChannelImpl)))));
        proxiedInfChannel.initialize(
            "https://example.com/api/token/0", admin, new address[](0), new bytes[](0), abi.encode(100)
        );

        finChannelImpl = new FiniteChannel(address(upgradePath), address(0));
        proxiedFinChannel = FiniteChannel(payable(address(new FiniteUplink1155(address(finChannelImpl)))));

        uint40[] memory ranks = new uint40[](1);
        uint256[] memory allocations = new uint256[](1);
        ranks[0] = 1;
        allocations[0] = 100 ether;

        vm.deal(address(this), 100 ether);
        proxiedFinChannel.initialize{ value: 100 ether }(
            "https://example.com/api/token/0",
            admin,
            new address[](0),
            new bytes[](0),
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: uint80(block.timestamp),
                    mintStart: uint80(block.timestamp + 1),
                    mintEnd: uint80(block.timestamp + 20),
                    userCreateLimit: 100,
                    userMintLimit: 100,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: ranks,
                        allocations: allocations,
                        totalAllocation: 100 ether,
                        token: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
                    })
                })
            )
        );
    }

    function test_upgrade_events() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(infChannelImpl);

        address newImpl = address(new InfiniteChannel(address(upgradePath), address(0)));

        vm.startPrank(admin);

        vm.expectEmit();
        emit IUpgradePath.UpgradeRegistered(oldImpls[0], newImpl);
        upgradePath.registerUpgradePath(oldImpls, newImpl);

        vm.expectEmit();
        emit Upgraded(newImpl);
        proxiedInfChannel.upgradeToAndCall(newImpl, new bytes(0));

        vm.expectEmit();
        emit IUpgradePath.UpgradeRemoved(oldImpls[0], newImpl);
        upgradePath.removeUpgradePath(oldImpls[0], newImpl);

        vm.stopPrank();
    }

    function test_upgrade_versioning() external {
        assertEq(upgradePath.contractVersion(), "1.0.0");
        assertEq(upgradePath.contractURI(), "https://github.com/calabara-hq/transmissions/packages/protocol");
        assertEq(upgradePath.contractName(), "Upgrade Path");
    }

    function test_upgrade_infChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(infChannelImpl);

        address newImpl = address(new InfiniteChannel(address(upgradePath), address(0)));

        vm.startPrank(admin);

        upgradePath.registerUpgradePath(oldImpls, newImpl);
        proxiedInfChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_upgrade_finChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(finChannelImpl);

        address newImpl = address(new FiniteChannel(address(upgradePath), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        proxiedFinChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_upgradeUnauthorized_infChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(infChannelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        vm.stopPrank();

        vm.expectRevert();
        proxiedInfChannel.upgradeToAndCall(newImpl, new bytes(0));
    }

    function test_upgradeUnauthorized_finChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(finChannelImpl);

        address newImpl = address(new FiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        vm.stopPrank();

        vm.expectRevert();
        proxiedFinChannel.upgradeToAndCall(newImpl, new bytes(0));
    }

    function test_upgradeUnregisteredPath_infChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(infChannelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        vm.expectRevert();
        proxiedInfChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_upgradeUnregisteredPath_finChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(finChannelImpl);

        address newImpl = address(new FiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        vm.expectRevert();
        proxiedFinChannel.upgradeToAndCall(newImpl, new bytes(0));
        vm.stopPrank();
    }

    function test_storageAfterUpgrade_infChannel() external {
        proxiedInfChannel.createToken("http://test/1", address(0), 100);

        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(infChannelImpl);

        address newImpl = address(new InfiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        proxiedInfChannel.upgradeToAndCall(newImpl, new bytes(0));
        assertEq(proxiedInfChannel.getToken(1).uri, "http://test/1");

        vm.stopPrank();
    }

    function test_storageAfterUpgrade_finChannel() external {
        proxiedFinChannel.createToken("http://test/1", address(0), 100);

        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(finChannelImpl);

        address newImpl = address(new FiniteChannel(address(0), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        proxiedFinChannel.upgradeToAndCall(newImpl, new bytes(0));
        assertEq(proxiedFinChannel.getToken(1).uri, "http://test/1");

        vm.stopPrank();
    }

    function test_removeUpgrade_infChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(infChannelImpl);

        address newImpl = address(new InfiniteChannel(address(upgradePath), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        assertTrue(upgradePath.isRegisteredUpgradePath(oldImpls[0], newImpl));
        upgradePath.removeUpgradePath(oldImpls[0], newImpl);
        assertFalse(upgradePath.isRegisteredUpgradePath(oldImpls[0], newImpl));
        vm.stopPrank();
    }

    function test_removeUpgrade_finChannel() external {
        address[] memory oldImpls = new address[](1);
        oldImpls[0] = address(finChannelImpl);

        address newImpl = address(new FiniteChannel(address(upgradePath), address(0)));

        vm.startPrank(admin);
        upgradePath.registerUpgradePath(oldImpls, newImpl);
        assertTrue(upgradePath.isRegisteredUpgradePath(oldImpls[0], newImpl));
        upgradePath.removeUpgradePath(oldImpls[0], newImpl);
        assertFalse(upgradePath.isRegisteredUpgradePath(oldImpls[0], newImpl));
        vm.stopPrank();
    }
}
