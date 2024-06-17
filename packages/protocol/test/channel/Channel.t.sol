// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";

import { ChannelStorage } from "../../src/channel/ChannelStorage.sol";
import { ChannelFactory } from "../../src/factory/ChannelFactory.sol";
import { CustomFees } from "../../src/fees/CustomFees.sol";
import { IFees } from "../../src/interfaces/IFees.sol";
import { ILogic } from "../../src/interfaces/ILogic.sol";
import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";
import { DynamicLogic } from "../../src/logic/DynamicLogic.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";

import { ChannelHarness } from "../utils/ChannelHarness.t.sol";
import { MockERC1155, MockERC20, MockERC721 } from "../utils/TokenHelpers.t.sol";
import { WETH } from "../utils/WETH.t.sol";

import { Test, console } from "forge-std/Test.sol";
import { IERC1155 } from "openzeppelin-contracts/token/ERC1155/IERC1155.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "openzeppelin-contracts/token/ERC721/IERC721.sol";

contract ChannelTest is Test {
  address uplink = makeAddr("uplink");
  address uplinkRewardsAddr = makeAddr("uplink rewards");
  address admin = makeAddr("admin");
  address channelTreasury = makeAddr("channel treasury");
  address creator = makeAddr("creator");
  address minter = makeAddr("minter");
  address referral = makeAddr("referral");

  ChannelHarness channelImpl;
  IFees customFeesImpl;
  ILogic logicImpl;
  IUpgradePath upgradePath;

  MockERC20 erc20Token;

  address weth = address(new WETH());

  function setUp() public {
    upgradePath = new UpgradePath();
    upgradePath.initialize(admin);

    customFeesImpl = new CustomFees(uplinkRewardsAddr);

    logicImpl = new DynamicLogic(address(this));
    logicImpl.approveLogic(IERC20.balanceOf.selector, 0);
    erc20Token = new MockERC20("testERC20", "TEST");

    channelImpl = new ChannelHarness(address(upgradePath), weth);
  }

  /* -------------------------------------------------------------------------- */
  /*                                   HELPERS                                  */
  /* -------------------------------------------------------------------------- */

  function createERC20SampleLogic(
    DynamicLogic.InteractionPowerType interactionType,
    uint256 literalOperand,
    uint256 interactionPower
  ) internal returns (bytes memory) {
    address[] memory targets = new address[](1);
    bytes4[] memory signatures = new bytes4[](1);
    bytes[] memory datas = new bytes[](1);
    DynamicLogic.Operator[] memory operators = new DynamicLogic.Operator[](1);
    bytes[] memory literalOperands = new bytes[](1);
    DynamicLogic.InteractionPowerType[] memory interactionPowerTypes = new DynamicLogic.InteractionPowerType[](1);
    uint256[] memory interactionPowers = new uint256[](1);

    targets[0] = address(erc20Token);
    signatures[0] = IERC20.balanceOf.selector;
    datas[0] = abi.encode("");
    operators[0] = DynamicLogic.Operator.GREATERTHAN;
    literalOperands[0] = abi.encode(literalOperand);
    interactionPowerTypes[0] = interactionType;
    interactionPowers[0] = interactionPower;

    return abi.encode(targets, signatures, datas, operators, literalOperands, interactionPowerTypes, interactionPowers);
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

  function encodeLogicWithSelector(
    bytes memory creatorLogic,
    bytes memory minterLogic
  ) internal returns (bytes memory) {
    return abi.encodeWithSelector(Channel.setLogic.selector, address(logicImpl), creatorLogic, minterLogic);
  }

  function mintERC20ToUser(address user, uint256 requiredMinimum) internal {
    erc20Token.mint(user, requiredMinimum + 1);
  }

  function createToken(address creator, uint256 maxSupply) internal returns (uint256) {
    return channelImpl.createToken("https://example.com/api/token/1", creator, maxSupply);
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

  /* -------------------------------------------------------------------------- */
  /*                                    TESTS                                   */
  /* -------------------------------------------------------------------------- */

  function test_channel_initialization() external {
    initializeChannelWithSetupActions(new bytes(0), new bytes(0));

    assertEq(channelImpl.uri(0), "https://example.com/api/token/0");
    assertEq(channelImpl.name(), "my contract");
  }

  function test_channel_updateChannelTokenUri() external {
    initializeChannelWithSetupActions(new bytes(0), new bytes(0));

    vm.startPrank(admin);
    vm.expectEmit();
    emit Channel.TokenURIUpdated(0, "https://example.com/api/token/1");
    channelImpl.updateChannelTokenUri("https://example.com/api/token/1");
    vm.stopPrank();

    assertEq(channelImpl.uri(0), "https://example.com/api/token/1");
  }

  function test_channel_updateChannelMetadata() external {
    initializeChannelWithSetupActions(new bytes(0), new bytes(0));

    vm.startPrank(admin);
    channelImpl.updateChannelMetadata("new name", "new uri");
    vm.stopPrank();

    assertEq(channelImpl.name(), "new name");
    assertEq(channelImpl.uri(0), "new uri");
  }

  function test_channel_mintTokenWithETH() external {
    uint256 ethMintPrice = 0.000777 ether;

    initializeChannelWithSetupActions(encodeFeesWithSelector(createSampleFees(ethMintPrice, 0)), new bytes(0));

    vm.startPrank(creator);
    createToken(creator, 100);
    vm.stopPrank();

    vm.startPrank(minter);

    /// @dev expect revert with insufficient funds

    vm.expectRevert();
    channelImpl.mint{ value: ethMintPrice }(minter, 1, 1, referral, "");

    vm.deal(minter, ethMintPrice);
    channelImpl.mint{ value: ethMintPrice }(minter, 1, 1, referral, "");
    vm.stopPrank();

    assertEq(IERC1155(address(channelImpl)).balanceOf(minter, 1), 1);
    assertEq(channelImpl.getToken(1).totalMinted, 1);
  }

  function test_channel_mintTokenWithERC20() external {
    uint256 erc20MintPrice = 1_000_000;
    uint256 ethMintPrice = 0.000777 ether;

    initializeChannelWithSetupActions(
      encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
      new bytes(0)
    );

    vm.startPrank(creator);
    createToken(creator, 100);
    vm.stopPrank();

    vm.startPrank(minter);

    /// @dev expect revert without erc20 allowance

    vm.expectRevert();
    channelImpl.mintWithERC20(minter, 1, 1, referral, "");

    erc20Token.approve(address(channelImpl), erc20MintPrice);

    /// @dev expect revert with insufficient funds

    vm.expectRevert();
    channelImpl.mintWithERC20(minter, 1, 1, referral, "");

    erc20Token.mint(minter, erc20MintPrice);
    channelImpl.mintWithERC20(minter, 1, 1, referral, "");

    vm.stopPrank();

    assertEq(IERC1155(address(channelImpl)).balanceOf(minter, 1), 1);
    assertEq(channelImpl.getToken(1).totalMinted, 1);
  }

  function test_channel_mintBatch(uint8 batchSize) external {
    vm.assume(batchSize > 0);
    uint256 ethMintPrice = 0.000777 ether;
    uint256 erc20MintPrice = 1_000_000;

    initializeChannelWithSetupActions(
      encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
      new bytes(0)
    );

    vm.startPrank(creator);

    uint256[] memory tokenIds = new uint256[](batchSize);
    uint256[] memory amounts = new uint256[](batchSize);

    for (uint256 i = 0; i < batchSize; i++) {
      uint256 tokenId = createToken(creator, 2);
      tokenIds[i] = tokenId;
      amounts[i] = 1;
    }

    vm.stopPrank();

    vm.startPrank(minter);

    erc20Token.mint(minter, erc20MintPrice * batchSize);
    erc20Token.approve(address(channelImpl), erc20MintPrice * batchSize);

    vm.deal(minter, ethMintPrice * batchSize);

    channelImpl.mintBatchWithERC20(minter, tokenIds, amounts, referral, "");

    channelImpl.mintBatchWithETH{ value: ethMintPrice * batchSize }(minter, tokenIds, amounts, referral, "");

    vm.stopPrank();

    for (uint256 i = 0; i < batchSize; i++) {
      assertEq(IERC1155(address(channelImpl)).balanceOf(minter, tokenIds[i]), 2);
      assertEq(channelImpl.getToken(tokenIds[i]).totalMinted, 2);
    }
  }

  function test_channel_mintTokenWithSufficientInteractionPower(uint128 minimumInteractionPower) external {
    bytes memory creatorLogic = createERC20SampleLogic(
      DynamicLogic.InteractionPowerType.WEIGHTED,
      minimumInteractionPower,
      0
    );

    bytes memory minterLogic = createERC20SampleLogic(
      DynamicLogic.InteractionPowerType.UNIFORM,
      minimumInteractionPower,
      100
    );

    initializeChannelWithSetupActions(new bytes(0), encodeLogicWithSelector(creatorLogic, minterLogic));

    mintERC20ToUser(creator, minimumInteractionPower);
    mintERC20ToUser(minter, minimumInteractionPower);

    vm.startPrank(creator);
    createToken(creator, 100);
    vm.stopPrank();

    vm.startPrank(minter);
    channelImpl.mint(minter, 1, 1, referral, "");
    vm.stopPrank();

    assertEq(IERC1155(address(channelImpl)).balanceOf(minter, 1), 1);
    assertEq(channelImpl.getToken(1).totalMinted, 1);
  }

  function test_channel_freeMintZeroLogic() external {
    initializeChannelWithSetupActions(new bytes(0), new bytes(0));

    vm.startPrank(creator);
    createToken(creator, 100);
    vm.stopPrank();

    vm.startPrank(minter);
    channelImpl.mint(minter, 1, 1, referral, "");
    vm.stopPrank();

    assertEq(IERC1155(address(channelImpl)).balanceOf(minter, 1), 1);
    assertEq(channelImpl.getToken(1).totalMinted, 1);
  }

  function test_channel_mintRequirements() external {
    initializeChannelWithSetupActions(new bytes(0), new bytes(0));

    vm.startPrank(creator);
    channelImpl.createToken("sampleToken", admin, 3);
    vm.stopPrank();

    vm.startPrank(minter);

    /// @dev expect revert if token maxSupply is 0 (default token)
    vm.expectRevert(Channel.NotMintable.selector);
    channelImpl.mint(minter, 0, 1, referral, "");

    /// @dev expect revert if amount > maxSupply - totalMinted
    vm.expectRevert(Channel.AmountExceedsMaxSupply.selector);
    channelImpl.mint(minter, 1, 5, referral, "");

    /// @dev expect revert if amount = 0
    vm.expectRevert(Channel.AmountZero.selector);
    channelImpl.mint(minter, 1, 0, referral, "");

    /// @dev mint up to maxSupply
    channelImpl.mint(minter, 1, 3, referral, "");

    /// @dev expect revert if totalMinted > maxSupply
    vm.expectRevert(Channel.SoldOut.selector);
    channelImpl.mint(minter, 1, 1, referral, "");

    vm.stopPrank();
  }

  function test_channel_ETHRewardsDistributed() external {
    uint256 ethMintPrice = 0.000777 ether;

    initializeChannelWithSetupActions(encodeFeesWithSelector(createSampleFees(ethMintPrice, 0)), new bytes(0));

    vm.startPrank(creator);
    createToken(creator, 100);
    vm.stopPrank();

    vm.startPrank(minter);

    vm.deal(minter, ethMintPrice);

    channelImpl.mint{ value: ethMintPrice }(minter, 1, 1, referral, "");

    vm.stopPrank();

    assertEq(creator.balance, (ethMintPrice * 70) / 100); // 70% = 60% creator + 10% sponsor
    assertEq(channelTreasury.balance, (ethMintPrice * 10) / 100); // 10% of mint price
    assertEq(uplinkRewardsAddr.balance, (ethMintPrice * 10) / 100); // 10% of mint price
    assertEq(referral.balance, (ethMintPrice * 10) / 100); // 10% of mint price
  }

  function test_channel_ERC20RewardsDistributed() external {
    uint256 ethMintPrice = 0.000777 ether;
    uint256 erc20MintPrice = 1_000_000;

    initializeChannelWithSetupActions(
      encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
      new bytes(0)
    );

    vm.startPrank(creator);
    createToken(creator, 100);
    vm.stopPrank();

    vm.startPrank(minter);
    erc20Token.mint(minter, 1_000_000);
    erc20Token.approve(address(channelImpl), 1_000_000);

    channelImpl.mintWithERC20(minter, 1, 1, referral, "");

    vm.stopPrank();

    assertEq(erc20Token.balanceOf(creator), (1_000_000 * 70) / 100); // 70% = 60% creator + 10% sponsor
    assertEq(erc20Token.balanceOf(channelTreasury), (1_000_000 * 10) / 100); // 10% of mint price
    assertEq(erc20Token.balanceOf(uplinkRewardsAddr), (1_000_000 * 10) / 100); // 10% of mint price
    assertEq(erc20Token.balanceOf(referral), (1_000_000 * 10) / 100); // 10% of mint price
  }
}
