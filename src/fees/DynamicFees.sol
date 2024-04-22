// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IFees} from "./IFees.sol";

contract DynamicFees is IFees {

    struct FeeConfig {
        address channelTreasury;
        uint256 uplinkFee;
        uint256 channelFee;
        uint256 creatorFee;
        uint256 mintReferralFee;
        uint256 firstMinterFee;
    }

    mapping(address => FeeConfig) public customFees;
   // mapping(address => FeeCommands[]) public constantFeeCommands; // idea is to "cache" the contract wide fee commands to reduce gas on mint

    function setChannelFeeConfig(
        bytes calldata data
    ) external {
        (
            address channelTreasury,
            uint256 uplinkFee,
            uint256 channelFee,
            uint256 creatorFee,
            uint256 mintReferralFee,
            uint256 firstMinterFee
        ) = abi.decode(
                data,
                (address, uint256, uint256, uint256, uint256, uint256)
            );

        customFees[msg.sender] = FeeConfig(
            channelTreasury,
            uplinkFee,
            channelFee,
            creatorFee,
            mintReferralFee,
            firstMinterFee
        );
    }

    function getMintPrice() external view returns (uint256) {
        FeeConfig memory feeConfig = customFees[msg.sender];
        return 
            feeConfig.uplinkFee + 
            feeConfig.channelFee + 
            feeConfig.creatorFee + 
            feeConfig.mintReferralFee + 
            feeConfig.firstMinterFee;
    }

    function getChannelFeeConfig() external view returns (uint256, uint256, uint256, uint256, uint256) {
        FeeConfig memory feeConfig = customFees[msg.sender];

        return (
            feeConfig.uplinkFee,
            feeConfig.channelFee,
            feeConfig.creatorFee,
            feeConfig.mintReferralFee,
            feeConfig.firstMinterFee
        );
    }

    function generateFeeCommands(address creator, address referral, address firstMinter) external view returns (FeeCommands[] memory) {

        if(creator == address(0)) revert("Invalid creator address");
        if(firstMinter == address(0)) revert("Invalid first minter address");

        
        FeeConfig memory feeConfig = customFees[msg.sender];

        FeeCommands memory uplinkFeeCommand;
        FeeCommands memory channelFeeCommand;
        FeeCommands memory creatorFeeCommand;
        FeeCommands memory mintReferralFeeCommand;
        FeeCommands memory firstMinterFeeCommand;

        uint8 commandLength = 0;

        /// mint referral fees
        /// if referral is address 0, route the mint referral to the channel treasury
        if(feeConfig.mintReferralFee > 0) {
            if(referral == address(0)){
                feeConfig.channelFee += feeConfig.mintReferralFee;
            } else {
                mintReferralFeeCommand = constructSingleFeeCommand(FeeActions.SEND_ETH, referral, feeConfig.mintReferralFee);
                commandLength++;
            }
        }

        /// first minter fees
        if(feeConfig.firstMinterFee > 0) {
            firstMinterFeeCommand = constructSingleFeeCommand(FeeActions.SEND_ETH, firstMinter, feeConfig.firstMinterFee);
            commandLength++;
        }

        /// uplink fee
        if(feeConfig.uplinkFee > 0) {
            uplinkFeeCommand = constructSingleFeeCommand(FeeActions.SEND_ETH, /* todo uplink address */ address(0), feeConfig.uplinkFee);
            commandLength++;
        }

        /// channel fees 
        /// if channel treasury is address 0, route the treasury rewards to the creator
        /// otherwise set the channel fee command
        if(feeConfig.channelFee > 0) {
            if(feeConfig.channelTreasury == address(0)){
                feeConfig.creatorFee += feeConfig.channelFee;
            }
            else {
                channelFeeCommand = constructSingleFeeCommand(FeeActions.SEND_ETH, feeConfig.channelTreasury, feeConfig.channelFee);
                commandLength++;
            }
        }

        /// creator fees
        if(feeConfig.creatorFee > 0) {
            creatorFeeCommand = constructSingleFeeCommand(FeeActions.SEND_ETH, creator, feeConfig.creatorFee);
            commandLength++;
        }

        // add all populated commands to the transfer commands array

        FeeCommands[] memory transferCommands = new FeeCommands[](commandLength);

        if(uplinkFeeCommand.amount > 0) transferCommands[0] = uplinkFeeCommand;
        if(channelFeeCommand.amount > 0) transferCommands[1] = channelFeeCommand;
        if(creatorFeeCommand.amount > 0) transferCommands[2] = creatorFeeCommand;
        if(mintReferralFeeCommand.amount > 0) transferCommands[3] = mintReferralFeeCommand;
        if(firstMinterFeeCommand.amount > 0) transferCommands[4] = firstMinterFeeCommand;

        return transferCommands;

        // return transfer commands to the caller
    }

    function constructSingleFeeCommand(FeeActions feeAction, address recipient, uint256 amount) internal pure returns (FeeCommands memory) {
        return FeeCommands({
            method: feeAction,
            recipient: recipient,
            amount: amount
        });
    }
}
