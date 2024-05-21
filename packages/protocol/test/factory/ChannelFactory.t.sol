// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";

import { ChannelFactory } from "../../src/factory/ChannelFactory.sol";
import { IChannel } from "../../src/interfaces/IChannel.sol";

import { InfiniteChannel } from "../../src/channel/InfiniteChannel.sol";
import { Uplink1155Factory } from "../../src/proxies/Uplink1155Factory.sol";
import { ProxyShim } from "../../src/utils/ProxyShim.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";
import { Test, console } from "forge-std/Test.sol";
import { ERC1155 } from "openzeppelin-contracts/token/ERC1155/ERC1155.sol";

contract ChannelFactoryTest is Test {
    address nick = 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C;
    address internal uplink = makeAddr("uplink");
    ChannelFactory internal channelFactoryImpl;
    ChannelFactory internal channelFactory;

    function setUp() public {
        // set up proxy
        address channelFactoryShim = address(new ProxyShim(uplink));
        Uplink1155Factory factoryProxy = new Uplink1155Factory(channelFactoryShim, "");
        // set up channel
        address infiniteChannelImpl = address(new InfiniteChannel(address(new UpgradePath()), address(0)));
        // set up factory
        channelFactoryImpl = new ChannelFactory(infiniteChannelImpl);
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

        address newChannelContract = makeAddr("newChannelContract");

        ChannelFactory newFactoryImpl = new ChannelFactory(newChannelContract);

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
        assertEq(address(proxy.infiniteChannelImpl()), address(newChannelContract));
    }

    function test_factory_createChannel() external {
        address newChannel = channelFactory.createInfiniteChannel(
            "https://example.com/api/token/0", address(this), new address[](0), new bytes[](0), abi.encode(120)
        );
        assertEq("https://example.com/api/token/0", IChannel(newChannel).getToken(0).uri);
    }
}
