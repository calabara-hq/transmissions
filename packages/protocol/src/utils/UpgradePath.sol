// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

interface IUpgradePath {
    event UpgradePathContractInitialized();

    function initialize(address _initOwner) external;

    function isRegisteredUpgradePath(address baseImpl, address upgradeImpl) external view returns (bool);

    function registerUpgradePath(address[] memory baseImpls, address upgradeImpl) external;

    function removeUpgradePath(address baseImpl, address upgradeImpl) external;

    event UpgradeRegistered(address indexed baseImpl, address indexed upgradeImpl);
    event UpgradeRemoved(address indexed baseImpl, address indexed upgradeImpl);
}

contract UpgradePathStorage {
    mapping(address => mapping(address => bool)) public isAllowedUpgrade;
}

/**
 * used to manage allowed upgrade paths
 */
contract UpgradePath is IUpgradePath, UpgradePathStorage, OwnableUpgradeable {
    constructor() {}

    /**
     * @notice Factory initializer
     * @param _initOwner address of the owner
     */
    function initialize(address _initOwner) external initializer {
        __Ownable_init(_initOwner);
        emit UpgradePathContractInitialized();
    }

    /**
     * @notice The URI of the upgrade path contract
     */
    function contractURI() external pure returns (string memory) {
        return "https://github.com/calabara-hq/transmissions/";
    }

    /**
     * @notice The name of the upgrade path contract
     */
    function contractName() external pure returns (string memory) {
        return "Uplink Channel Upgrade Path";
    }

    /**
     * @notice If an implementation is registered as an optional upgrade
     * @param baseImpl The base implementation address
     * @param upgradeImpl The upgrade implementation address
     */
    function isRegisteredUpgradePath(address baseImpl, address upgradeImpl) public view returns (bool) {
        return isAllowedUpgrade[baseImpl][upgradeImpl];
    }

    /**
     * @notice Registers optional upgrades
     * @param baseImpls The base implementation addresses
     * @param upgradeImpl The upgrade implementation address
     */
    function registerUpgradePath(address[] memory baseImpls, address upgradeImpl) public onlyOwner {
        unchecked {
            for (uint256 i = 0; i < baseImpls.length; ++i) {
                isAllowedUpgrade[baseImpls[i]][upgradeImpl] = true;
                emit UpgradeRegistered(baseImpls[i], upgradeImpl);
            }
        }
    }

    /**
     * @notice Removes an upgrade
     * @param baseImpl The base implementation address
     * @param upgradeImpl The upgrade implementation address
     */
    function removeUpgradePath(address baseImpl, address upgradeImpl) public onlyOwner {
        delete isAllowedUpgrade[baseImpl][upgradeImpl];

        emit UpgradeRemoved(baseImpl, upgradeImpl);
    }
}
