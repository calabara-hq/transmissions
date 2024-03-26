// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {Channel} from "../../src/channel/ChannelImpl.sol";
import {CustomSaleStrategy} from "../../src/sales/CustomSaleStrategy.sol";
import {ProxyShim} from "../../src/utils/ProxyShim.sol";
import {Uplink1155Factory} from "../../src/proxies/Uplink1155Factory.sol";
import {IChannel} from "../../src/interfaces/IChannel.sol";
import {ISales} from "../../src/sales/ISales.sol";

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
        // set up channel and sales contracts
        Channel channelImpl = new Channel(uplink);
        ISales paidSalesImpl = CustomSaleStrategy(address(0));
        // set up factory
        channelFactoryImpl = new ChannelFactory(channelImpl, paidSalesImpl);
        channelFactory = ChannelFactory(address(factoryProxy));
        vm.startPrank(uplink);
        channelFactory.upgradeToAndCall(address(channelFactoryImpl), "");
        vm.stopPrank();
    }

    function test_createChannel() public {
        // Create a new ERC1155 contract

        vm.startPrank(nick);
        bytes[] memory setupActions = new bytes[](1);
        setupActions[0] = abi.encodeWithSelector(
            CustomSaleStrategy.initializeSaleStrategy.selector,
            nick
        );

        address channelAddress = channelFactory.createChannel(
            "https://example.com/api/token/",
            setupActions
        );
        console.log("Channel Address:", channelAddress);
        vm.stopPrank();

        // console.log(Channel(channelAddress).getBit());

        // // Print the deployedChannels array
        // console.log("Deployed channels:");
        // for (uint256 i = 0; i < channelFactory.deployedChannelsLength(); i++) {
        //     address deployedChannelAddress = channelFactory.deployedChannels(i);
        //     console.log(deployedChannelAddress);
        // }

        // Channel channelInstance = Channel(channelAddress);

        // console.log("Constant Channel Fees:");
        // FeePair[] memory channelFees = channelInstance.getConstantFees();
        // for (uint256 i = 0; i < channelFees.length; i++) {
        //     console.log(channelFees[i].addr, channelFees[i].amount);
        // }

        // console.log("Runtime Channel Fees:");
        // uint256[] memory runtimeFees = channelInstance.getRuntimeFees();
        // for (uint256 i = 0; i < runtimeFees.length; i++) {
        //     console.log(runtimeFees[i]);
        // }

        // console.log("Channel Mint Price:", channelInstance.getChannelMintPrice());
    }
}
