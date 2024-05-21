// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVersionedContract {
    function contractVersion() external pure returns (string memory);
    function contractName() external pure returns (string memory);
    function contractURI() external pure returns (string memory);
}
