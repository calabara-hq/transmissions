// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IManagedChannel {
    error UNAUTHORIZED();
    error INVALID_UPGRADE();

    event ManagersUpdated(address[] managers);
    event ManagerRenounced(address indexed manager);
    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);

    function isManager(address addr) external view returns (bool);
    function isAdmin(address addr) external view returns (bool);
    function setManagers(address[] memory managers) external;
}
