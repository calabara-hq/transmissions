// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {console2} from "forge-std/Test.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {IChannel, Channel} from "../../src/channel/Channel.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {IERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import {Uplink1155} from "../../src/proxies/Uplink1155.sol";
import {CustomFees, IFees} from "../../src/fees/CustomFees.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {ILogic, Logic} from "../../src/logic/Logic.sol";
import {IUpgradePath, UpgradePath} from "../../src/utils/UpgradePath.sol";
import {MockERC20, MockERC721, MockERC1155} from "../TokenHelpers.sol";
import {ITiming, InfiniteRound} from "../../src/timing/InfiniteRound.sol";
import {ChannelStorageV1} from "../../src/channel/ChannelStorageV1.sol";

contract ChannelTest is Test {
    address nick = makeAddr("nick");
    address uplink = makeAddr("uplink");
    address uplinkRewardsAddr = makeAddr("uplink rewards");
    address admin = makeAddr("admin");
    address sampleAdmin1 = makeAddr("sampleAdmin1");
    address sampleAdmin2 = makeAddr("sampleAdmin2");
    Channel channelImpl;
    Channel targetChannel;
    IFees customFeesImpl;
    ILogic logicImpl;
    IUpgradePath upgradePath;
    ITiming infiniteRoundImpl;

    MockERC20 erc20Token;
    MockERC721 erc721Token;
    MockERC1155 erc1155Token;

    function setUp() public {
        upgradePath = new UpgradePath();
        upgradePath.initialize(admin);

        customFeesImpl = new CustomFees(uplinkRewardsAddr);
        logicImpl = new Logic(address(this));

        infiniteRoundImpl = new InfiniteRound();

        logicImpl.approveLogic(IERC20.balanceOf.selector, 0);

        channelImpl = new Channel(address(upgradePath));
        targetChannel = Channel(payable(address(new Uplink1155(address(channelImpl)))));

        erc20Token = new MockERC20("testERC20", "TEST1");
        erc721Token = new MockERC721("testERC721", "TEST2");
        erc1155Token = new MockERC1155("testERC1155");

        bytes[] memory setupActions = new bytes[](3);

        /// fees

        bytes memory feeArgs = abi.encode(
            777000000000000,
            makeAddr("channel treasury"),
            uint16(1000),
            uint16(1000),
            uint16(6000),
            uint16(1000),
            uint16(1000),
            10 * 10e18,
            address(erc20Token)
        );
        setupActions[0] = abi.encodeWithSelector(Channel.setChannelFeeConfig.selector, address(customFeesImpl), feeArgs);

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

        /// timing

        setupActions[2] = abi.encodeWithSelector(
            Channel.setTimingConfig.selector,
            address(infiniteRoundImpl),
            abi.encode(uint40(60)) // 60 second duration
        );

        targetChannel.initialize("https://example.com/api/token/0", nick, new address[](0), setupActions);
    }

    function test_createToken() external {
        address creator = makeAddr("creator");

        vm.startPrank(creator);
        // expect revert if creator does not meet creator requirements
        vm.expectRevert();
        targetChannel.createToken("https://example.com/api/token/1", creator, 100);

        // mint tokens to creator
        erc20Token.mint(creator, 5 * 10e18);

        targetChannel.createToken("https://example.com/api/token/1", creator, 100);
        assertEq("https://example.com/api/token/1", targetChannel.getToken(1).uri);

        vm.stopPrank();
    }

    function _createTokenHelper(address creator) internal {
        // mint tokens to creator
        erc20Token.mint(creator, 5 * 10e18);
        // create token
        vm.startPrank(creator);
        targetChannel.createToken("https://example.com/api/token/1", creator, 100);
        vm.stopPrank();
    }

    function test_mintToken_withETH() external {
        address minter = makeAddr("minter");
        address creator = makeAddr("creator");

        _createTokenHelper(creator);

        vm.startPrank(minter);

        assertEq(targetChannel.ethMintPrice(), 777000000000000);

        /// expect revert if minter does not meet minter requirements
        vm.expectRevert();
        targetChannel.mint(minter, 1, 1, creator, "");

        /// eth mint

        /// mint 2 tokens to minter
        erc721Token.mint(minter, 1);
        erc721Token.mint(minter, 2);
        vm.deal(address(minter), 777000000000000);
        targetChannel.mint{value: 777000000000000}(minter, 1, 1, creator, "");

        assertEq(IERC1155(targetChannel).balanceOf(minter, 1), 1);

        /// @dev 80% of mint price since creator is also first minter and mint referrer
        assertEq(creator.balance, 621600000000000);
        vm.stopPrank();
    }

    function test_mintToken_withERC20() external {
        address minter = makeAddr("minter");
        address creator = makeAddr("creator");

        _createTokenHelper(creator);

        vm.startPrank(minter);

        assertEq(targetChannel.erc20MintPrice(), 10 * 10e18);
        erc20Token.mint(minter, 100 * 10e18);
        erc20Token.approve(address(targetChannel), 100 * 10e18);

        uint256 creatorErc20StartingBalance = erc20Token.balanceOf(creator);

        // expect revert if minter does not meet minter requirements
        vm.expectRevert();
        targetChannel.mintWithERC20(minter, 1, 1, creator, "");

        /// mint 2 logic tokens to minter
        erc721Token.mint(minter, 1);
        erc721Token.mint(minter, 2);

        uint8 numTokens = 10;
        targetChannel.mintWithERC20(minter, 1, numTokens, creator, "");

        // verify mint occured
        assertEq(IERC1155(targetChannel).balanceOf(minter, 1), numTokens);
        // verify creator received 80% of the erc20 mint price
        assertEq(erc20Token.balanceOf(creator), creatorErc20StartingBalance + (8e19 * numTokens));

        vm.stopPrank();
    }

    function test_initialize() external {
        Channel newChannelImpl = new Channel(address(upgradePath));
        Channel sampleChannel = Channel(payable(address(new Uplink1155(address(channelImpl)))));
        sampleChannel.initialize("https://example.com/api/token/0", nick, new address[](0), new bytes[](0));
        assertEq("https://example.com/api/token/0", sampleChannel.getToken(0).uri);
        assertEq(0, sampleChannel.getToken(0).maxSupply);
        assertEq(0, sampleChannel.getToken(0).totalMinted);
    }

    function test_updateChannelTokenUri() external {
        Channel newChannelImpl = new Channel(address(upgradePath));
        Channel sampleChannel = Channel(payable(address(new Uplink1155(address(channelImpl)))));
        sampleChannel.initialize("https://example.com/api/token/0", nick, new address[](0), new bytes[](0));

        vm.startPrank(nick);
        sampleChannel.updateChannelTokenUri("https://new-example.com/api/token/1");
        assertEq("https://new-example.com/api/token/1", sampleChannel.getToken(0).uri);
        vm.stopPrank();
    }
}
