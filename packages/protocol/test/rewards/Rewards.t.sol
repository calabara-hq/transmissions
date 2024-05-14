// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IRewards, Rewards } from "../../src/rewards/Rewards.sol";

import { MockERC20 } from "../TokenHelpers.sol";

import { WETH } from "./WETH.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Test, console } from "forge-std/Test.sol";

contract RewardsParent is Rewards {
  constructor(address weth) Rewards(weth) {}

  function distribute(IRewards.Split memory split) external payable {
    _distributeIncomingSplit(split);
  }
}

contract RewardsTest is Test {
  address nick = makeAddr("nick");
  address weth = address(new WETH());
  RewardsParent rewardsImpl = new RewardsParent(weth);
  MockERC20 erc20Token = new MockERC20("testERC20", "TEST1");

  function test_rewards_distributeETH() public {
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

    rewardsImpl.distribute{ value: totalAllocation }(split);

    assertEq(recipients[0].balance, 100);
    assertEq(recipients[1].balance, 200);
    assertEq(nick.balance, 0);

    vm.stopPrank();
  }

  function test_rewards_distributeERC20() public {
    address[] memory recipients = new address[](2);
    uint256[] memory allocations = new uint256[](2);
    uint256 totalAllocation = 0;

    recipients[0] = makeAddr("recipient1");
    allocations[0] = 100_000;
    totalAllocation += 100_000;
    recipients[1] = makeAddr("recipient2");
    allocations[1] = 200_000;
    totalAllocation += 200_000;

    IRewards.Split memory split = IRewards.Split({
      recipients: recipients,
      allocations: allocations,
      totalAllocation: totalAllocation,
      token: address(erc20Token)
    });

    erc20Token.mint(nick, 1_000_000);
    vm.startPrank(nick);
    erc20Token.approve(address(rewardsImpl), 1_000_000);

    rewardsImpl.distribute(split);

    assertEq(erc20Token.balanceOf(recipients[0]), 100_000);
    assertEq(erc20Token.balanceOf(recipients[1]), 200_000);

    vm.stopPrank();
  }

  function test_rewards_forceWETHFallback() public {
    address[] memory recipients = new address[](2);
    uint256[] memory allocations = new uint256[](2);
    uint256 totalAllocation = 0;

    recipients[0] = address(this);
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

    rewardsImpl.distribute{ value: 300 }(split);

    // tx1 should fail the ether transfer because recipient one is a contract that does not have
    // a fallback or receive function. As such, the eth should be wrapped first and sent.
    // tx2 should successfully send the ether to recipient two
    assertEq(IERC20(weth).balanceOf(address(this)), 100);
    assertEq(recipients[1].balance, 200);
    assertEq(nick.balance, 0);

    vm.stopPrank();
  }
}
