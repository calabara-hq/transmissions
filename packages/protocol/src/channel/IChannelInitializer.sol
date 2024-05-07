// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IChannelInitializer {
    function initialize(
        string memory newContractURI,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions
    ) external;
}
