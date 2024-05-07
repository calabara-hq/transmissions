// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import {DeployFns} from "../src/DeployFns.sol";
import {Deployment} from "../src/DeployConfig.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";

contract FullSuiteDeploy is DeployFns {
    function run() external returns (string memory) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Deployment memory deployment = getDeployment();

        console.log("deploy custom fees");
        deployCustomFees(deployment);

        console.log("deploy infinite timing");
        deployInfiniteTiming(deployment);

        console.log("deploy base logic");
        deployBaseLogic(deployment);

        console.log("deploy upgrade path");
        deployUpgradePath(deployment);

        console.log("deploy channel impl");
        deployChannelImpl(deployment);

        console.log("deploy factory impl");
        deployFactoryImpl(deployment);

        console.log("deploy factory proxy");
        deployFactoryProxy(deployment);

        console.log("deployed to base sepolia", "\u2713");

        vm.stopBroadcast();
        return getDeploymentJSON(deployment);
    }
}
