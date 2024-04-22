// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ChannelEvents {}

interface IMinter {
    struct FeeConfig {
        address channelTreasury;
        uint256 uplinkFee;
        uint256 channelFee;
        uint256 creatorFee;
        uint256 mintReferralFee;
        uint256 firstMinterFee;
    }

    function setChannelFeeConfig(address channel, bytes calldata data) external;

    function getChannelFeeConfig(
        address channel
    ) external view returns (FeeConfig memory);
}

interface IChannel {
    function initialize(
        string calldata uri,
        address defaultAdmin,
        address[] calldata admins,
        bytes[] calldata setupActions
    ) external;
}

contract ChannelStorageV1 {
    StorageV1 cs;

    struct StorageV1 {
        //address owner;
        IMinter minterFeeContract;
        mapping(uint256 => TokenConfig) tokens;
        uint256 nextTokenId;
        //address uplinkFeeAddress;
    }

    struct TokenConfig {
        string uri;
        uint256 maxSupply;
        uint256 totalMinted;
    }
}
