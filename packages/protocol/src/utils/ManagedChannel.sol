// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IManagedChannel } from "../interfaces/IManagedChannel.sol";
import { IUpgradePath } from "../interfaces/IUpgradePath.sol";
import { AccessControlUpgradeable } from "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";
import { AccessControlEnumerableUpgradeable } from
    "openzeppelin-contracts-upgradeable/access/extensions/AccessControlEnumerableUpgradeable.sol";
import { IAccessControl } from "openzeppelin-contracts/access/IAccessControl.sol";

import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { ERC1155Upgradeable } from "openzeppelin-contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import { ReentrancyGuardUpgradeable } from "openzeppelin-contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import { ERC1967Utils } from "openzeppelin-contracts/proxy/ERC1967/ERC1967Utils.sol";
/**
 * @title ManagedChannel
 * @author nick
 * @notice Contract module which provides access control, reentrancy, and upgradeability mechanisms.
 * Access is governed by an admin role and a manager role.
 * @dev The manager role is a sub-authority of the admin role, which can only be set by the admin.
 * The admin role is the default role, and has the highest authority.
 * The manager role has the authority to manage the contract, but cannot grant/manage other managers.
 * Granting / Revoking roles directly is not allowed. Use `setManagers` to set the new managers for the contract.
 * Use `transferAdmin` to transfer the admin role to a new address.
 */

contract ManagedChannel is
    AccessControlEnumerableUpgradeable,
    IManagedChannel,
    ERC1155Upgradeable,
    UUPSUpgradeable,
    ReentrancyGuardUpgradeable
{
    /* -------------------------------------------------------------------------- */
    /*                                   ERRORS                                   */
    /* -------------------------------------------------------------------------- */
    error Unauthorized();
    error InvalidUpgrade();

    /* -------------------------------------------------------------------------- */
    /*                                   EVENTS                                   */
    /* -------------------------------------------------------------------------- */

    event ManagersUpdated(address[] managers);
    event ManagerRenounced(address indexed manager);
    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);

    /* -------------------------------------------------------------------------- */
    /*                                   MODIFIERS                                */
    /* -------------------------------------------------------------------------- */

    modifier onlyAdminOrManager() {
        _requireAdminOrManager(msg.sender);
        _;
    }

    modifier onlyAdmin() {
        _requireAdmin(msg.sender);
        _;
    }

    /* -------------------------------------------------------------------------- */
    /*                                   STORAGE                                  */
    /* -------------------------------------------------------------------------- */

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    IUpgradePath internal immutable upgradePath;

    /* -------------------------------------------------------------------------- */
    /*                          CONSTRUCTOR & INITIALIZER                         */
    /* -------------------------------------------------------------------------- */

    constructor(address _upgradePath) {
        upgradePath = IUpgradePath(_upgradePath);
    }

    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    function isManager(address addr) external view returns (bool) {
        return hasRole(MANAGER_ROLE, addr) || hasRole(DEFAULT_ADMIN_ROLE, addr);
    }

    function isAdmin(address addr) external view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, addr);
    }

    /**
     * @notice This function will always revert. Roles cannot be revoked directly.
     * @notice Use `setManagers` to set the new managers for the contract.
     * @notice Use `transferAdmin` to transfer the admin role to a new address
     */
    function revokeRole(bytes32 role, address account) public override(AccessControlUpgradeable, IAccessControl) {
        revert("Roles cannot be revoked directly");
    }

    /**
     * @notice This function will always revert. Roles cannot be granted directly.
     * @notice Use `setManagers` to set the new managers for the contract.
     * @notice Use `transferAdmin` to transfer the admin role to a new address.
     */
    function grantRole(bytes32 role, address account) public override(AccessControlUpgradeable, IAccessControl) {
        revert("Roles cannot be granted directly");
    }

    /**
     * @notice This function allows managers to renounce their role if their private key is compromised.
     * @notice If an admin account is compromised,  use `transferAdmin` instead.
     * @param role role to renounce.
     */
    function renounceRole(
        bytes32 role,
        address callerConfirmation
    )
        public
        override(AccessControlUpgradeable, IAccessControl)
    {
        if (role == DEFAULT_ADMIN_ROLE) {
            revert("Cannot renounce admin role. Use transferAdmin instead.");
        }

        _revokeRole(MANAGER_ROLE, msg.sender);

        emit ManagerRenounced(msg.sender);
    }

    /**
     * @notice Transfer the admin role to a new address
     */
    function transferAdmin(address newAdmin) external onlyAdmin {
        _grantRole(DEFAULT_ADMIN_ROLE, newAdmin);
        _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);

        emit AdminTransferred(msg.sender, newAdmin);
    }

    /**
     * @notice Revoke all existing managers and set the new managers for the contract
     * @notice Only callable by the admin
     * @param managers array of manager addresses
     */
    function setManagers(address[] memory managers) public onlyAdmin {
        uint256 numManagers = getRoleMemberCount(MANAGER_ROLE);
        for (uint256 i; i < numManagers; i++) {
            _revokeRole(MANAGER_ROLE, getRoleMember(MANAGER_ROLE, 0));
        }

        for (uint256 i; i < managers.length; i++) {
            _grantRole(MANAGER_ROLE, managers[i]);
        }

        emit ManagersUpdated(managers);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155Upgradeable, AccessControlEnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _requireAdminOrManager(address account) internal view {
        if (!hasRole(DEFAULT_ADMIN_ROLE, account) && !hasRole(MANAGER_ROLE, account)) {
            revert Unauthorized();
        }
    }

    function _requireAdmin(address account) internal view {
        if (!hasRole(DEFAULT_ADMIN_ROLE, account)) {
            revert Unauthorized();
        }
    }

    /* -------------------------------------------------------------------------- */
    /*                                 UPGRADES                                   */
    /* -------------------------------------------------------------------------- */

    function _authorizeUpgrade(address newImplementation) internal view override onlyAdminOrManager {
        if (!upgradePath.isRegisteredUpgradePath(_implementation(), newImplementation)) {
            revert InvalidUpgrade();
        }
    }

    function _implementation() internal view returns (address) {
        return ERC1967Utils.getImplementation();
    }
}
