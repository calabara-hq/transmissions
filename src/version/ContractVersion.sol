// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

contract ContractVersion {
    function contractVersion() external pure returns (string memory) {
        return "1.0.0";
    }
}