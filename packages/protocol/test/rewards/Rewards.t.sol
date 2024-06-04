// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Rewards } from "../../src/rewards/Rewards.sol";
import { MockERC20 } from "../utils/TokenHelpers.t.sol";

import { NativeTokenLib } from "../../src/libraries/NativeTokenLib.sol";
import { WETH } from "../utils/WETH.t.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Test, console } from "forge-std/Test.sol";

contract RewardsHarness is Rewards {
    constructor(address weth) Rewards(weth) { }

    using NativeTokenLib for address;

    function distributePassThroughSplit(Rewards.Split memory split) external payable {
        _distributePassThroughSplit(split);
    }

    function depositToEscrow(address token, uint256 amount) external payable {
        _depositToEscrow(token, amount);
    }

    function distributeEscrowSplit(Rewards.Split memory split) external {
        _distributeEscrowSplit(split);
    }

    function withdrawFromEscrow(address token, address to, uint256 amount) external {
        _withdrawFromEscrow(token, to, amount);
    }

    function validateIncomingAllocations(
        address[] memory recipients,
        uint256[] memory allocations,
        uint256 totalAllocation
    )
        external
    {
        _validateIncomingAllocations(recipients, allocations, totalAllocation);
    }

    function validateIncomingValue(address token, uint256 amount) external payable {
        _validateIncomingValue(token, amount);
    }
}

