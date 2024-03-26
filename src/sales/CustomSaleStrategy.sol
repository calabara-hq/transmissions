// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ISales} from "./ISales.sol";

contract CustomSaleStrategy is ISales {
    //mapping(address => mapping(uint256 => SaleConfig)) internal salesConfigs;
    mapping(address => FeeConfig) internal feeConfigs;
    mapping(address => mapping(uint256 => SaleConfig)) internal salesConfigs;

    // uint256 internal constant UPLINK_FEE = 0.000111 ether;
    // uint256 internal constant CHANNEL_FEE = 0.000111 ether;

    // uint256 internal constant CREATOR_FEE = 0.000333 ether;
    // uint256 internal constant MINT_REFERRAL_FEE = 0.000111 ether;
    // uint256 internal constant FIRST_MINTER_FEE = 0.000111 ether;
    // address internal uplinkFeeAddress;

    // static fees and dynamic fee pricing are set at the contract level
    // saleConfigs are set at the token level

    function initializeSaleStrategy(
        address channelTreasury,
        uint256 uplinkFee,
        uint256 channelFee,
        uint256 creatorFee,
        uint256 mintReferralFee,
        uint256 firstMinterFee
    ) external {
        FeeConfig memory config;
        config.channelTreasury = channelTreasury;
        config.uplinkFee = uplinkFee;
        config.channelFee = channelFee;
        config.creatorFee = creatorFee;
        config.mintReferralFee = mintReferralFee;
        config.firstMinterFee = firstMinterFee;

        feeConfigs[msg.sender] = config;
    }

    // set the timing and creator of the sale

    function handleCreateSale(
        uint256 tokenId,
        bytes calldata saleArgs
    ) external {
        (
            address creator,
            address createReferral,
            uint256 saleStart,
            uint256 saleEnd
        ) = abi.decode(saleArgs, (address, address, uint256, uint256));

        salesConfigs[msg.sender][tokenId] = SaleConfig({
            creator: creator,
            createReferral: createReferral,
            saleStart: saleStart,
            saleEnd: saleEnd
        });

        //saleConfigs
        // revert if channelFeeRecipients not set
        // set the saleConfig for the token
        // salesConfigs[msg.sender][tokenId] = SaleConfig({
        //     creator: msg.sender,
        //     salesBit: 0,
        //     salesFee: 0,
    }

    // function handleMint() external {

    // }
    // function setCreatorAddress(address _creator, uint256 tokenId) external {
    //     salesConfigs[msg.sender][tokenId].creator = _creator;
    // }

    // function getFees(address _contract) external view returns (FeePair[] memory) {
    //     return contractFees[_contract];
    // }
}
