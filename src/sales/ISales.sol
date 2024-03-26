// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ISales {
    struct FeePair {
        address addr;
        uint256 amount;
    }

    struct FeeConfig {
        address channelTreasury;
        uint256 uplinkFee;
        uint256 channelFee;
        uint256 creatorFee;
        uint256 mintReferralFee;
        uint256 firstMinterFee;
    }

    struct SaleConfig {
        uint256 saleStart;
        uint256 saleEnd;
        address creator;
        address createReferral;
    }

    //function setCreateReferral(address _referral, uint256 tokenId) external;
    function initializeSaleStrategy(
        address channelTreasury,
        uint256 uplinkFee,
        uint256 channelFee,
        uint256 creatorFee,
        uint256 mintReferralFee,
        uint256 firstMinterFee
    ) external;

    function handleCreateSale(uint256 tokenId, bytes calldata saleArgs) external;
    //function getFees(address _contract) external view returns (FeePair[] memory);
}
