// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {CustomFees, IFees} from "../../src/fees/CustomFees.sol";
import {MockERC20} from "../TokenHelpers.sol";

contract FeesTest is Test {
    address nick = makeAddr("nick");
    address uplinkRewardsAddr = makeAddr("uplink");
    address targetChannel = makeAddr("targetChannel");
    address channelTreasury = makeAddr("channelTreasury");
    IFees customFeesImpl = new CustomFees(uplinkRewardsAddr);
    MockERC20 erc20Token = new MockERC20("testERC20", "TEST1");

    function test_customFees_bps() public {
        bytes memory feeArgs = abi.encode(
            777000000000000,
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            10 * 10e6,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFeeConfig(feeArgs);

        assertEq(customFeesImpl.getEthMintPrice(), 777000000000000);

        IFees.NativeMintCommands[] memory ethCommands = customFeesImpl.requestNativeMint(nick, nick, nick);

        IFees.Erc20MintCommands[] memory erc20Commands = customFeesImpl.requestErc20Mint(nick, nick, nick);

        assertEq(ethCommands.length, 5);
        assertEq(erc20Commands.length, 5);

        assertEq(ethCommands[0].amount, 77700000000000); // 10%
        assertEq(ethCommands[1].amount, 77700000000000); // 10%
        assertEq(ethCommands[2].amount, 77700000000000); // 10%
        assertEq(ethCommands[3].amount, 77700000000000); // 10%
        assertEq(ethCommands[4].amount, 466200000000000); // 60%

        assertEq(erc20Commands[0].amount, 10000000); // 10%
        assertEq(erc20Commands[1].amount, 10000000); // 10%
        assertEq(erc20Commands[2].amount, 10000000); // 10%
        assertEq(erc20Commands[3].amount, 10000000); // 10%
        assertEq(erc20Commands[4].amount, 60000000); // 60%

        vm.stopPrank();
    }

    function test_customFees_freeEthMint() public {
        bytes memory feeArgs = abi.encode(
            0, channelTreasury, uint16(0), uint16(0), uint16(0), uint16(0), uint16(0), 10 * 10e6, address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFeeConfig(feeArgs);

        assertEq(customFeesImpl.getEthMintPrice(), 0);

        IFees.NativeMintCommands[] memory ethCommands = customFeesImpl.requestNativeMint(nick, nick, nick);

        assertEq(ethCommands.length, 0);

        vm.stopPrank();
    }

    function test_generateCustomFees_nullChannelTreasury() public {
        bytes memory feeArgs = abi.encode(
            777000000000000,
            address(0),
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            10 * 10e6,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFeeConfig(feeArgs);

        IFees.NativeMintCommands[] memory nativeMintCommands = customFeesImpl.requestNativeMint(nick, nick, nick);
        IFees.Erc20MintCommands[] memory erc20Commands = customFeesImpl.requestErc20Mint(nick, nick, nick);

        assertEq(nativeMintCommands.length, 4);
        assertEq(erc20Commands.length, 4);
        vm.stopPrank();
    }

    function test_generateCustomFees_nullReferral() public {
        bytes memory feeArgs = abi.encode(
            777000000000000,
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            10 * 10e6,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFeeConfig(feeArgs);

        IFees.NativeMintCommands[] memory nativeMintCommands = customFeesImpl.requestNativeMint(nick, address(0), nick);
        IFees.Erc20MintCommands[] memory erc20Commands = customFeesImpl.requestErc20Mint(nick, address(0), nick);

        assertEq(nativeMintCommands.length, 4);
        assertEq(erc20Commands.length, 4);

        vm.stopPrank();
    }

    function test_generateCustomFees_revertOnNullCreator() public {
        bytes memory feeArgs = abi.encode(
            777000000000000,
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            10 * 10e6,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFeeConfig(feeArgs);

        vm.expectRevert();
        customFeesImpl.requestNativeMint(address(0), nick, nick);
        vm.expectRevert();
        customFeesImpl.requestErc20Mint(address(0), nick, nick);

        vm.stopPrank();
    }

    function test_generateCustomFees_revertOnNullSponsor() public {
        bytes memory feeArgs = abi.encode(
            777000000000000,
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            10 * 10e6,
            address(erc20Token)
        );

        vm.startPrank(targetChannel);
        customFeesImpl.setChannelFeeConfig(feeArgs);
        vm.expectRevert();
        customFeesImpl.requestNativeMint(nick, nick, address(0));
        vm.expectRevert();
        customFeesImpl.requestErc20Mint(nick, nick, address(0));
        vm.stopPrank();
    }

    function test_initializeCustomFees_fuzz(
        uint256 ethMintPrice,
        uint16 uplinkBps,
        uint16 channelBps,
        uint16 creatorBps,
        uint16 mintReferralBps,
        uint16 sponsorBps,
        uint256 erc20MintPrice,
        address erc20Address
    ) public {
        bytes memory feeArgs = abi.encode(
            ethMintPrice,
            channelTreasury,
            uplinkBps,
            channelBps,
            creatorBps,
            mintReferralBps,
            sponsorBps,
            erc20MintPrice,
            erc20Address
        );

        vm.startPrank(targetChannel);

        uint256 totalBps =
            uint80(uplinkBps) + uint80(channelBps) + uint80(creatorBps) + uint80(mintReferralBps) + uint80(sponsorBps);

        if (
            (totalBps % 10000 != 0) || ((uplinkBps * ethMintPrice) % 10000 != 0)
                || ((uplinkBps * erc20MintPrice) % 10000 != 0) || ((channelBps * ethMintPrice) % 10000 != 0)
                || ((creatorBps * ethMintPrice) % 10000 != 0) || ((mintReferralBps * ethMintPrice) % 10000 != 0)
                || ((sponsorBps * ethMintPrice) % 10000 != 0) || ((uplinkBps * erc20MintPrice) % 10000 != 0)
                || ((channelBps * erc20MintPrice) % 10000 != 0) || ((creatorBps * erc20MintPrice) % 10000 != 0)
                || ((mintReferralBps * erc20MintPrice) % 10000 != 0) || ((sponsorBps * erc20MintPrice) % 10000 != 0)
        ) {
            vm.expectRevert();
            customFeesImpl.setChannelFeeConfig(feeArgs);
            return;
        }

        customFeesImpl.setChannelFeeConfig(feeArgs);

        IFees.Erc20MintCommands[] memory erc20Commands;
        IFees.NativeMintCommands[] memory ethCommands = customFeesImpl.requestNativeMint(nick, nick, nick);

        // expect revert if erc20 mints not configured
        if (erc20Address == address(0) || erc20MintPrice == 0) {
            vm.expectRevert();
            customFeesImpl.requestErc20Mint(nick, nick, nick);
        } else {
            erc20Commands = customFeesImpl.requestErc20Mint(nick, nick, nick);
        }

        uint8 ethCommandsLength_expected;
        uint8 erc20CommandsLength_expected;

        if (ethMintPrice == 0) {
            ethCommandsLength_expected = 0;
        } else {
            if (uplinkBps > 0) {
                ethCommandsLength_expected++;
                erc20CommandsLength_expected++;
            }
            if (channelBps > 0) {
                ethCommandsLength_expected++;
                erc20CommandsLength_expected++;
            }
            if (creatorBps > 0) {
                ethCommandsLength_expected++;
                erc20CommandsLength_expected++;
            }
            if (mintReferralBps > 0) {
                ethCommandsLength_expected++;
                erc20CommandsLength_expected++;
            }
            if (sponsorBps > 0) {
                ethCommandsLength_expected++;
                erc20CommandsLength_expected++;
            }
        }

        assertEq(ethCommands.length, ethCommandsLength_expected);
        assertEq(erc20Commands.length, erc20CommandsLength_expected);
    }
}
