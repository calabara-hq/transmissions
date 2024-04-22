// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IFees} from "../../src/fees/IFees.sol";
import {DynamicFees} from "../../src/fees/DynamicFees.sol";


contract FeesTest is Test {
    address nick = makeAddr("nick");
    address targetChannel = makeAddr("targetChannel");
    IFees dynamicFeesImpl = new DynamicFees();

    function test_dynamicFees() public {

        bytes memory feeArgs = abi.encode(
            address(0),
            11100000000000000,
            11100000000000000,
            33300000000000000,
            11100000000000000,
            11100000000000000
        );

        vm.startPrank(targetChannel);
        dynamicFeesImpl.setChannelFeeConfig(feeArgs);

        (uint256 uplinkFee, uint256 channelFee, uint256 creatorFee, uint256 mintReferralFee, uint256 firstMinterFee) = dynamicFeesImpl.getChannelFeeConfig();
        assertEq(uplinkFee, 11100000000000000);
        assertEq(channelFee, 11100000000000000);
        assertEq(creatorFee, 33300000000000000);
        assertEq(mintReferralFee, 11100000000000000);
        assertEq(firstMinterFee, 11100000000000000);

        assertEq(dynamicFeesImpl.getMintPrice(), 77700000000000000);
        vm.stopPrank();
        
    }
}