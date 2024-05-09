// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ChannelV2} from "./ChannelV2.sol";
import {IUpgradePath, UpgradePath} from "../utils/UpgradePath.sol";
import {ERC1155Upgradeable} from "openzeppelin-contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import {ChannelStorageV1} from "./ChannelStorageV1.sol";
import {Multicall} from "../utils/Multicall.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IFees} from "../fees/CustomFees.sol";
import {AccessControlUpgradeable} from "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ILogic} from "../logic/Logic.sol";
import {IUpgradePath, UpgradePath} from "../utils/UpgradePath.sol";
import {ERC1967Utils} from "openzeppelin-contracts/proxy/ERC1967/ERC1967Utils.sol";
import {ITiming} from "../timing/InfiniteRound.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuardUpgradeable} from "openzeppelin-contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/utils/ReentrancyGuard.sol";

contract InfiniteChannel is Initializable, ChannelV2, ReentrancyGuard {
    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    function initialize(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions
    ) external nonReentrant initializer {
        _initializeChannel(uri, defaultAdmin, managers, setupActions);
    }

    function createToken(string memory newURI, uint256 maxSupply) external override returns (uint256) {
        return _setupNewToken(newURI, maxSupply, msg.sender);
    }

    function mint(address to, uint256 tokenId, uint256 amount, address mintReferral, bytes memory data)
        external
        payable
        override
        nonReentrant
    {}

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */
}
