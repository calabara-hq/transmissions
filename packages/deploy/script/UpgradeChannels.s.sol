// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ChainConfig, Deployment, ScriptDeploymentConfig } from "../src/DeployConfig.sol";
import { DeployFns } from "../src/DeployFns.sol";
import "forge-std/Script.sol";
import { console } from "forge-std/Test.sol";

contract UpgradeChannels is DeployFns {
    function run() external returns (string memory) {
        vm.startBroadcast();

        Deployment memory deployment = getDeployment();

        address[] memory initialInfiniteChannelImpls = new address[](1);
        address[] memory initialFiniteChannelImpls = new address[](1);

        console.log("inf channel impl", deployment.infiniteChannelImpl);
        console.log("fin channel impl", deployment.finiteChannelImpl);

        initialInfiniteChannelImpls[0] = deployment.infiniteChannelImpl;
        initialFiniteChannelImpls[0] = deployment.finiteChannelImpl;

        console.log("deploy infinite channel");
        deployInfiniteChannelImpl(deployment);

        console.log("deploy finite channel");
        deployFiniteChannelImpl(deployment);

        address upgradedInfiniteChannelImpl = deployment.infiniteChannelImpl;
        address upgradedFiniteChannelImpl = deployment.finiteChannelImpl;

        console.log("register infinite upgrade path");
        registerUpgradePath(deployment, initialInfiniteChannelImpls, upgradedInfiniteChannelImpl);

        console.log("register finite upgrade path");
        registerUpgradePath(deployment, initialFiniteChannelImpls, upgradedFiniteChannelImpl);

        console.log("deploy new factory");
        deployFactoryImpl(deployment);

        console.log("upgrade factory");

        upgradeFactoryImpl(deployment);

        vm.stopBroadcast();
        return getDeploymentJSON(deployment);
    }
}
