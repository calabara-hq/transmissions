// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";

// implement the abstracted functions from Channel.sol to be used in testing

contract ChannelHarness is Channel {
  constructor(address _upgradePath, address _weth) Channel(_upgradePath, _weth) {}

  function setTransportConfig(bytes calldata data) public payable virtual override {}

  function _transportProcessNewToken(uint256 tokenId) internal virtual override {}

  function _transportProcessMint(uint256 tokenId) internal virtual override {}
}
