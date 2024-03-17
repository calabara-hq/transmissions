// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {IChannelTypesV1} from "./IChannelTypesV1.sol";

/// @notice Channel
/// @author @nickddsn

interface IChannel {
    // function createToken(string calldata uri, uint256 maxSupply) external returns (uint256);

    // function mint(address account, uint256 tokenId, uint256 amount, bytes memory data) external;

    // function getTokens(
    //     uint256 tokenId
    // ) external view returns (TokenConfig memory);

    function initialize(string calldata uri, bytes[] calldata setupActions) external;
}
