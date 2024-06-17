// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IVersionedContract } from "../interfaces/IVersionedContract.sol";

interface IChannelFactory is IVersionedContract {
  function createInfiniteChannel(
    string calldata uri,
    string calldata name,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
  ) external returns (address);

  function createFiniteChannel(
    string calldata uri,
    string calldata name,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
  ) external payable returns (address);
}
