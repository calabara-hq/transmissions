// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ScriptDeploymentConfig, Deployment, ChainConfig} from "./DeployConfig.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
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
        vm.serializeAddress(deploymentJsonKey, INFINITE_TIMING, deployment.infiniteTiming);
        vm.serializeAddress(deploymentJsonKey, BASE_LOGIC, deployment.baseLogic);
        vm.serializeAddress(deploymentJsonKey, CHANNEL_IMPL, deployment.channelImpl);
        vm.serializeAddress(deploymentJsonKey, FACTORY_IMPL, deployment.factoryImpl);
        vm.serializeAddress(deploymentJsonKey, UPGRADE_PATH, deployment.upgradePath);
        deploymentJson = vm.serializeAddress(deploymentJsonKey, FACTORY_PROXY, deployment.factoryProxy);
    }

    function deployCustomFees(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();
        address customFees = address(new CustomFees(chainConfig.platformRecipient));
        deployment.customFees = customFees;
    }

    function deployInfiniteTiming(Deployment memory deployment) internal {
        address infiniteTiming = address(new InfiniteRound());
        deployment.infiniteTiming = infiniteTiming;
    }

    function deployBaseLogic(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();

        address baseLogic = address(new Logic(chainConfig.owner));
        deployment.baseLogic = baseLogic;
    }

    function deployUpgradePath(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();
        UpgradePath upgradePath = new UpgradePath();
        upgradePath.initialize(chainConfig.owner);
        deployment.upgradePath = address(upgradePath);
    }

    function deployChannelImpl(Deployment memory deployment) internal {
        if (deployment.upgradePath == address(0)) revert("Upgrade path not set");
        address channelImpl = address(new Channel(deployment.upgradePath));
        deployment.channelImpl = channelImpl;
    }

    function deployFactoryImpl(Deployment memory deployment) internal {
        if (deployment.channelImpl == address(0)) revert("Channel implementation not set");
        address factoryImpl = address(new ChannelFactory(Channel(deployment.channelImpl)));
        deployment.factoryImpl = factoryImpl;
    }

    function deployFactoryProxy(Deployment memory deployment) internal {
        ChainConfig memory chainConfig = getChainConfig();
        if (deployment.factoryImpl == address(0)) revert("Factory implementation not set");

        address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));

        ProxyShim proxyShim = new ProxyShim({_canUpgrade: deployer});

        address factoryProxy = address(new Uplink1155Factory(address(proxyShim), ""));

        IUpgradeableProxy proxy = IUpgradeableProxy(factoryProxy);
        proxy.upgradeToAndCall(deployment.factoryImpl, "");
        proxy.initialize(chainConfig.owner);

        deployment.factoryProxy = factoryProxy;
    }
}
