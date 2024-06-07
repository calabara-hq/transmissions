// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IVersionedContract } from "../interfaces/IVersionedContract.sol";

interface ILogic is IVersionedContract {
  function approveLogic(bytes4 signature, uint256 calldataAddressPosition) external;

  function setCreatorLogic(bytes memory data) external;
  function setMinterLogic(bytes memory data) external;

  function calculateCreatorInteractionPower(address user) external view returns (uint256);
  function calculateMinterInteractionPower(address user) external view returns (uint256);
}
