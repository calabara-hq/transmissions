// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ChannelStorage } from "../../src/channel/ChannelStorage.sol";
import { DeferredTokenAuthorization } from "../../src/utils/DeferredTokenAuthorization.sol";

import { Channel } from "../../src/channel/Channel.sol";
import { CustomFees } from "../../src/fees/CustomFees.sol";
import { IFees } from "../../src/interfaces/IFees.sol";
import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";
import { ChannelHarness } from "../utils/ChannelHarness.t.sol";
import { SigUtils } from "../utils/SigUtils.t.sol";

import { MockERC20 } from "../utils/TokenHelpers.t.sol";
import { WETH } from "../utils/WETH.t.sol";
import { Test } from "forge-std/Test.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract ChannelTokenSponsorshipTest is Test {
  ChannelHarness channelImpl;
  DeferredTokenAuthorization deferredTokenAuthorization;
  SigUtils sigUtils;
  address weth = address(new WETH());
  IUpgradePath upgradePath;
  MockERC20 erc20Token;
  IFees customFeesImpl;

  address uplink = makeAddr("uplink");
  address uplinkRewardsAddr = makeAddr("uplink rewards");
  address admin = makeAddr("admin");
  address channelTreasury = makeAddr("channel treasury");
  address minter = makeAddr("minter");
  address referral = makeAddr("referral");
  uint256 authorPrivateKey = 0xABCDE;
  address author = vm.addr(authorPrivateKey);

  function setUp() public {
    upgradePath = new UpgradePath();
    upgradePath.initialize(admin);
    customFeesImpl = new CustomFees(uplinkRewardsAddr);
    channelImpl = new ChannelHarness(address(upgradePath), weth);
    sigUtils = new SigUtils("Transmissions", "1", block.chainid, address(channelImpl));
    erc20Token = new MockERC20("testERC20", "TEST");
  }

  function initializeChannelWithSetupActions(bytes memory feeArgs, bytes memory logicArgs) internal {
    bytes[] memory setupActions;

    if (feeArgs.length > 0 && logicArgs.length > 0) {
      setupActions = new bytes[](2);
      setupActions[0] = feeArgs;
      setupActions[1] = logicArgs;
    } else if (feeArgs.length > 0) {
      setupActions = new bytes[](1);
      setupActions[0] = feeArgs;
    } else if (logicArgs.length > 0) {
      setupActions = new bytes[](1);
      setupActions[0] = logicArgs;
    } else {
      setupActions = new bytes[](0);
    }

    channelImpl.initialize(
      "https://example.com/api/token/0",
      "my contract",
      admin,
      new address[](0),
      setupActions,
      abi.encode(100)
    );
  }

  function createSampleFees(uint256 ethMintPrice, uint256 erc20MintPrice) internal returns (bytes memory) {
    return
      abi.encode(
        channelTreasury,
        uint16(1000),
        uint16(1000),
        uint16(6000),
        uint16(1000),
        uint16(1000),
        ethMintPrice,
        erc20MintPrice,
        address(erc20Token)
      );
  }

  function encodeFeesWithSelector(bytes memory feeArgs) internal returns (bytes memory) {
    return abi.encodeWithSelector(Channel.setFees.selector, address(customFeesImpl), feeArgs);
  }

  function stringToBytes32(string memory source) public pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }

    assembly {
      result := mload(add(source, 32))
    }
  }

  function test_channelSponsorship_sponsorWithERC20() external {
    uint256 ethMintPrice = 0.000777 ether;
    uint256 erc20MintPrice = 1_000_000;

    initializeChannelWithSetupActions(
      encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
      new bytes(0)
    );

    vm.startPrank(minter);

    erc20Token.mint(minter, 1_000_000);
    erc20Token.approve(address(channelImpl), 1_000_000);

    DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
      .DeferredTokenPermission(
        "https://transmissions.network/nft/1",
        1000,
        block.timestamp + 10,
        stringToBytes32("abc")
      );

    bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

    (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

    channelImpl.sponsorWithERC20(deferredToken, author, v, r, s, minter, 1, referral, "");

    vm.stopPrank();

    /// check token creation state

    assertEq(channelImpl.getToken(1).uri, "https://transmissions.network/nft/1");
    assertEq(channelImpl.getToken(1).maxSupply, 1000);

    /// check mint reward state

    assertEq(erc20Token.balanceOf(author), (1_000_000 * 60) / 100); // 60%
    assertEq(erc20Token.balanceOf(channelTreasury), (1_000_000 * 10) / 100); // 10%
    assertEq(erc20Token.balanceOf(uplinkRewardsAddr), (1_000_000 * 10) / 100); // 10%
    assertEq(erc20Token.balanceOf(referral), (1_000_000 * 10) / 100); // 10%
    assertEq(erc20Token.balanceOf(minter), (1_000_000 * 10) / 100); // 10%
  }

  function test_channelSponsorship_sponsorWithETH() external {
    uint256 ethMintPrice = 0.000777 ether;
    uint256 erc20MintPrice = 1_000_000;

    initializeChannelWithSetupActions(
      encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
      new bytes(0)
    );

    vm.deal(minter, ethMintPrice);

    vm.startPrank(minter);

    DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
      .DeferredTokenPermission(
        "https://transmissions.network/nft/1",
        1000,
        block.timestamp + 10,
        stringToBytes32("abc")
      );

    bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

    (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

    channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken, author, v, r, s, minter, 1, referral, "");
    vm.stopPrank();

    /// check token creation state

    assertEq(channelImpl.getToken(1).uri, "https://transmissions.network/nft/1");
    assertEq(channelImpl.getToken(1).maxSupply, 1000);

    /// check mint reward state

    assertEq(author.balance, (0.000777 ether * 60) / 100); // 60%
    assertEq(channelTreasury.balance, (0.000777 ether * 10) / 100); // 10%
    assertEq(uplinkRewardsAddr.balance, (0.000777 ether * 10) / 100); // 10%
    assertEq(referral.balance, (0.000777 ether * 10) / 100); // 10%
    assertEq(minter.balance, (0.000777 ether * 10) / 100); // 10%
  }

  function test_channelSponsorship_allowNonLinearExecution() public {
    uint256 ethMintPrice = 0.000777 ether;
    uint256 erc20MintPrice = 1_000_000;

    initializeChannelWithSetupActions(
      encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
      new bytes(0)
    );

    vm.deal(minter, ethMintPrice * 2);

    vm.startPrank(minter);

    DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken1 = DeferredTokenAuthorization
      .DeferredTokenPermission(
        "https://transmissions.network/nft/1",
        1000,
        block.timestamp + 10,
        stringToBytes32("abc")
      );

    bytes32 digest1 = sigUtils.getTypedDataHash(deferredToken1);

    (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(authorPrivateKey, digest1);

    DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken2 = DeferredTokenAuthorization
      .DeferredTokenPermission(
        "https://transmissions.network/nft/1",
        10_001,
        block.timestamp + 10,
        stringToBytes32("xyz")
      );

    bytes32 digest2 = sigUtils.getTypedDataHash(deferredToken2);

    (uint8 v2, bytes32 r2, bytes32 s2) = vm.sign(authorPrivateKey, digest2);

    channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken2, author, v2, r2, s2, minter, 1, referral, "");

    channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken1, author, v1, r1, s1, minter, 1, referral, "");
    vm.stopPrank();
  }

  function test_channelSponsorship_revertOnUsedSignature() public {
    uint256 ethMintPrice = 0.000777 ether;
    uint256 erc20MintPrice = 1_000_000;

    initializeChannelWithSetupActions(
      encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
      new bytes(0)
    );

    vm.deal(minter, ethMintPrice);

    vm.startPrank(minter);

    DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
      .DeferredTokenPermission(
        "https://transmissions.network/nft/1",
        1000,
        block.timestamp + 10,
        stringToBytes32("abc")
      );

    bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

    (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

    channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken, author, v, r, s, minter, 1, referral, "");

    vm.expectRevert();
    channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken, author, v, r, s, minter, 1, referral, "");
    vm.stopPrank();
  }

  function test_channelSponsorship_revertOnExpiredSignature() public {
    uint256 ethMintPrice = 0.000777 ether;
    uint256 erc20MintPrice = 1_000_000;

    initializeChannelWithSetupActions(
      encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
      new bytes(0)
    );

    vm.deal(minter, ethMintPrice);

    vm.startPrank(minter);

    DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
      .DeferredTokenPermission(
        "https://transmissions.network/nft/1",
        1000,
        block.timestamp + 10,
        stringToBytes32("abc")
      );

    bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

    (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

    vm.warp(block.timestamp + 20);
    vm.expectRevert();
    channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken, author, v, r, s, minter, 1, referral, "");
    vm.stopPrank();
  }
}
