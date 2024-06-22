// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Rewards } from "../rewards/Rewards.sol";
import { IVersionedContract } from "./IVersionedContract.sol";

interface IFees is IVersionedContract {
  function setChannelFees(bytes calldata data) external;
  function getEthMintPrice() external view returns (uint256);
  function getErc20MintPrice() external view returns (uint256);
  function requestEthMint(
    address[] memory creators,
    address[] memory sponsors,
    uint256[] memory amounts,
    address mintReferral
  ) external view returns (Rewards.Split memory);
  function requestErc20Mint(
    address[] memory creators,
    address[] memory sponsors,
    uint256[] memory amounts,
    address mintReferral
  ) external view returns (Rewards.Split memory);
}
