// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Deployment } from "../src/DeployConfig.sol";
import { DeployFns } from "../src/DeployFns.sol";
import "forge-std/Script.sol";
import { console } from "forge-std/Test.sol";

contract FullSuiteDeploy is DeployFns {
    function run() external returns (string memory) {
        vm.startBroadcast();

        Deployment memory deployment = getDeployment();

        console.log("deploy custom fees");
        deployCustomFees(deployment);

        console.log("deploy dynamic logic");
        deployDynamicLogic(deployment);

        console.log("deploy upgrade path");
        deployUpgradePath(deployment);

        console.log("deploy infinite channel impl");
        deployInfiniteChannelImpl(deployment);

        console.log("deploy finite channel impl");
        deployFiniteChannelImpl(deployment);

        console.log("deploy factory impl");
        deployFactoryImpl(deployment);

        console.log("deploy factory proxy");
        deployFactoryProxy(deployment);

        console.log("deploy channel proxies");
        deployChannelProxies(deployment);

        console.log("deployed to", chainId());

        vm.stopBroadcast();
        return getDeploymentJSON(deployment);
    }
}
