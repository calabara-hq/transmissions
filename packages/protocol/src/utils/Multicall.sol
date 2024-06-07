// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/utils/Address.sol";

/// @title Multicall
/// @notice Contract for executing a batch of function calls on this contract
/// modified from Zora's PublicMulticall.sol
/// (https://github.com/ourzora/zora-protocol/blob/main/packages/1155-contracts/src/utils/PublicMulticall.sol)

abstract contract Multicall {
  /**
   * @notice Receives and executes a batch of function calls on this contract.
   */
  function multicall(bytes[] calldata data) public virtual returns (bytes[] memory results) {
    results = new bytes[](data.length);
    for (uint256 i = 0; i < data.length; i++) {
      results[i] = Address.functionDelegateCall(address(this), data[i]);
    }
  }
}
