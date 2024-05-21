// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";
import { IChannel } from "../../src/interfaces/IChannel.sol";

// implement the abstracted functions from Channel.sol to be used in testing

contract ChannelHarness is Channel {
    constructor(address _upgradePath, address _weth) Channel(_upgradePath, _weth) { }

    function setTiming(bytes calldata data) public virtual override { }

    function _processNewToken(uint256 tokenId) internal override { }

    function _processMint(uint256 tokenId) internal view override { }
}
