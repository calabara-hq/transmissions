// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { FiniteChannel } from "protocol/src/channel/transport/FiniteChannel.sol";
import { InfiniteChannel } from "protocol/src/channel/transport/InfiniteChannel.sol";
import { ChannelFactory } from "protocol/src/factory/ChannelFactory.sol";
import { CustomFees } from "protocol/src/fees/CustomFees.sol";
import { DynamicLogic } from "protocol/src/logic/DynamicLogic.sol";

import { ChainConfig, Deployment, ScriptDeploymentConfig } from "./DeployConfig.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

import "forge-std/Test.sol";
import { IUpgradePath } from "protocol/src/interfaces/IUpgradePath.sol";
import { FiniteUplink1155 } from "protocol/src/proxies/FiniteUplink1155.sol";
import { InfiniteUplink1155 } from "protocol/src/proxies/InfiniteUplink1155.sol";
import { Uplink1155Factory } from "protocol/src/proxies/Uplink1155Factory.sol";
import { ProxyShim } from "protocol/src/utils/ProxyShim.sol";
import { UpgradePath } from "protocol/src/utils/UpgradePath.sol";

interface IUpgradeableProxy {
    function upgradeToAndCall(address newImplementation, bytes memory data) external;

    function initialize(address newOwner) external;
}

abstract contract DeployFns is ScriptDeploymentConfig {
    using stdJson for string;

    /// @notice Get deployment configuration struct as JSON
    /// @param deployment deployment struct
    /// @return deploymentJson string JSON of the deployment info
    function getDeploymentJSON(Deployment memory deployment) internal returns (string memory deploymentJson) {
        string memory deploymentJsonKey = "deployment_json_file_key";
        vm.serializeAddress(deploymentJsonKey, CUSTOM_FEES, deployment.customFees);
        vm.serializeAddress(deploymentJsonKey, DYNAMIC_LOGIC, deployment.dynamicLogic);

        vm.serializeAddress(deploymentJsonKey, INFINITE_CHANNEL_IMPL, deployment.infiniteChannelImpl);
        vm.serializeAddress(deploymentJsonKey, FINITE_CHANNEL_IMPL, deployment.finiteChannelImpl);

        vm.serializeAddress(deploymentJsonKey, FACTORY_IMPL, deployment.factoryImpl);
        vm.serializeAddress(deploymentJsonKey, UPGRADE_PATH, deployment.upgradePath);

        deploymentJson = vm.serializeAddress(deploymentJsonKey, FACTORY_PROXY, deployment.factoryProxy);
    }

    function deployCustomFees(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();
        address customFees = address(new CustomFees(chainConfig.uplinkRewardsAddress));
        deployment.customFees = customFees;
    }

    function deployDynamicLogic(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();

        address dynamicLogic = address(new DynamicLogic(chainConfig.owner));
        deployment.dynamicLogic = dynamicLogic;
    }

    function deployUpgradePath(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();
        UpgradePath upgradePath = new UpgradePath();
        upgradePath.initialize(chainConfig.owner);
        deployment.upgradePath = address(upgradePath);
    }

    function deployInfiniteChannelImpl(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();

        if (deployment.upgradePath == address(0)) revert("Upgrade path not set");
        address infiniteChannelImpl = address(new InfiniteChannel(deployment.upgradePath, chainConfig.weth));
        deployment.infiniteChannelImpl = infiniteChannelImpl;
    }

    function deployFiniteChannelImpl(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();

        if (deployment.upgradePath == address(0)) revert("Upgrade path not set");
        address finiteChannelImpl = address(new FiniteChannel(deployment.upgradePath, chainConfig.weth));
        deployment.finiteChannelImpl = finiteChannelImpl;
    }

    function deployFactoryImpl(Deployment memory deployment) internal {
        if (deployment.infiniteChannelImpl == address(0)) revert("Infinite Channel implementation not set");
        if (deployment.finiteChannelImpl == address(0)) revert("Finite Channel implementation not set");
        address factoryImpl = address(new ChannelFactory(deployment.infiniteChannelImpl, deployment.finiteChannelImpl));
        deployment.factoryImpl = factoryImpl;
    }

    function deployFactoryProxy(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();
        if (deployment.factoryImpl == address(0)) revert("Factory implementation not set");

        address channelFactoryShim = address(new ProxyShim(chainConfig.owner));

        Uplink1155Factory factoryProxy = new Uplink1155Factory(channelFactoryShim, "");

        ChannelFactory channelFactory = ChannelFactory(address(factoryProxy));

        channelFactory.upgradeToAndCall(deployment.factoryImpl, "");
        channelFactory.initialize(chainConfig.owner);

        deployment.factoryProxy = address(factoryProxy);
    }

    function deployChannelProxies(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();
        if (deployment.infiniteChannelImpl == address(0)) revert("Infinite channel implementation not set");
        if (deployment.finiteChannelImpl == address(0)) revert("Finite channel implementation not set");

        // this does nothing beyond forcing the proxies to show up in deployment receipts for verification

        InfiniteUplink1155 infiniteChannelProxy = new InfiniteUplink1155(deployment.infiniteChannelImpl);
        FiniteUplink1155 finiteChannelProxy = new FiniteUplink1155(deployment.finiteChannelImpl);
    }

    function registerUpgradePath(
        Deployment memory deployment,
        address[] memory baseImpls,
        address upgradeImpl
    )
        internal
    {
        IUpgradePath upgradePath = IUpgradePath(deployment.upgradePath);
        upgradePath.registerUpgradePath(baseImpls, upgradeImpl);
    }

    function upgradeFactoryImpl(Deployment memory deployment) internal {
        // upgrade factory proxy to new implementation

        ChannelFactory channelFactory = ChannelFactory(address(deployment.factoryProxy));
        channelFactory.upgradeToAndCall(deployment.factoryImpl, "");
    }
}
