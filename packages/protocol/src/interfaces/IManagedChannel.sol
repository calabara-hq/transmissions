// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IManagedChannel {
    function isManager(address addr) external view returns (bool);
    function isAdmin(address addr) external view returns (bool);
    function setManagers(address[] memory managers) external;
}
