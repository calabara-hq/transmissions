// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IVersionedContract } from "../interfaces/IVersionedContract.sol";

interface IChannelFactory is IVersionedContract {
    error AddressZero();
    error InvalidUpgrade();

    event FactoryInitialized();
    event SetupNewContract(
        address indexed contractAddress, string uri, address defaultAdmin, address[] managers, bytes transportConfig
    );

    function createInfiniteChannel(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions,
        bytes calldata transportConfig
    )
        external
        returns (address);

    function createFiniteChannel(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions,
        bytes calldata transportConfig
    )
        external
        returns (address);
}