contract RewardsTest is Test {
    address nick = makeAddr("nick");
    address weth = address(new WETH());
    RewardsHarness rewardsImpl = new RewardsHarness(weth);
    MockERC20 erc20Token = new MockERC20("testERC20", "TEST1");

    function test_rewards_distributePassThroughETH() public {
        address[] memory recipients = new address[](2);
        uint256[] memory allocations = new uint256[](2);
        uint256 totalAllocation = 0;

        recipients[0] = makeAddr("recipient1");
        allocations[0] = 100;
        totalAllocation += 100;
        recipients[1] = makeAddr("recipient2");
        allocations[1] = 200;
        totalAllocation += 200;

        Rewards.Split memory split = Rewards.Split({
            recipients: recipients,
            allocations: allocations,
            totalAllocation: totalAllocation,
            token: NativeTokenLib.NATIVE_TOKEN
        });

        vm.deal(nick, totalAllocation);
        vm.startPrank(nick);

        rewardsImpl.distributePassThroughSplit{ value: totalAllocation }(split);

        assertEq(recipients[0].balance, 100);
        assertEq(recipients[1].balance, 200);
        assertEq(nick.balance, 0);

        vm.stopPrank();
    }

    function test_rewards_distributePassThroughERC20() public {
        address[] memory recipients = new address[](2);
        uint256[] memory allocations = new uint256[](2);
        uint256 totalAllocation = 0;

        recipients[0] = makeAddr("recipient1");
        allocations[0] = 100_000;
        totalAllocation += 100_000;
        recipients[1] = makeAddr("recipient2");
        allocations[1] = 200_000;
        totalAllocation += 200_000;

        Rewards.Split memory split = Rewards.Split({
            recipients: recipients,
            allocations: allocations,
            totalAllocation: totalAllocation,
            token: address(erc20Token)
        });

        erc20Token.mint(nick, 1_000_000);
        vm.startPrank(nick);
        erc20Token.approve(address(rewardsImpl), 1_000_000);

        rewardsImpl.distributePassThroughSplit(split);

        assertEq(erc20Token.balanceOf(recipients[0]), 100_000);
        assertEq(erc20Token.balanceOf(recipients[1]), 200_000);

        vm.stopPrank();
    }

    function test_rewards_distributePassThroughForceWETHFallback() public {
        address[] memory recipients = new address[](2);
        uint256[] memory allocations = new uint256[](2);
        uint256 totalAllocation = 0;

        recipients[0] = address(this);
        allocations[0] = 100;
        totalAllocation += 100;
        recipients[1] = makeAddr("recipient2");
        allocations[1] = 200;
        totalAllocation += 200;

        Rewards.Split memory split = Rewards.Split({
            recipients: recipients,
            allocations: allocations,
            totalAllocation: totalAllocation,
            token: NativeTokenLib.NATIVE_TOKEN
        });

        vm.deal(nick, totalAllocation);
        vm.startPrank(nick);

        rewardsImpl.distributePassThroughSplit{ value: 300 }(split);

        // tx1 should fail the ether transfer because recipient one is a contract that does not have
        // a fallback or receive function. As such, the eth should be wrapped first and sent.
        // tx2 should successfully send the ether to recipient two
        assertEq(IERC20(weth).balanceOf(address(this)), 100);
        assertEq(recipients[1].balance, 200);
        assertEq(nick.balance, 0);

        vm.stopPrank();
    }

    function test_rewards_distributeEscrowForceWETHFallback() public {
        address[] memory recipients = new address[](2);
        uint256[] memory allocations = new uint256[](2);
        uint256 totalAllocation = 0;

        recipients[0] = address(this);
        allocations[0] = 100;
        totalAllocation += 100;
        recipients[1] = makeAddr("recipient2");
        allocations[1] = 200;
        totalAllocation += 200;

        Rewards.Split memory split = Rewards.Split({
            recipients: recipients,
            allocations: allocations,
            totalAllocation: totalAllocation,
            token: NativeTokenLib.NATIVE_TOKEN
        });

        vm.deal(nick, totalAllocation);
        vm.startPrank(nick);

        rewardsImpl.depositToEscrow{ value: totalAllocation }(NativeTokenLib.NATIVE_TOKEN, totalAllocation);

        rewardsImpl.distributeEscrowSplit(split);

        // tx1 should fail the ether transfer because recipient one is a contract that does not have
        // a fallback or receive function. As such, the eth should be wrapped first and sent.
        // tx2 should successfully send the ether to recipient two
        assertEq(IERC20(weth).balanceOf(address(this)), 100);
        assertEq(recipients[1].balance, 200);
        assertEq(nick.balance, 0);

        vm.stopPrank();
    }

    function test_rewards_depositEscrowETH(uint256 amount) public {
        vm.deal(nick, amount);
        vm.startPrank(nick);
        rewardsImpl.depositToEscrow{ value: amount }(NativeTokenLib.NATIVE_TOKEN, amount);
        assertEq(address(rewardsImpl).balance, amount);
        vm.stopPrank();
    }

    function test_rewards_depositEscrowERC20(uint256 amount) public {
        erc20Token.mint(nick, amount);
        vm.startPrank(nick);
        erc20Token.approve(address(rewardsImpl), amount);
        rewardsImpl.depositToEscrow(address(erc20Token), amount);
        assertEq(erc20Token.balanceOf(address(rewardsImpl)), amount);
        vm.stopPrank();
    }

    function test_rewards_withdrawETHFromEscrow(uint256 amount) public {
        vm.deal(nick, amount);
        vm.startPrank(nick);
        rewardsImpl.depositToEscrow{ value: amount }(NativeTokenLib.NATIVE_TOKEN, amount);
        rewardsImpl.withdrawFromEscrow(NativeTokenLib.NATIVE_TOKEN, nick, amount);
        assertEq(address(rewardsImpl).balance, 0);
        assertEq(nick.balance, amount);
        vm.stopPrank();
    }

    function test_rewards_withdrawERC20FromEscrow(uint256 amount) public {
        erc20Token.mint(nick, amount);
        vm.startPrank(nick);
        erc20Token.approve(address(rewardsImpl), amount);
        rewardsImpl.depositToEscrow(address(erc20Token), amount);
        rewardsImpl.withdrawFromEscrow(address(erc20Token), nick, amount);
        assertEq(erc20Token.balanceOf(address(rewardsImpl)), 0);
        assertEq(erc20Token.balanceOf(nick), amount);
        vm.stopPrank();
    }

    function test_rewards_distributeEscrowETH(uint32[] memory _allocations) public {
        vm.assume(_allocations.length < 100);

        uint256 totalAllocation = 0;

        uint256[] memory allocations = new uint256[](_allocations.length);
        address[] memory recipients = new address[](_allocations.length);

        for (uint256 i = 0; i < allocations.length; i++) {
            totalAllocation += uint256(_allocations[i]);
            allocations[i] = uint256(_allocations[i]);
            recipients[i] = vm.addr(i + 1);
        }

        Rewards.Split memory split = Rewards.Split({
            recipients: recipients,
            allocations: allocations,
            totalAllocation: totalAllocation,
            token: NativeTokenLib.NATIVE_TOKEN
        });

        vm.deal(nick, totalAllocation);
        vm.startPrank(nick);

        rewardsImpl.depositToEscrow{ value: totalAllocation }(NativeTokenLib.NATIVE_TOKEN, totalAllocation);
        vm.stopPrank();

        vm.assume(totalAllocation > 0);

        rewardsImpl.distributeEscrowSplit(split);

        assertEq(address(rewardsImpl).balance, 0);

        for (uint256 i = 0; i < recipients.length; i++) {
            assertEq(recipients[i].balance, allocations[i]);
        }
    }

    function test_rewards_distributeEscrowERC20(uint32[] memory _allocations) public {
        vm.assume(_allocations.length < 100);

        uint256 totalAllocation = 0;

        uint256[] memory allocations = new uint256[](_allocations.length);
        address[] memory recipients = new address[](_allocations.length);

        for (uint256 i = 0; i < allocations.length; i++) {
            totalAllocation += uint256(_allocations[i]);
            allocations[i] = uint256(_allocations[i]);
            recipients[i] = vm.addr(i + 1);
        }

        Rewards.Split memory split = Rewards.Split({
            recipients: recipients,
            allocations: allocations,
            totalAllocation: totalAllocation,
            token: address(erc20Token)
        });

        erc20Token.mint(nick, totalAllocation);
        vm.startPrank(nick);
        erc20Token.approve(address(rewardsImpl), totalAllocation);
        rewardsImpl.depositToEscrow(address(erc20Token), totalAllocation);
        vm.stopPrank();

        vm.assume(totalAllocation > 0);

        rewardsImpl.distributeEscrowSplit(split);

        assertEq(erc20Token.balanceOf(address(rewardsImpl)), 0);

        for (uint256 i = 0; i < recipients.length; i++) {
            assertEq(erc20Token.balanceOf(recipients[i]), allocations[i]);
        }
    }

    function test_rewards_validateIncomingAllocations(
        address[] memory recipients,
        uint32[] memory _allocations,
        uint256 _totalAllocation
    )
        public
    {
        vm.assume(_allocations.length < 100);

        uint256 totalAllocation = 0;

        uint256[] memory allocations = new uint256[](_allocations.length);

        for (uint256 i = 0; i < allocations.length; i++) {
            totalAllocation += uint256(_allocations[i]);
            allocations[i] = uint256(_allocations[i]);
        }

        if (recipients.length != allocations.length) {
            vm.expectRevert(Rewards.SplitLengthMismatch.selector);
            rewardsImpl.validateIncomingAllocations(recipients, allocations, _totalAllocation);
            return;
        }

        if (_totalAllocation == 0) {
            vm.expectRevert(Rewards.InvalidTotalAllocation.selector);
            rewardsImpl.validateIncomingAllocations(recipients, allocations, _totalAllocation);
            return;
        }

        if (totalAllocation != _totalAllocation) {
            vm.expectRevert(Rewards.InvalidTotalAllocation.selector);
            rewardsImpl.validateIncomingAllocations(recipients, allocations, _totalAllocation);
            return;
        }

        rewardsImpl.validateIncomingAllocations(recipients, allocations, _totalAllocation);
    }

    function test_rewards_validateIncomingValue(uint256 amount, uint256 value) public {
        vm.startPrank(nick);
        vm.deal(nick, UINT256_MAX);
        erc20Token.approve(address(rewardsImpl), UINT256_MAX);

        if (amount != value) {
            /// fn should revert with any amount / value mismatch
            vm.expectRevert(Rewards.InvalidAmountSent.selector);
            rewardsImpl.validateIncomingValue{ value: value }(NativeTokenLib.NATIVE_TOKEN, amount);
            return;
        }

        if (value != 0) {
            /// fn should revert with any value sent alongside an erc20 deposit
            vm.expectRevert(Rewards.InvalidAmountSent.selector);
            rewardsImpl.validateIncomingValue{ value: value }(address(erc20Token), amount);
            return;
        }

        /// fn should not revert with a matching amount / value pair

        rewardsImpl.validateIncomingValue(address(erc20Token), amount);
        rewardsImpl.validateIncomingValue{ value: value }(NativeTokenLib.NATIVE_TOKEN, amount);
        vm.stopPrank();
    }
}
