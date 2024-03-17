// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ISales} from "./ISales.sol";

contract PaidSaleStrategy is ISales {
    //mapping(address => mapping(uint256 => SaleConfig)) internal salesConfigs;
    mapping(address => address) internal channelFeeRecipients;
    mapping(address => mapping(uint256 => SaleConfig)) internal salesConfigs;

    uint256 internal constant UPLINK_FEE = 0.000111 ether;
    uint256 internal constant CHANNEL_FEE = 0.000111 ether;
    uint256 internal constant CREATOR_FEE = 0.000333 ether;
    uint256 internal constant CREATE_REFERRAL_FEE = 0.000111 ether;
    uint256 internal constant MINT_REFERRAL_FEE = 0.000111 ether;
    address internal immutable uplinkFeeAddress;

    // static fees and dynamic fee pricing are set at the contract level
    // saleConfigs are set at the token level

    function setChannelFeeAddress(address channelTreasury) external {
        channelFeeRecipients[msg.sender] = channelTreasury;
    }

    function setCreateReferral(address _referral, uint256 tokenId) external {
        salesConfigs[msg.sender][tokenId].createReferral = _referral;
    }

    function setCreatorAddress(address _creator, uint256 tokenId) external {
        salesConfigs[msg.sender][tokenId].creator = _creator;
    }

    // function getFees(address _contract) external view returns (FeePair[] memory) {
    //     return contractFees[_contract];
    // }
}
