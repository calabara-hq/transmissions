// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @notice Channel
/// @author @nickddsn

interface IChannelTypesV1 {
    struct TokenConfig {
        string uri;
        uint256 maxSupply;
        uint256 totalMinted;
    }

    struct ChannelConfig {
        address owner;
    }
}
