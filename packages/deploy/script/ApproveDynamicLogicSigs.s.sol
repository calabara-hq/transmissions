// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Deployment } from "../src/DeployConfig.sol";

import { ChainConfig, Deployment, ScriptDeploymentConfig } from "../src/DeployConfig.sol";
import { IERC1155 } from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "forge-std/Script.sol";
import { console } from "forge-std/Test.sol";
import { DynamicLogic } from "protocol/src/logic/DynamicLogic.sol";

contract ApproveLogic is ScriptDeploymentConfig {
    function run() external returns (string memory) {
        vm.startBroadcast();

        Deployment memory deployment = getDeployment();

        DynamicLogic logicContract = DynamicLogic(deployment.dynamicLogic);

        bytes4 erc20Sig = IERC20.balanceOf.selector;
        bytes4 erc721Sig = IERC721.balanceOf.selector;
        bytes4 erc1155Sig = IERC1155.balanceOf.selector;

        logicContract.approveLogic(erc20Sig, 0);
        logicContract.approveLogic(erc721Sig, 0);
        logicContract.approveLogic(erc1155Sig, 0);

        console.log("approved token balance logic");

        vm.stopBroadcast();
    }
}
