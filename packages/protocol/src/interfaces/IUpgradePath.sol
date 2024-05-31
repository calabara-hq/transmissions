// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IVersionedContract } from "../interfaces/IVersionedContract.sol";

interface IUpgradePath is IVersionedContract {
    event UpgradePathContractInitialized();
    event UpgradeRegistered(address indexed baseImpl, address indexed upgradeImpl);
    event UpgradeRemoved(address indexed baseImpl, address indexed upgradeImpl);

    function initialize(address _initOwner) external;

    function isRegisteredUpgradePath(address baseImpl, address upgradeImpl) external view returns (bool);

    function registerUpgradePath(address[] memory baseImpls, address upgradeImpl) external;

    function removeUpgradePath(address baseImpl, address upgradeImpl) external;
}
