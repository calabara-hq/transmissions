// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test, console } from "forge-std/Test.sol";

import { InfiniteChannel } from "../../src/channel/InfiniteChannel.sol";

import { CustomFees, IFees } from "../../src/fees/CustomFees.sol";
import { ILogic, Logic } from "../../src/logic/Logic.sol";

import { IUpgradePath, UpgradePath } from "../../src/utils/UpgradePath.sol";
import { MockERC1155, MockERC20, MockERC721 } from "../TokenHelpers.sol";
import { ERC1155 } from "openzeppelin-contracts/token/ERC1155/ERC1155.sol";
import { IERC1155 } from "openzeppelin-contracts/token/ERC1155/IERC1155.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "openzeppelin-contracts/token/ERC721/IERC721.sol";

import { Channel } from "../../src/channel/Channel.sol";
import { InfiniteUplink1155 } from "../../src/proxies/InfiniteUplink1155.sol";

contract InfiniteChannelTest is Test {
  address nick = makeAddr("nick");
  address uplink = makeAddr("uplink");
  address uplinkRewardsAddr = makeAddr("uplink rewards");
  address admin = makeAddr("admin");
  address sampleAdmin1 = makeAddr("sampleAdmin1");
  address sampleAdmin2 = makeAddr("sampleAdmin2");

  InfiniteChannel channelImpl;
  InfiniteChannel targetChannel;

  IFees customFeesImpl;
  ILogic logicImpl;

  IUpgradePath upgradePath;

  MockERC20 erc20Token;
  MockERC721 erc721Token;
  MockERC1155 erc1155Token;

  function setUp() public {
    upgradePath = new UpgradePath();
    upgradePath.initialize(admin);

    customFeesImpl = new CustomFees(uplinkRewardsAddr);
    logicImpl = new Logic(address(this));

    logicImpl.approveLogic(IERC20.balanceOf.selector, 0);

    channelImpl = new InfiniteChannel(address(upgradePath), address(0));
    targetChannel = InfiniteChannel(payable(address(new InfiniteUplink1155(address(channelImpl)))));

    erc20Token = new MockERC20("testERC20", "TEST1");
    erc721Token = new MockERC721("testERC721", "TEST2");
    erc1155Token = new MockERC1155("testERC1155");

    bytes[] memory setupActions = new bytes[](2);

    /// fees

    bytes memory feeArgs = abi.encode(
      makeAddr("channel treasury"),
      uint16(1000),
      uint16(1000),
      uint16(6000),
      uint16(1000),
      uint16(1000),
      777_000_000_000_000,
      10 * 10e18,
      address(erc20Token)
    );
    setupActions[0] = abi.encodeWithSelector(Channel.setFees.selector, address(customFeesImpl), feeArgs);

    /// creator logic

    address[] memory creatorTargets = new address[](1);
    bytes4[] memory creatorSignatures = new bytes4[](1);
    bytes[] memory creatorDatas = new bytes[](1);
    bytes[] memory creatorOperators = new bytes[](1);
    bytes[] memory creatorLiteralOperands = new bytes[](1);

    creatorTargets[0] = address(erc20Token);
    creatorSignatures[0] = IERC20.balanceOf.selector;
    creatorDatas[0] = abi.encode(address(0));
    creatorOperators[0] = abi.encodePacked(">");
    creatorLiteralOperands[0] = abi.encode(uint256(3 * 10 ** 18));

    /// minter logic

    address[] memory minterTargets = new address[](1);
    bytes4[] memory minterSignatures = new bytes4[](1);
    bytes[] memory minterDatas = new bytes[](1);
    bytes[] memory minterOperators = new bytes[](1);
    bytes[] memory minterLiteralOperands = new bytes[](1);

    minterTargets[0] = address(erc721Token);
    minterSignatures[0] = IERC721.balanceOf.selector;
    minterDatas[0] = abi.encode(address(0));
    minterOperators[0] = abi.encodePacked(">");
    minterLiteralOperands[0] = abi.encode(1);

    setupActions[1] = abi.encodeWithSelector(
      Channel.setLogic.selector,
      address(logicImpl),
      abi.encode(creatorTargets, creatorSignatures, creatorDatas, creatorOperators, creatorLiteralOperands),
      abi.encode(minterTargets, minterSignatures, minterDatas, minterOperators, minterLiteralOperands)
    );

    targetChannel.initialize("https://example.com/api/token/0", nick, new address[](0), setupActions, abi.encode(100));
  }

  function test_initialize() external {
    InfiniteChannel newChannelImpl = new InfiniteChannel(address(upgradePath), address(0));
    InfiniteChannel sampleChannel = InfiniteChannel(payable(address(new InfiniteUplink1155(address(channelImpl)))));
    sampleChannel.initialize(
      "https://example.com/api/token/0",
      nick,
      new address[](0),
      new bytes[](0),
      abi.encode(100)
    );
    assertEq("https://example.com/api/token/0", sampleChannel.getToken(0).uri);
    assertEq(0, sampleChannel.getToken(0).maxSupply);
    assertEq(0, sampleChannel.getToken(0).totalMinted);
  }
}
