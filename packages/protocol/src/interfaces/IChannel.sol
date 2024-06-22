// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ChannelStorage } from "../channel/ChannelStorage.sol";
import { DeferredTokenAuthorization } from "../utils/DeferredTokenAuthorization.sol";

interface IChannel {
  function contractURI() external view returns (string memory);
  function getToken(uint256 tokenId) external view returns (ChannelStorage.TokenConfig memory);

  function initialize(
    string memory uri,
    string memory name,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
  ) external;

  function setFees(address fees, bytes calldata data) external;
  function setLogic(address logic, bytes calldata creatorLogic, bytes calldata minterLogic) external;
  function updateChannelMetadata(string calldata name, string calldata uri) external;
  function updateChannelTokenUri(string calldata uri) external;
  function createToken(string calldata uri, uint256 maxSupply) external returns (uint256 tokenId);
  function sponsorWithERC20(
    DeferredTokenAuthorization.DeferredTokenPermission memory tokenPermission,
    address author,
    uint8 v,
    bytes32 r,
    bytes32 s,
    address to,
    uint256 amount,
    address mintReferral,
    bytes memory data
  ) external;
  function sponsorWithETH(
    DeferredTokenAuthorization.DeferredTokenPermission memory tokenPermission,
    address author,
    uint8 v,
    bytes32 r,
    bytes32 s,
    address to,
    uint256 amount,
    address mintReferral,
    bytes memory data
  ) external payable;
  function mint(address to, uint256 tokenId, uint256 amount, address mintReferral, bytes memory data) external payable;
  function mintWithERC20(address to, uint256 tokenId, uint256 amount, address mintReferral, bytes memory data) external;
  function mintBatchWithETH(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    address mintReferral,
    bytes memory data
  ) external payable;
  function mintBatchWithERC20(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    address mintReferral,
    bytes memory data
  ) external;
}
