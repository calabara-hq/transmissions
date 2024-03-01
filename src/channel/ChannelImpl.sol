// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {IChannel} from "../interfaces/IChannel.sol";
import {IChannelTypesV1} from "../interfaces/IChannelTypesV1.sol";
import {ChannelStorageV1} from "../storage/ChannelStorageV1.sol";
import {ChannelFeeStorageV1} from "../storage/ChannelFeeStorageV1.sol";

contract Channel is ERC1155, IChannel, IChannelTypesV1, ChannelStorageV1, ChannelFeeStorageV1 {
    constructor(string memory uri, FeePair[] calldata feePairs) ERC1155(uri) {
        treasury = _treasury;
    }


    function createToken(
        string calldata uri,
        uint256 maxSupply,
        address _referral
    ) public returns (uint256) {
        address referral = treasury;
        
        if (_referral != address(0)) {
            referral = _referral;
        }

        uint256 tokenId = 0;
        TokenConfig memory tokenConfig = TokenConfig({
            uri: uri,
            maxSupply: maxSupply,
            totalMinted: 0
        });

        tokens[tokenId] = tokenConfig;
        createReferral[tokenId] = referral;
        return tokenId;
    }

    function mint(
        address minter,
        uint256 tokenId,
        uint256 amount,
        address mintReferral
    ) external payable {
        // todo: this is wrong
        require(
            tokens[tokenId].totalMinted + amount <= tokens[tokenId].maxSupply,
            "Token: amount exceeds available supply"
        );

        // deposit eth for create referral
        // deposit eth for creator
        // deposit eth for mint referral
        // deposit eth for uplink
        // deposit eth for first minter



        tokens[tokenId].totalMinted += amount;
        _mint(minter, tokenId, amount, data);
    }

    function getTokens(
        uint256 tokenId
    ) public view returns (TokenConfig memory) {
        return tokens[tokenId];
    }

    function getTreasury() public view returns (address) {
        return treasury;
    }
}
