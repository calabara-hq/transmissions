// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {Rewards, IRewards} from "../../src/rewards/Rewards.sol";

contract FeesTest is Test {
    address nick = makeAddr("nick");
    IRewards rewardsImpl = new Rewards();

    function test_rewards() public {
        address[] memory recipients = new address[](2);
        uint256[] memory allocations = new uint256[](2);
        uint256 totalAllocation = 0;

        recipients[0] = makeAddr("recipient1");
        allocations[0] = 100;
        totalAllocation += 100;
        recipients[1] = makeAddr("recipient2");
        allocations[1] = 200;
        totalAllocation += 200;

        IRewards.Split memory split = IRewards.Split({
            recipients: recipients,
            allocations: allocations,
            totalAllocation: totalAllocation,
            token: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
        });

        vm.deal(nick, totalAllocation);
        vm.startPrank(nick);

        bytes32 splitHash = rewardsImpl.deposit{value: totalAllocation}(split);
        console.logBytes32(splitHash);

        console.log(
            "balance", Rewards(address(rewardsImpl)).getBalance(nick, 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE)
        );

        rewardsImpl.distribute(splitHash);

        assertEq(recipients[0].balance, 100);
        assertEq(recipients[1].balance, 200);
        assertEq(Rewards(address(rewardsImpl)).getBalance(nick, 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE), 0);

        vm.stopPrank();
    }
}
