// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface IChannelInitializer {
    function initialize(string memory newContractURI, bytes[] calldata setupActions) external;
}
