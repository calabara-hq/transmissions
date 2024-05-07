// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {Channel, IChannel} from "../../src/channel/Channel.sol";
import {ProxyShim} from "../../src/utils/ProxyShim.sol";
import {Uplink1155Factory} from "../../src/proxies/Uplink1155Factory.sol";
import {UpgradePath} from "../../src/utils/UpgradePath.sol";

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
        Channel channelImpl = new Channel(address(new UpgradePath()));
        // set up factory
        channelFactoryImpl = new ChannelFactory(channelImpl);
        channelFactory = ChannelFactory(address(factoryProxy));
        vm.startPrank(uplink);
        channelFactory.upgradeToAndCall(address(channelFactoryImpl), "");
        channelFactory.initialize(uplink);
        vm.stopPrank();
    }

    function test_contractVersion() external {
        assertEq("1.0.0", channelFactory.contractVersion());
    }

    function test_contractName() external {
        assertEq(channelFactory.contractName(), "Uplink Channel Factory");
    }

    function test_contractURI() external {
        assertEq(channelFactory.contractURI(), "https://github.com/calabara-hq/transmissions/");
    }

    function test_initialize(address initialOwner) external {
        vm.assume(initialOwner != address(0));
        address payable proxyAddress = payable(
            address(new Uplink1155Factory(address(channelFactoryImpl), abi.encodeWithSelector(channelFactoryImpl.initialize.selector, initialOwner)))
        );
        ChannelFactory proxy = ChannelFactory(proxyAddress);
        assertEq(proxy.owner(), initialOwner);
    }

    function test_upgrade(address initialOwner) external {
        vm.assume(initialOwner != address(0));

        IChannel newChannelContract = IChannel(makeAddr("newChannelContract"));

        ChannelFactory newFactoryImpl = new ChannelFactory(newChannelContract);

        // redeploy the proxy so initial owner is set in fuzz testing
        address payable proxyAddress = payable(
            address(new Uplink1155Factory(address(channelFactoryImpl), abi.encodeWithSelector(channelFactoryImpl.initialize.selector, initialOwner)))
        );

        ChannelFactory proxy = ChannelFactory(proxyAddress);
        assertEq(proxy.owner(), initialOwner);
        vm.prank(initialOwner);
        proxy.upgradeToAndCall(address(newFactoryImpl), new bytes(0));
        assertEq(address(proxy.channelImpl()), address(newChannelContract));
    }

    function test_createChannel() external {
        bytes[] memory setupActions = new bytes[](0);
        address newChannel = channelFactory.createChannel("https://example.com/api/token/0", address(this), new address[](0), setupActions);
        //assertEq("https://example.com/api/token/0", IChannel(newChannel).uri());
    }
}
