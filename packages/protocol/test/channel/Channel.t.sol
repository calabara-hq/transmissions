// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";

import { ChannelStorage } from "../../src/channel/ChannelStorage.sol";
import { ChannelFactory } from "../../src/factory/ChannelFactory.sol";
import { CustomFees } from "../../src/fees/CustomFees.sol";
import { IChannel } from "../../src/interfaces/IChannel.sol";
import { IFees } from "../../src/interfaces/IFees.sol";
import { ILogic } from "../../src/interfaces/ILogic.sol";
import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";
import { Logic } from "../../src/logic/Logic.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";

import { ChannelHarness } from "../utils/ChannelHarness.t.sol";
import { MockERC1155, MockERC20, MockERC721 } from "../utils/TokenHelpers.t.sol";
import { WETH } from "../utils/WETH.t.sol";

import { Test, console } from "forge-std/Test.sol";
import { IERC1155 } from "openzeppelin-contracts/token/ERC1155/IERC1155.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "openzeppelin-contracts/token/ERC721/IERC721.sol";

contract ChannelTest is Test {
    address nick = makeAddr("nick");
    address uplink = makeAddr("uplink");
    address uplinkRewardsAddr = makeAddr("uplink rewards");
    address admin = makeAddr("admin");
    address channelTreasury = makeAddr("channel treasury");
    ChannelHarness channelImpl;
    IFees customFeesImpl;
    ILogic logicImpl;
    IUpgradePath upgradePath;

    MockERC20 erc20Token;
    MockERC721 erc721Token;
    MockERC1155 erc1155Token;

    address weth = address(new WETH());

    function setUp() public {
        upgradePath = new UpgradePath();
        upgradePath.initialize(admin);

        customFeesImpl = new CustomFees(uplinkRewardsAddr);

        logicImpl = new Logic(address(this));
        logicImpl.approveLogic(IERC20.balanceOf.selector, 0);

        erc20Token = new MockERC20("testERC20", "TEST1");
        erc721Token = new MockERC721("testERC721", "TEST2");
        erc1155Token = new MockERC1155("testERC1155");

        channelImpl = new ChannelHarness(address(upgradePath), weth);

        bytes[] memory setupActions = new bytes[](2);

        /// @dev fees

        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            0.000777 ether,
            1_000_000,
            address(erc20Token)
        );
        setupActions[0] = abi.encodeWithSelector(Channel.setFees.selector, address(customFeesImpl), feeArgs);

        /// @dev creator logic

        address[] memory creatorTargets = new address[](1);
        bytes4[] memory creatorSignatures = new bytes4[](1);
        bytes[] memory creatorDatas = new bytes[](1);
        bytes[] memory creatorOperators = new bytes[](1);
        bytes[] memory creatorLiteralOperands = new bytes[](1);

        creatorTargets[0] = address(erc20Token);
        creatorSignatures[0] = IERC20.balanceOf.selector;
        creatorDatas[0] = abi.encode(address(0));
        creatorOperators[0] = abi.encodePacked(">");
        creatorLiteralOperands[0] = abi.encode(1_000_000);

        /// @dev minter logic

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

        channelImpl.initialize("https://example.com/api/token/0", nick, new address[](0), setupActions, abi.encode(100));
    }

    function _createTokenHelper(address creator) internal {
        /// @dev mint tokens to creator to satisfy creator requirements
        erc20Token.mint(creator, 1_000_001);

        vm.startPrank(creator);
        vm.expectEmit();
        emit IChannel.TokenCreated(
            1, ChannelStorage.TokenConfig("https://example.com/api/token/1", creator, 100, 0, creator)
        );

        channelImpl.createToken("https://example.com/api/token/1", creator, 100);
        vm.stopPrank();
    }

    function test_channel_createToken() external {
        address creator = makeAddr("creator");

        vm.startPrank(creator);
        // expect revert if creator does not meet creator requirements
        vm.expectRevert();
        channelImpl.createToken("https://example.com/api/token/1", creator, 100);

        _createTokenHelper(creator);
        assertEq("https://example.com/api/token/1", channelImpl.getToken(1).uri);
        assertEq(channelImpl.getUserStats(creator).numCreations, 1);

        vm.stopPrank();
    }

    function test_channel_mintTokenWithETH() external {
        address minter = makeAddr("minter");
        address creator = makeAddr("creator");
        address referral = makeAddr("referral");

        /// @dev create a test token
        _createTokenHelper(creator);

        /// @dev ensure eth mint price is set correctly
        assertEq(channelImpl.ethMintPrice(), 0.000777 ether);

        /// @dev expect revert if minter does not meet minter requirements
        vm.expectRevert();
        channelImpl.mint(minter, 1, 1, referral, "");

        /// @dev mint 2 tokens to minter to satisfy minter requirements
        erc721Token.mint(minter, 1);
        erc721Token.mint(minter, 2);

        uint256 amount = 1;

        vm.deal(minter, 0.000777 ether * amount);

        vm.startPrank(minter);

        uint256[] memory tokenIds = new uint256[](1);
        tokenIds[0] = 1;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = amount;

        vm.expectEmit();
        emit IChannel.TokenMinted(minter, referral, tokenIds, amounts, "");
        channelImpl.mint{ value: 0.000777 ether * amount }(minter, 1, 1, referral, "");
        vm.stopPrank();

        /// @dev verify user has 1 token and total minted is 1
        assertEq(IERC1155(address(channelImpl)).balanceOf(minter, 1), 1);
        assertEq(channelImpl.getToken(1).totalMinted, 1);

        /// @dev 70% of mint price since creator is also first minter
        assertEq(creator.balance, 0.000777 ether * 70 / 100);
        assertEq(channelTreasury.balance, 0.000777 ether * 10 / 100);
        assertEq(uplinkRewardsAddr.balance, 0.000777 ether * 10 / 100);
        assertEq(referral.balance, 0.000777 ether * 10 / 100);

        /// @dev ensure user stats are updated
        assertEq(channelImpl.getUserStats(minter).numMints, 1);
    }

    function test_mintToken_withERC20() external {
        address minter = makeAddr("minter");
        address creator = makeAddr("creator");
        address referral = makeAddr("referral");

        /// @dev create a test token
        _createTokenHelper(creator);

        /// @dev ensure erc20 mint price is set correctly
        assertEq(channelImpl.erc20MintPrice(), 1_000_000);

        uint256 creatorErc20StartingBalance = erc20Token.balanceOf(creator);

        /// @dev expect revert if minter does not meet minter requirements
        vm.expectRevert();
        channelImpl.mintWithERC20(minter, 1, 1, referral, "");

        uint256 amount = 10;

        /// @dev mint 2 tokens to minter to satisfy minter requirements
        erc721Token.mint(minter, 1);
        erc721Token.mint(minter, 2);

        /// @dev mint erc20 tokens to minter for minting
        erc20Token.mint(minter, 1_000_000 * amount);

        vm.startPrank(minter);
        erc20Token.approve(address(channelImpl), 1_000_000 * amount);

        channelImpl.mintWithERC20(minter, 1, amount, referral, "");
        vm.stopPrank();

        /// @dev verify user has 1 token and total minted is 1
        assertEq(IERC1155(address(channelImpl)).balanceOf(minter, 1), amount);
        assertEq(channelImpl.getToken(1).totalMinted, amount);

        /// @dev 70% of mint price since creator is also first minter
        assertEq(erc20Token.balanceOf(creator), creatorErc20StartingBalance + 1_000_000 * amount * 70 / 100);
        assertEq(erc20Token.balanceOf(channelTreasury), 1_000_000 * amount * 10 / 100);
        assertEq(erc20Token.balanceOf(uplinkRewardsAddr), 1_000_000 * amount * 10 / 100);
        assertEq(erc20Token.balanceOf(referral), 1_000_000 * amount * 10 / 100);
    }

    function test_channel_mintBatchWithEth() external {
        address minter = makeAddr("minter");
        address creator = makeAddr("creator");
        address referral = makeAddr("referral");

        /// @dev mint tokens to creator to satisfy creator requirements
        erc20Token.mint(creator, 1_000_000 * 10);

        /// @dev mint 2 tokens to minter to satisfy minter requirements
        erc721Token.mint(minter, 1);
        erc721Token.mint(minter, 2);

        vm.deal(minter, 0.000777 ether * 10);

        vm.startPrank(creator);

        for (uint256 i = 1; i <= 10; i++) {
            channelImpl.createToken("https://example.com/api/token/1", creator, 100);
        }
        vm.stopPrank();

        uint256[] memory tokenIds = new uint256[](10);
        uint256[] memory amounts = new uint256[](10);

        for (uint256 i = 0; i < 10; i++) {
            tokenIds[i] = i + 1;
            amounts[i] = 1;
        }

        vm.startPrank(minter);
        channelImpl.mintBatchWithETH{ value: 0.000777 ether * 10 }(minter, tokenIds, amounts, referral, "");
        vm.stopPrank();

        /// @dev verify user has tokenId's 1-10 and total minted for each is 1

        for (uint256 i = 0; i < 10; i++) {
            assertEq(IERC1155(address(channelImpl)).balanceOf(minter, i + 1), 1);
            assertEq(channelImpl.getToken(i + 1).totalMinted, 1);
        }
        /// @dev 70% of mint price since creator is also first minter
        assertEq(creator.balance, 0.000777 ether * 10 * 70 / 100);
        assertEq(channelTreasury.balance, 0.000777 ether * 10 * 10 / 100);
        assertEq(uplinkRewardsAddr.balance, 0.000777 ether * 10 * 10 / 100);
        assertEq(referral.balance, 0.000777 ether * 10 * 10 / 100);

        /// @dev ensure user stats are updated
        assertEq(channelImpl.getUserStats(minter).numMints, 10);
    }

    function test_channel_mintBatchWithERC20() external {
        address minter = makeAddr("minter");
        address creator = makeAddr("creator");
        address referral = makeAddr("referral");

        /// @dev mint tokens to creator to satisfy creator requirements
        erc20Token.mint(creator, 1_000_000 * 10);

        uint256 creatorErc20StartingBalance = erc20Token.balanceOf(creator);

        /// @dev mint 2 tokens to minter to satisfy minter requirements
        erc721Token.mint(minter, 1);
        erc721Token.mint(minter, 2);

        vm.startPrank(creator);

        for (uint256 i = 1; i <= 10; i++) {
            channelImpl.createToken("https://example.com/api/token/1", creator, 100);
        }
        vm.stopPrank();

        uint256[] memory tokenIds = new uint256[](10);
        uint256[] memory amounts = new uint256[](10);

        for (uint256 i = 0; i < 10; i++) {
            tokenIds[i] = i + 1;
            amounts[i] = 1;
        }

        vm.startPrank(minter);
        erc20Token.mint(minter, 1_000_000 * 10);
        erc20Token.approve(address(channelImpl), 1_000_000 * 10);
        channelImpl.mintBatchWithERC20(minter, tokenIds, amounts, referral, "");
        vm.stopPrank();

        /// @dev verify user has tokenId's 1-10 and total minted for each is 1

        for (uint256 i = 0; i < 10; i++) {
            assertEq(IERC1155(address(channelImpl)).balanceOf(minter, i + 1), 1);
            assertEq(channelImpl.getToken(i + 1).totalMinted, 1);
        }

        /// @dev 70% of mint price since creator is also first minter
        assertEq(erc20Token.balanceOf(creator), creatorErc20StartingBalance + 1_000_000 * 10 * 70 / 100);
        assertEq(erc20Token.balanceOf(channelTreasury), 1_000_000 * 10 * 10 / 100);
        assertEq(erc20Token.balanceOf(uplinkRewardsAddr), 1_000_000 * 10 * 10 / 100);
        assertEq(erc20Token.balanceOf(referral), 1_000_000 * 10 * 10 / 100);
    }

    function test_channel_emptyLogicAndFees() external {
        ChannelHarness newChannelImpl = new ChannelHarness(address(upgradePath), address(0));

        newChannelImpl.initialize(
            "https://example.com/api/token/0", nick, new address[](0), new bytes[](0), abi.encode(100)
        );

        newChannelImpl.createToken("sampleToken", nick, 100);
        assertEq("sampleToken", newChannelImpl.getToken(1).uri);

        address minter = makeAddr("minter");
        vm.startPrank(minter);

        newChannelImpl.mint(minter, 1, 1, nick, "");

        /// @dev verify user has 1 token and total minted is 1
        assertEq(1, newChannelImpl.getToken(1).totalMinted);
        assertEq(IERC1155(address(newChannelImpl)).balanceOf(minter, 1), 1);

        vm.stopPrank();
    }

    function test_initialize() external {
        ChannelHarness newChannelImpl = new ChannelHarness(address(upgradePath), address(0));
        newChannelImpl.initialize(
            "https://example.com/api/token/0", nick, new address[](0), new bytes[](0), abi.encode(100)
        );
        assertEq("https://example.com/api/token/0", newChannelImpl.getToken(0).uri);
        assertEq(0, newChannelImpl.getToken(0).maxSupply);
        assertEq(0, newChannelImpl.getToken(0).totalMinted);
    }

    function test_updateChannelTokenUri() external {
        vm.expectRevert();
        channelImpl.updateChannelTokenUri("https://new-example.com/api/token/1");

        vm.startPrank(nick);
        channelImpl.updateChannelTokenUri("https://new-example.com/api/token/1");
        assertEq("https://new-example.com/api/token/1", channelImpl.getToken(0).uri);
        vm.stopPrank();
    }
}
