// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { CustomFees } from "../../src/fees/CustomFees.sol";
import { IFees } from "../../src/interfaces/IFees.sol";

import { IRewards } from "../../src/interfaces/IRewards.sol";
import { Rewards } from "../../src/rewards/Rewards.sol";
import { MockERC20 } from "../utils/TokenHelpers.t.sol";
import { Test, console } from "forge-std/Test.sol";

contract FeesTest is Test {
    address nick = makeAddr("nick");
    address uplinkRewardsAddr = makeAddr("uplink");
    address targetChannel = makeAddr("targetChannel");
    address channelTreasury = makeAddr("channelTreasury");

    IFees customFeesImpl = new CustomFees(uplinkRewardsAddr);

    MockERC20 erc20Token = new MockERC20("testERC20", "TEST1");

    function test_customFees_bps() public {
        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            777_000_000_000_000,
            100_000_000,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFees(feeArgs);

        assertEq(customFeesImpl.getEthMintPrice(), 777_000_000_000_000);

        address creator = makeAddr("creator");
        address referral = makeAddr("referral");
        address sponsor = makeAddr("sponsor");

        IRewards.Split memory ethSplit = customFeesImpl.requestEthMint(creator, referral, sponsor, 1);

        IRewards.Split memory erc20Split = customFeesImpl.requestErc20Mint(creator, referral, sponsor, 1);

        // eth validation
        assertEq(ethSplit.recipients.length, 5);
        assertEq(ethSplit.allocations.length, 5);
        assertEq(ethSplit.totalAllocation, 777_000_000_000_000);
        assertEq(ethSplit.token, 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

        assertEq(ethSplit.recipients[0], referral);
        assertEq(ethSplit.recipients[1], sponsor);
        assertEq(ethSplit.recipients[2], uplinkRewardsAddr);
        assertEq(ethSplit.recipients[3], channelTreasury);
        assertEq(ethSplit.recipients[4], creator);

        assertEq(ethSplit.allocations[0], 77_700_000_000_000); // 10%
        assertEq(ethSplit.allocations[1], 77_700_000_000_000); // 10%
        assertEq(ethSplit.allocations[2], 77_700_000_000_000); // 10%
        assertEq(ethSplit.allocations[3], 77_700_000_000_000); // 10%
        assertEq(ethSplit.allocations[4], 466_200_000_000_000); // 60%

        // erc20 validation

        assertEq(erc20Split.recipients.length, 5);
        assertEq(erc20Split.allocations.length, 5);
        assertEq(erc20Split.totalAllocation, 100_000_000);
        assertEq(erc20Split.token, address(erc20Token));

        assertEq(erc20Split.recipients[0], referral);
        assertEq(erc20Split.recipients[1], sponsor);
        assertEq(erc20Split.recipients[2], uplinkRewardsAddr);
        assertEq(erc20Split.recipients[3], channelTreasury);
        assertEq(erc20Split.recipients[4], creator);

        assertEq(erc20Split.allocations[0], 10_000_000); // 10%
        assertEq(erc20Split.allocations[1], 10_000_000); // 10%
        assertEq(erc20Split.allocations[2], 10_000_000); // 10%
        assertEq(erc20Split.allocations[3], 10_000_000); // 10%
        assertEq(erc20Split.allocations[4], 60_000_000); // 60%

        vm.stopPrank();
    }

    /*     function test_customFees_freeEthMint() public {
        bytes memory feeArgs = abi.encode(
    channelTreasury, uint16(0), uint16(0), uint16(0), uint16(0), uint16(0), 0, 10 * 10e6, address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFees(feeArgs);

        assertEq(customFeesImpl.getEthMintPrice(), 0);

        IRewards.Split memory ethSplit = customFeesImpl.requestEthMint(nick, nick, nick, 1);

        assertEq(ethSplit.recipients.length, 0);
        assertEq(ethSplit.allocations.length, 0);
        assertEq(ethSplit.totalAllocation, 0);

        vm.stopPrank();
    } */

    function test_customFees_nullChannelTreasury() public {
        bytes memory feeArgs = abi.encode(
            address(0),
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            777_000_000_000_000,
            100_000_000,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFees(feeArgs);

        IRewards.Split memory ethSplit = customFeesImpl.requestEthMint(nick, nick, nick, 1);
        IRewards.Split memory erc20Split = customFeesImpl.requestErc20Mint(nick, nick, nick, 1);

        assertEq(ethSplit.recipients.length, 4);
        assertEq(ethSplit.allocations.length, 4);

        assertEq(erc20Split.recipients.length, 4);
        assertEq(erc20Split.allocations.length, 4);
        vm.stopPrank();
    }

    function test_customFees_nullReferral() public {
        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            777_000_000_000_000,
            100_000_000,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFees(feeArgs);

        IRewards.Split memory ethSplit = customFeesImpl.requestEthMint(nick, address(0), nick, 1);
        IRewards.Split memory erc20Split = customFeesImpl.requestErc20Mint(nick, address(0), nick, 1);

        assertEq(ethSplit.recipients.length, 4);
        assertEq(ethSplit.allocations.length, 4);

        assertEq(erc20Split.recipients.length, 4);
        assertEq(erc20Split.allocations.length, 4);

        vm.stopPrank();
    }

    function test_customFees_revertOnNullCreator() public {
        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            777_000_000_000_000,
            100_000_000,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFees(feeArgs);

        vm.expectRevert();
        customFeesImpl.requestEthMint(address(0), nick, nick, 1);
        vm.expectRevert();
        customFeesImpl.requestErc20Mint(address(0), nick, nick, 1);

        vm.stopPrank();
    }

    function test_customFees_revertOnNullSponsor() public {
        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            777_000_000_000_000,
            100_000_000,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFees(feeArgs);
        vm.expectRevert();
        customFeesImpl.requestEthMint(nick, nick, address(0), 1);
        vm.expectRevert();
        customFeesImpl.requestErc20Mint(nick, nick, address(0), 1);
        vm.stopPrank();
    }

    function test_feeVerification(
        uint16 uplinkBps,
        uint16 channelBps,
        uint16 creatorBps,
        uint16 mintReferralBps,
        uint16 sponsorBps,
        uint256 ethMintPrice,
        uint256 erc20MintPrice,
        address erc20Address
    )
        public
    {
        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uplinkBps,
            channelBps,
            creatorBps,
            mintReferralBps,
            sponsorBps,
            ethMintPrice,
            erc20MintPrice,
            erc20Address
        );
        // customFeesImpl._verifyTotalBps(uplinkBps, channelBps, creatorBps, mintReferralBps, sponsorBps);
        uint256 totalBps =
            uint80(uplinkBps) + uint80(channelBps) + uint80(creatorBps) + uint80(mintReferralBps) + uint80(sponsorBps);

        if (totalBps != 1e4 || ethMintPrice == 0) {
            vm.expectRevert();
            customFeesImpl.setChannelFees(feeArgs);
        } else {
            customFeesImpl.setChannelFees(feeArgs);
        }
    }

    function test_revertOnInvalidSplits() public {
        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uint16(1234),
            uint16(766),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            777_000_000_000_000,
            100_000_000,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        // vm.expectRevert();
        customFeesImpl.setChannelFees(feeArgs);
        vm.stopPrank();
    }

    function test_customFees_fuzz(
        uint16 uplinkBps,
        uint16 channelBps,
        uint16 creatorBps,
        uint16 mintReferralBps,
        uint16 sponsorBps,
        uint256 ethMintPrice,
        uint256 erc20MintPrice,
        address erc20Address
    )
        public
    {
        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uplinkBps,
            channelBps,
            creatorBps,
            mintReferralBps,
            sponsorBps,
            ethMintPrice,
            erc20MintPrice,
            erc20Address
        );

        vm.startPrank(targetChannel);

        uint256 totalBps =
            uint80(uplinkBps) + uint80(channelBps) + uint80(creatorBps) + uint80(mintReferralBps) + uint80(sponsorBps);

        if (totalBps != 1e4 || ethMintPrice == 0) {
            vm.expectRevert();
            customFeesImpl.setChannelFees(feeArgs);
            return;
        }

        customFeesImpl.setChannelFees(feeArgs);

        IRewards.Split memory ethSplit = customFeesImpl.requestEthMint(nick, nick, nick, 1);
        IRewards.Split memory erc20Split;

        // expect revert if erc20 mints not configured
        if (erc20Address == address(0) || erc20MintPrice == 0 || ethMintPrice == 0) {
            vm.expectRevert();
            customFeesImpl.requestErc20Mint(nick, nick, nick, 1);
        } else {
            erc20Split = customFeesImpl.requestErc20Mint(nick, nick, nick, 1);
        }

        uint8 ethSplitLength_expected;
        uint8 erc20SplitLength_expected;

        if (ethMintPrice == 0) {
            ethSplitLength_expected = 0;
        } else {
            if (uplinkBps > 0) {
                ethSplitLength_expected++;
                erc20SplitLength_expected++;
            }
            if (channelBps > 0) {
                ethSplitLength_expected++;
                erc20SplitLength_expected++;
            }
            if (creatorBps > 0) {
                ethSplitLength_expected++;
                erc20SplitLength_expected++;
            }
            if (mintReferralBps > 0) {
                ethSplitLength_expected++;
                erc20SplitLength_expected++;
            }
            if (sponsorBps > 0) {
                ethSplitLength_expected++;
                erc20SplitLength_expected++;
            }
        }

        assertEq(ethSplit.recipients.length, ethSplitLength_expected);
        assertEq(ethSplit.allocations.length, ethSplitLength_expected);

        assertEq(erc20Split.recipients.length, erc20SplitLength_expected);
        assertEq(erc20Split.allocations.length, erc20SplitLength_expected);

        if (erc20Split.allocations.length > 0) {
            assertEq(erc20Split.totalAllocation, erc20MintPrice);
        }

        if (ethSplit.allocations.length > 0) {
            assertEq(ethSplit.totalAllocation, ethMintPrice);
        }
    }
}
