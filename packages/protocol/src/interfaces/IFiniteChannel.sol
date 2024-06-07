// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IFiniteChannel {
  function settle() external;
  function withdrawRewards(address token, address to, uint256 amount) external;
}
