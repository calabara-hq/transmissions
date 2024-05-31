// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";

import { ChannelFactory } from "../../src/factory/ChannelFactory.sol";
import { IChannel } from "../../src/interfaces/IChannel.sol";

import { FiniteChannel } from "../../src/channel/transport/FiniteChannel.sol";
import { InfiniteChannel } from "../../src/channel/transport/InfiniteChannel.sol";

import { Uplink1155Factory } from "../../src/proxies/Uplink1155Factory.sol";
import { ProxyShim } from "../../src/utils/ProxyShim.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";
import { Test, console } from "forge-std/Test.sol";
import { ERC1155 } from "openzeppelin-contracts/token/ERC1155/ERC1155.sol";

contract ChannelFactoryTest is Test {
    address internal uplink = makeAddr("uplink");
    ChannelFactory internal channelFactoryImpl;
    ChannelFactory internal channelFactory;

    function setUp() public {
        // set up proxy
        address channelFactoryShim = address(new ProxyShim(uplink));
        Uplink1155Factory factoryProxy = new Uplink1155Factory(channelFactoryShim, "");
        // set up channel
        address infiniteChannelImpl = address(new InfiniteChannel(address(new UpgradePath()), address(0)));
        address finiteChannelImpl = address(new FiniteChannel(address(new UpgradePath()), address(0)));
        // set up factory
        channelFactoryImpl = new ChannelFactory(infiniteChannelImpl, finiteChannelImpl);
        channelFactory = ChannelFactory(address(factoryProxy));
        vm.startPrank(uplink);
        channelFactory.upgradeToAndCall(address(channelFactoryImpl), "");
        channelFactory.initialize(uplink);
        vm.stopPrank();
    }

    function test_factory_versioning() external {
        assertEq("1.0.0", channelFactory.contractVersion());
        assertEq("Uplink Channel Factory", channelFactory.contractName());
        assertEq(channelFactory.contractURI(), "https://github.com/calabara-hq/transmissions/packages/protocol");
    }

    function test_factory_initialize(address initialOwner) external {
        vm.assume(initialOwner != address(0));
        address payable proxyAddress = payable(
            address(
                new Uplink1155Factory(
                    address(channelFactoryImpl),
                    abi.encodeWithSelector(channelFactoryImpl.initialize.selector, initialOwner)
                )
            )
        );
        ChannelFactory proxy = ChannelFactory(proxyAddress);
        assertEq(proxy.owner(), initialOwner);
    }

    function test_factory_upgrade(address initialOwner) external {
        vm.assume(initialOwner != address(0));

        address newInfChannel = makeAddr("newInfChannel");
        address newFinChannel = makeAddr("newFinChannel");

        ChannelFactory newFactoryImpl = new ChannelFactory(newInfChannel, newFinChannel);

        // redeploy the proxy so initial owner is set in fuzz testing
        address payable proxyAddress = payable(
            address(
                new Uplink1155Factory(
                    address(channelFactoryImpl),
                    abi.encodeWithSelector(channelFactoryImpl.initialize.selector, initialOwner)
                )
            )
        );

        ChannelFactory proxy = ChannelFactory(proxyAddress);
        assertEq(proxy.owner(), initialOwner);
        vm.prank(initialOwner);
        proxy.upgradeToAndCall(address(newFactoryImpl), new bytes(0));
        assertEq(address(proxy.infiniteChannelImpl()), address(newInfChannel));
        assertEq(address(proxy.finiteChannelImpl()), address(newFinChannel));
    }

    function test_factory_createChannel() external {
        address newInfiniteChannel = channelFactory.createInfiniteChannel(
            "https://example.com/api/token/0", address(this), new address[](0), new bytes[](0), abi.encode(120)
        );

        uint40[] memory ranks = new uint40[](1);
        uint256[] memory allocations = new uint256[](1);
        ranks[0] = 1;
        allocations[0] = 100 ether;

        address newFiniteChannel = channelFactory.createFiniteChannel(
            "https://example.com/api/token/0",
            address(this),
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

        assertEq("https://example.com/api/token/0", IChannel(newInfiniteChannel).getToken(0).uri);
        assertEq("https://example.com/api/token/0", IChannel(newFiniteChannel).getToken(0).uri);
    }
}
