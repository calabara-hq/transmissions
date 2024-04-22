// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {Channel} from "../../src/channel/ChannelImpl.sol";
import {ProxyShim} from "../../src/utils/ProxyShim.sol";
import {Uplink1155Factory} from "../../src/proxies/Uplink1155Factory.sol";
import {IChannel} from "../../src/interfaces/IChannel.sol";

contract ChannelFactoryTest is Test {
    address nick = 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C;
    address internal uplink;
    ChannelFactory internal channelFactoryImpl;
    ChannelFactory internal channelFactory;
    // UpgradeGate internal upgradeGate;

    function setUp() public {
        uplink = makeAddr("uplink");

        // set up proxy
        address channelFactoryShim = address(new ProxyShim(uplink));
        Uplink1155Factory factoryProxy = new Uplink1155Factory(
            channelFactoryShim,
            ""
        );
        // set up channel
        Channel channelImpl = new Channel(uplink);
        // set up factory
        channelFactoryImpl = new ChannelFactory(
            channelImpl
        );
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

    // function test_upgrade(address initialOwner) external {
    // }

    // function test_upgradeFailsWithDifferentContractName(address initialOwner) external {
    // }

    // function test_createChannel() public {
    //     // Create a new ERC1155 contract

    //     vm.startPrank(nick);
    //     console.log("nick address", address(nick));
    //     bytes[] memory setupActions = new bytes[](1);
    //     bytes memory feeArgs = abi.encode(
    //         address(0),
    //         10000000000000000,
    //         10000000000000000,
    //         30000000000000000,
    //         10000000000000000,
    //         10000000000000000
    //     );
    //     setupActions[0] = abi.encodeWithSelector(
    //         IChannel.setChannelSaleLogic.selector,
    //         customSaleStrategy,
    //         abi.encodeWithSelector(
    //             customSaleStrategy.initializeSaleStrategy.selector,
    //             feeArgs
    //         )
    //     );

    //     address channelAddress = channelFactory.createChannel(
    //         "https://example.com/api/token/",
    //         setupActions
    //     );
    //     console.log("Channel Address:", channelAddress);
    //     Channel channelInstance = Channel(channelAddress);
    //     console.log(
    //         "Mint Price:",
    //         customSaleStrategy.getMintPrice(channelAddress)
    //     );

    //     vm.stopPrank();

    // }
}
