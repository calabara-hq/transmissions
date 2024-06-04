// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { CustomFees } from "../../src/fees/CustomFees.sol";
import { IFees } from "../../src/interfaces/IFees.sol";
import { NativeTokenLib } from "../../src/libraries/NativeTokenLib.sol";
import { Rewards } from "../../src/rewards/Rewards.sol";
import { MockERC20 } from "../utils/TokenHelpers.t.sol";

import { WETH } from "../utils/WETH.t.sol";
import { Test, console } from "forge-std/Test.sol";

contract RewardsHarness is Rewards {
    constructor(address weth) Rewards(weth) { }

    using NativeTokenLib for address;

    function distributePassThroughSplit(Rewards.Split memory split) external payable {
        _distributePassThroughSplit(split);
    }
}

contract FeesTest is Test {
    address nick = makeAddr("nick");
    address uplinkRewardsAddr = makeAddr("uplink");
    address targetChannel = makeAddr("targetChannel");
    address channelTreasury = makeAddr("channelTreasury");

    address creator = makeAddr("creator");
    address referral = makeAddr("referral");
    address sponsor = makeAddr("sponsor");

    address weth = address(new WETH());
    RewardsHarness rewardsImpl = new RewardsHarness(weth);

    IFees customFeesImpl = new CustomFees(uplinkRewardsAddr);

    MockERC20 erc20Token = new MockERC20("testERC20", "TEST1");

    function test_customFees_versioning() external {
        assertEq("1.0.0", customFeesImpl.contractVersion());
        assertEq("Custom Fees", customFeesImpl.contractName());
        assertEq(customFeesImpl.contractURI(), "https://github.com/calabara-hq/transmissions/packages/protocol");
    }

    function _mockBatchedMint(
        address creator,
        address referral,
        address sponsor,
        uint256 batchSize
    )
        internal
        returns (Rewards.Split memory, Rewards.Split memory)
    {
        address[] memory creators = new address[](batchSize);
        address[] memory sponsors = new address[](batchSize);
        uint256[] memory amounts = new uint256[](batchSize);

        for (uint256 i = 0; i < batchSize; i++) {
            creators[i] = creator;
            sponsors[i] = sponsor;
            amounts[i] = 1;
        }

        return (
            customFeesImpl.requestEthMint(creators, sponsors, amounts, referral),
            customFeesImpl.requestErc20Mint(creators, sponsors, amounts, referral)
        );
    }

    function test_customFees_allocations(uint256 batchSize) public {
        batchSize = bound(batchSize, 1, 100);

        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            0.000777 ether,
            100_000_000,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFees(feeArgs);

        assertEq(customFeesImpl.getEthMintPrice(), 0.000777 ether);

        (Rewards.Split memory ethSplit, Rewards.Split memory erc20Split) =
            _mockBatchedMint(creator, referral, sponsor, batchSize);

        assertEq(ethSplit.recipients.length, 2 * batchSize + 3);
        assertEq(ethSplit.allocations.length, 2 * batchSize + 3);
        assertEq(ethSplit.totalAllocation, 0.000777 ether * batchSize);
        assertEq(ethSplit.token, NativeTokenLib.NATIVE_TOKEN);

        vm.deal(targetChannel, 0.000777 ether * batchSize);
        erc20Token.mint(targetChannel, 100_000_000 * batchSize);
        erc20Token.approve(address(rewardsImpl), 100_000_000 * batchSize);

        /// @dev distribute the split

        rewardsImpl.distributePassThroughSplit{ value: 0.000777 ether * batchSize }(ethSplit);
        rewardsImpl.distributePassThroughSplit(erc20Split);

        /// @dev validate the balances of the recipients

        assertEq(creator.balance, 0.0004662 ether * batchSize);
        assertEq(sponsor.balance, 0.0000777 ether * batchSize);
        assertEq(referral.balance, 0.0000777 ether * batchSize);
        assertEq(uplinkRewardsAddr.balance, 0.0000777 ether * batchSize);
        assertEq(channelTreasury.balance, 0.0000777 ether * batchSize);

        assertEq(erc20Token.balanceOf(creator), 60_000_000 * batchSize);
        assertEq(erc20Token.balanceOf(sponsor), 10_000_000 * batchSize);
        assertEq(erc20Token.balanceOf(referral), 10_000_000 * batchSize);
        assertEq(erc20Token.balanceOf(uplinkRewardsAddr), 10_000_000 * batchSize);
        assertEq(erc20Token.balanceOf(channelTreasury), 10_000_000 * batchSize);

        vm.stopPrank();
    }

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

        (Rewards.Split memory ethSplit, Rewards.Split memory erc20Split) =
            _mockBatchedMint(creator, referral, sponsor, 1);

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

        (Rewards.Split memory ethSplit, Rewards.Split memory erc20Split) =
            _mockBatchedMint(creator, address(0), sponsor, 1);

        assertEq(ethSplit.recipients.length, 4);
        assertEq(ethSplit.allocations.length, 4);

        assertEq(erc20Split.recipients.length, 4);
        assertEq(erc20Split.allocations.length, 4);

        vm.stopPrank();
    }

    function test_customFees_revertOnNullCreator() public {
        address[] memory creators = new address[](1);
        address[] memory sponsors = new address[](1);
        uint256[] memory amounts = new uint256[](1);

        creators[0] = address(0);
        sponsors[0] = sponsor;
        amounts[0] = 1;

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

        vm.expectRevert(CustomFees.AddressZero.selector);
        customFeesImpl.requestEthMint(creators, sponsors, amounts, referral);
        vm.expectRevert(CustomFees.AddressZero.selector);
        customFeesImpl.requestErc20Mint(creators, sponsors, amounts, referral);

        vm.stopPrank();
    }

    function test_customFees_revertOnNullSponsor() public {
        address[] memory creators = new address[](1);
        address[] memory sponsors = new address[](1);
        uint256[] memory amounts = new uint256[](1);

        creators[0] = creator;
        sponsors[0] = address(0);
        amounts[0] = 1;

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

        vm.expectRevert(CustomFees.AddressZero.selector);
        customFeesImpl.requestEthMint(creators, sponsors, amounts, referral);

        vm.expectRevert(CustomFees.AddressZero.selector);
        customFeesImpl.requestErc20Mint(creators, sponsors, amounts, referral);

        vm.stopPrank();
    }

    function test_customFees_revertOnFreeMint() public {
        address[] memory creators = new address[](1);
        address[] memory sponsors = new address[](1);
        uint256[] memory amounts = new uint256[](1);

        creators[0] = creator;
        sponsors[0] = sponsor;
        amounts[0] = 1;

        bytes memory feeArgs = abi.encode(
            channelTreasury, uint16(0), uint16(0), uint16(0), uint16(0), uint16(0), 0, 10 * 10e6, address(erc20Token)
        );

        vm.startPrank(targetChannel);

        vm.expectRevert(CustomFees.InvalidETHMintPrice.selector);
        customFeesImpl.setChannelFees(feeArgs);

        vm.expectRevert(CustomFees.InvalidETHMintPrice.selector);
        customFeesImpl.requestEthMint(creators, sponsors, amounts, referral);

        vm.expectRevert(CustomFees.ERC20MintingDisabled.selector);
        customFeesImpl.requestErc20Mint(creators, sponsors, amounts, referral);

        vm.stopPrank();
    }

    function test_customFees_revertOnMissingConfig() public {
        address[] memory creators = new address[](1);
        address[] memory sponsors = new address[](1);
        uint256[] memory amounts = new uint256[](1);

        creators[0] = creator;
        sponsors[0] = sponsor;
        amounts[0] = 1;

        vm.startPrank(targetChannel);

        vm.expectRevert(CustomFees.InvalidETHMintPrice.selector);
        customFeesImpl.requestEthMint(creators, sponsors, amounts, referral);

        vm.expectRevert(CustomFees.ERC20MintingDisabled.selector);
        customFeesImpl.requestErc20Mint(creators, sponsors, amounts, referral);
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
        uint256 totalBps =
            uint80(uplinkBps) + uint80(channelBps) + uint80(creatorBps) + uint80(mintReferralBps) + uint80(sponsorBps);

        if (totalBps != 1e4 || ethMintPrice == 0) {
            vm.expectRevert();
            customFeesImpl.setChannelFees(feeArgs);
        } else {
            customFeesImpl.setChannelFees(feeArgs);
        }
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
        address[] memory creators = new address[](1);
        address[] memory sponsors = new address[](1);
        uint256[] memory amounts = new uint256[](1);

        creators[0] = creator;
        sponsors[0] = address(0);
        amounts[0] = 1;

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

        Rewards.Split memory ethSplit = customFeesImpl.requestEthMint(creators, sponsors, amounts, referral);
        Rewards.Split memory erc20Split;

        /// @dev expect revert if erc20 mints not configured
        if (erc20Address == address(0) || erc20MintPrice == 0 || ethMintPrice == 0) {
            vm.expectRevert();
            customFeesImpl.requestErc20Mint(creators, sponsors, amounts, referral);
        } else {
            erc20Split = customFeesImpl.requestErc20Mint(creators, sponsors, amounts, referral);
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
