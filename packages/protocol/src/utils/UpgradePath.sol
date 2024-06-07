// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IUpgradePath } from "../interfaces/IUpgradePath.sol";

import { OwnableUpgradeable } from "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";
import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title Upgrade Path
 * @author nick
 * @notice used to manage allowed channel upgrade paths
 */
contract UpgradePath is IUpgradePath, OwnableUpgradeable {
  /* -------------------------------------------------------------------------- */
  /*                                   EVENTS                                   */
  /* -------------------------------------------------------------------------- */

  event UpgradePathContractInitialized();
  event UpgradeRegistered(address indexed baseImpl, address indexed upgradeImpl);
  event UpgradeRemoved(address indexed baseImpl, address indexed upgradeImpl);

  /* -------------------------------------------------------------------------- */
  /*                                   STORAGE                                  */
  /* -------------------------------------------------------------------------- */

  mapping(address => mapping(address => bool)) public isAllowedUpgrade;

  /* -------------------------------------------------------------------------- */
  /*                          CONSTRUCTOR & INITIALIZER                         */
  /* -------------------------------------------------------------------------- */

  constructor() {}

  /**
   * @notice Factory initializer
   * @param _initOwner address of the owner
   */
  function initialize(address _initOwner) external initializer {
    __Ownable_init(_initOwner);
    emit UpgradePathContractInitialized();
  }

  /* -------------------------------------------------------------------------- */
  /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
  /* -------------------------------------------------------------------------- */

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

  /* -------------------------------------------------------------------------- */
  /*                                  VERSIONING                                */
  /* -------------------------------------------------------------------------- */

  /**
   * @notice Returns the contract version
   * @return string contract version
   */
  function contractVersion() external pure returns (string memory) {
    return "1.0.0";
  }

  /**
   * @notice Returns the contract uri
   * @return string contract uri
   */
  function contractURI() external pure returns (string memory) {
    return "https://github.com/calabara-hq/transmissions/packages/protocol";
  }

  /**
   * @notice Returns the contract name
   * @return string contract name
   */
  function contractName() external pure returns (string memory) {
    return "Upgrade Path";
  }
}
