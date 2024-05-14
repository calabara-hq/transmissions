// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IFees } from "../fees/CustomFees.sol";

import { ILogic } from "../logic/Logic.sol";

import { ITiming } from "../timing/InfiniteRound.sol";
import { Multicall } from "../utils/Multicall.sol";
import { IUpgradePath, UpgradePath } from "../utils/UpgradePath.sol";

import { IUpgradePath, UpgradePath } from "../utils/UpgradePath.sol";
import { ChannelStorageV1 } from "./ChannelStorageV1.sol";
import { ChannelV2 } from "./ChannelV2.sol";

import { AccessControlUpgradeable } from "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";
import { Initializable } from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { ERC1155Upgradeable } from "openzeppelin-contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";

import { ReentrancyGuardUpgradeable } from "openzeppelin-contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import { ERC1967Utils } from "openzeppelin-contracts/proxy/ERC1967/ERC1967Utils.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "openzeppelin-contracts/token/ERC20/utils/SafeERC20.sol";

contract InfiniteChannel is ChannelV2 {
    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    constructor(address _updgradePath) {
        upgradePath = IUpgradePath(_updgradePath);
    }

    /**
     * @notice Used to create a new token in the channel
     * Call the logic contract to check if the msg.sender is approved to create a new token
     * @param uri Token uri
     * @param author Token author
     * @param maxSupply Token supply
     * @return uint256 Id of newly created token
     */
    function createToken(
        string calldata uri,
        address author,
        uint256 maxSupply
    )
        public
        nonReentrant
        returns (uint256)
    {
        if (timingContract.getChannelState() != 1) {
            revert InvalidChannelState();
        }

        uint256 tokenId = _setupNewToken(uri, maxSupply, author);
        //timingContract.setTokenSale(tokenId);

        //_validateCreatorLogic(msg.sender);

        return tokenId;
    }

    function mint(
        address to,
        uint256 tokenId,
        uint256 amount,
        address mintReferral,
        bytes memory data
    )
        external
        payable
        override
        nonReentrant
    { }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */
}
