// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CustomFees} from "../../src/fees/CustomFees.sol";
import {InfiniteRound} from "../../src/timing/InfiniteRound.sol";
import {Logic} from "../../src/logic/Logic.sol";
import {CustomFees} from "../../src/fees/CustomFees.sol";
import {UpgradePath} from "../../src/utils/UpgradePath.sol";
import {ProxyShim} from "../../src/utils/ProxyShim.sol";
import {Uplink1155Factory} from "../../src/proxies/Uplink1155Factory.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {Channel} from "../../src/channel/Channel.sol";

interface IUpgradeableProxy {
    function upgradeTo(address newImplementation) external;

    function initialize(address newOwner) external;
}

library DeployLibrary {
/*     function deployCustomFees(address platformRecipient) external returns (address) {
        return address(new CustomFees(platformRecipient));
    }


    function deployUpgradePath(address owner) external returns (address) {
        UpgradePath upgradePath = new UpgradePath();
        upgradePath.initialize(owner);
        return address(upgradePath);
    }

    function deployFactoryProxy(address factoryImpl, address owner) external returns (address) {
        address channelFactoryShim = address(new ProxyShim(address(this)));
        Uplink1155Factory factoryProxy = new Uplink1155Factory(channelFactoryShim, "");

        ChannelFactory channelFactory = ChannelFactory(address(factoryProxy));
        channelFactory.upgradeToAndCall(factoryImpl, "");
        channelFactory.initialize(owner);

        return address(factoryProxy);
    }

    function deployFactoryImpl(address channelImpl) external returns (address) {
        ChannelFactory channelFactoryImpl = address(new ChannelFactory(Channel(channelImpl)));
        return address(channelFactoryImpl);
    }

    function deployChannelImpl(address upgradePath) external returns (address) {
        Channel channelImpl = new Channel(upgradePath);
        return address(channelImpl);
    } */
}
