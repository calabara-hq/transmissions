// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {InfiniteRound, ITiming} from "../../src/timing/InfiniteRound.sol";
import {Test, console} from "forge-std/Test.sol";

contract InfiniteTimingTest is Test {
    ITiming infiniteRoundImpl = new InfiniteRound();

    function test_InfiniteTimingConfig_fuzz(uint40 duration) public {
        bytes memory data = abi.encode(duration);
        address targetChannel = makeAddr("targetChannel");
        vm.startPrank(targetChannel);

        if (duration == 0) {
            vm.expectRevert();
            infiniteRoundImpl.setTimingConfig(data);
        } else {
            infiniteRoundImpl.setTimingConfig(data);
        }

        assertEq(infiniteRoundImpl.getChannelState(), 1);

        infiniteRoundImpl.setTokenSale(1);

        assertEq(infiniteRoundImpl.getTokenSaleState(1), duration == 0 ? 0 : 1);

        vm.stopPrank();
    }
}
