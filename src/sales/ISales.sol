// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ISales {
    struct FeePair {
        address addr;
        uint256 amount;
    }

    struct SaleConfig {
        uint256 saleStart;
        uint256 saleEnd;
        address creator;
        address createReferral;
    }

    function setChannelFeeAddress(address channelTreasury) external;
    function setCreateReferral(address _referral, uint256 tokenId) external;
    function setCreatorAddress(address _creator, uint256 tokenId) external;
    //function getFees(address _contract) external view returns (FeePair[] memory);
}
