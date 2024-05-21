// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";
import { ChannelFactory } from "../../src/factory/ChannelFactory.sol";
import { CustomFees } from "../../src/fees/CustomFees.sol";
import { Logic } from "../../src/logic/Logic.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";

import { IChannel } from "../../src/interfaces/IChannel.sol";
import { IFees } from "../../src/interfaces/IFees.sol";
import { ILogic } from "../../src/interfaces/ILogic.sol";
import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";

import { ChannelHarness } from "../utils/ChannelHarness.t.sol";
import { MockERC1155, MockERC20, MockERC721 } from "../utils/TokenHelpers.t.sol";
import { WETH } from "../utils/WETH.t.sol";

import { Test, console } from "forge-std/Test.sol";
import { ERC1155 } from "openzeppelin-contracts/token/ERC1155/ERC1155.sol";
import { IERC1155 } from "openzeppelin-contracts/token/ERC1155/IERC1155.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "openzeppelin-contracts/token/ERC721/IERC721.sol";

contract ChannelTest is Test {
    address nick = makeAddr("nick");
    address uplink = makeAddr("uplink");
    address uplinkRewardsAddr = makeAddr("uplink rewards");
    address admin = makeAddr("admin");
    address sampleAdmin1 = makeAddr("sampleAdmin1");
    address sampleAdmin2 = makeAddr("sampleAdmin2");
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

        /// fees

        bytes memory feeArgs = abi.encode(
            channelTreasury,
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            777_000_000_000_000,
            1_000_000,
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
        creatorLiteralOperands[0] = abi.encode(1_000_000);

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

        channelImpl.initialize("https://example.com/api/token/0", nick, new address[](0), setupActions, abi.encode(100));
    }

    function test_createToken() external {
        address creator = makeAddr("creator");

        vm.startPrank(creator);
        // expect revert if creator does not meet creator requirements
        vm.expectRevert();
        channelImpl.createToken("https://example.com/api/token/1", creator, 100);

        // mint tokens to creator
        erc20Token.mint(creator, 1_000_001);

        channelImpl.createToken("https://example.com/api/token/1", creator, 100);
        assertEq("https://example.com/api/token/1", channelImpl.getToken(1).uri);

        vm.stopPrank();
    }

    function _createTokenHelper(address creator) internal {
        // mint tokens to creator
        erc20Token.mint(creator, 1_000_001);
        // create token
        vm.startPrank(creator);
        channelImpl.createToken("https://example.com/api/token/1", creator, 100);
        vm.stopPrank();
    }

    function test_mintToken_withETH() external {
        address minter = makeAddr("minter");
        address creator = makeAddr("creator");

        _createTokenHelper(creator);

        vm.startPrank(minter);

        assertEq(channelImpl.ethMintPrice(), 777_000_000_000_000);

        /// expect revert if minter does not meet minter requirements
        vm.expectRevert();
        channelImpl.mint(minter, 1, 1, creator, "");

        /// eth mint

        /// mint 2 tokens to minter
        erc721Token.mint(minter, 1);
        erc721Token.mint(minter, 2);
        vm.deal(address(minter), 777_000_000_000_000);
        channelImpl.mint{ value: 777_000_000_000_000 }(minter, 1, 1, creator, "");

        assertEq(IERC1155(address(channelImpl)).balanceOf(minter, 1), 1);

        /// @dev 80% of mint price since creator is also first minter and mint referrer
        assertEq(creator.balance, 621_600_000_000_000);
        vm.stopPrank();
    }

    function test_mintToken_withERC20() external {
        address minter = makeAddr("minter");
        address creator = makeAddr("creator");
        address referrer = makeAddr("referrer");

        _createTokenHelper(creator);

        vm.startPrank(minter);

        assertEq(channelImpl.erc20MintPrice(), 1_000_000);

        erc20Token.mint(minter, 10_000_000); // enough to mint 10 tokens
        erc20Token.approve(address(channelImpl), 10_000_000);

        uint256 creatorErc20StartingBalance = erc20Token.balanceOf(creator);

        // expect revert if minter does not meet minter requirements
        vm.expectRevert();
        channelImpl.mintWithERC20(minter, 1, 1, referrer, "");

        /// mint 2 logic tokens to minter
        erc721Token.mint(minter, 1);
        erc721Token.mint(minter, 2);

        uint8 numTokens = 10;

        channelImpl.mintWithERC20(minter, 1, numTokens, referrer, "");

        // verify mint occured
        assertEq(IERC1155(address(channelImpl)).balanceOf(minter, 1), numTokens);
        // verify creator received 60% (creator fee) + 10% (sponsor fee) of the erc20 mint price * numTokens
        assertEq(erc20Token.balanceOf(creator), creatorErc20StartingBalance + 7_000_000);

        vm.stopPrank();
    }

    function test_channel_emptyLogicAndFees() external {
        ChannelHarness newChannelImpl = new ChannelHarness(address(upgradePath), address(0));
        bytes[] memory setupActions = new bytes[](0);
        newChannelImpl.initialize(
            "https://example.com/api/token/0", nick, new address[](0), setupActions, abi.encode(100)
        );

        // try to create a token
        newChannelImpl.createToken("sampleToken", nick, 100);

        // try to mint a token
        newChannelImpl.mint(nick, 1, 1, nick, "");
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
