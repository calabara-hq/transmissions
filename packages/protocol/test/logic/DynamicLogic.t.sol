// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ILogic } from "../../src/interfaces/ILogic.sol";
import { DynamicLogic } from "../../src/logic/DynamicLogic.sol";

import { MockERC1155, MockERC20, MockERC721 } from "../utils/TokenHelpers.t.sol";
import { Test, console } from "forge-std/Test.sol";
import { IERC1155 } from "openzeppelin-contracts/token/ERC1155/IERC1155.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { IERC721 } from "openzeppelin-contracts/token/ERC721/IERC721.sol";

interface IMockBool {
    function getBool(address _address) external view returns (bool);
}

contract MockBool {
    bool public boolValue;

    function getBool(address _address) external view returns (bool) {
        return boolValue;
    }

    function setBool(bool _val) public {
        boolValue = _val;
    }
}

contract ChannelTest is Test {
    address creator = makeAddr("creator");
    address minter = makeAddr("minter");
    address targetChannel = makeAddr("targetChannel");
    DynamicLogic logicImpl;

    MockERC20 erc20Token;
    MockERC721 erc721Token;
    MockERC1155 erc1155Token;
    MockBool mockBool;

    function setUp() public {
        logicImpl = new DynamicLogic(address(this));

        /// approve some sample logic

        logicImpl.approveLogic(IERC20.balanceOf.selector, 0);
        logicImpl.approveLogic(IERC721.balanceOf.selector, 0);
        logicImpl.approveLogic(IERC1155.balanceOf.selector, 0);
        logicImpl.approveLogic(IMockBool.getBool.selector, 0);

        erc20Token = new MockERC20("testERC20", "TEST1");
        erc721Token = new MockERC721("testERC721", "TEST2");
        erc1155Token = new MockERC1155("testERC1155");
        mockBool = new MockBool();
    }

    function test_creatorLogic_uniformRule() external {
        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        DynamicLogic.Operator[] memory operators = new DynamicLogic.Operator[](1);
        bytes[] memory literalOperands = new bytes[](1);
        DynamicLogic.InteractionPowerType[] memory interactionPowerType = new DynamicLogic.InteractionPowerType[](1);
        uint256[] memory interactionPower = new uint256[](1);

        targets[0] = address(erc20Token);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode("");
        operators[0] = DynamicLogic.Operator.GREATERTHAN;
        literalOperands[0] = abi.encode(uint256(1 * 10 ** 18));
        interactionPowerType[0] = DynamicLogic.InteractionPowerType.UNIFORM;
        interactionPower[0] = 100;

        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(
            abi.encode(targets, signatures, datas, operators, literalOperands, interactionPowerType, interactionPower)
        );

        uint256 creationPowerBeforeMint = logicImpl.calculateCreatorInteractionPower(creator);

        assertEq(creationPowerBeforeMint, 0);

        erc20Token.mint(creator, 2 * 10 ** 18);

        uint256 creationPowerAfterMint = logicImpl.calculateCreatorInteractionPower(creator);
        assertEq(creationPowerAfterMint, 100);

        vm.stopPrank();
    }

    function test_creatorLogic_weightedRule() external {
        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        DynamicLogic.Operator[] memory operators = new DynamicLogic.Operator[](1);
        bytes[] memory literalOperands = new bytes[](1);
        DynamicLogic.InteractionPowerType[] memory interactionPowerType = new DynamicLogic.InteractionPowerType[](1);
        uint256[] memory interactionPower = new uint256[](1);

        targets[0] = address(erc20Token);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode("");
        operators[0] = DynamicLogic.Operator.GREATERTHAN;
        literalOperands[0] = abi.encode(uint256(0));
        interactionPowerType[0] = DynamicLogic.InteractionPowerType.WEIGHTED;
        interactionPower[0] = 0;

        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(
            abi.encode(targets, signatures, datas, operators, literalOperands, interactionPowerType, interactionPower)
        );

        uint256 creationPowerBeforeMint = logicImpl.calculateCreatorInteractionPower(creator);

        assertEq(creationPowerBeforeMint, 0);

        erc20Token.mint(creator, 2 * 10 ** 18);

        uint256 creationPowerAfterMint = logicImpl.calculateCreatorInteractionPower(creator);
        assertEq(creationPowerAfterMint, 2 * 10 ** 18);

        vm.stopPrank();
    }

    function test_creatorLogic_multiRuleGetMaxInteractionPower(
        uint256 ip_1,
        uint256 ip_2,
        uint256 ip_3,
        uint256 ip_4,
        bool isWeighted
    )
        external
    {
        address[] memory targets = new address[](4);
        bytes4[] memory signatures = new bytes4[](4);
        bytes[] memory datas = new bytes[](4);
        DynamicLogic.Operator[] memory operators = new DynamicLogic.Operator[](4);
        bytes[] memory literalOperands = new bytes[](4);
        DynamicLogic.InteractionPowerType[] memory interactionPowerType = new DynamicLogic.InteractionPowerType[](4);
        uint256[] memory interactionPower = new uint256[](4);

        targets[0] = address(erc20Token);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode("");
        operators[0] = DynamicLogic.Operator.GREATERTHAN;
        literalOperands[0] = abi.encode(uint256(0));
        interactionPowerType[0] =
            isWeighted ? DynamicLogic.InteractionPowerType.WEIGHTED : DynamicLogic.InteractionPowerType.UNIFORM;
        interactionPower[0] = ip_1;

        targets[1] = address(erc721Token);
        signatures[1] = IERC721.balanceOf.selector;
        datas[1] = abi.encode(address(0));
        operators[1] = DynamicLogic.Operator.GREATERTHAN;
        literalOperands[1] = abi.encode(uint256(0));
        interactionPowerType[1] =
            isWeighted ? DynamicLogic.InteractionPowerType.WEIGHTED : DynamicLogic.InteractionPowerType.UNIFORM;
        interactionPower[1] = ip_2;

        targets[2] = address(erc1155Token);
        signatures[2] = IERC1155.balanceOf.selector;
        datas[2] = abi.encode(address(0), 1);
        operators[2] = DynamicLogic.Operator.GREATERTHAN;
        literalOperands[2] = abi.encode(uint256(0));
        interactionPowerType[2] =
            isWeighted ? DynamicLogic.InteractionPowerType.WEIGHTED : DynamicLogic.InteractionPowerType.UNIFORM;
        interactionPower[2] = ip_3;

        targets[3] = address(mockBool);
        signatures[3] = IMockBool.getBool.selector;
        datas[3] = abi.encode(address(0));
        operators[3] = DynamicLogic.Operator.EQUALS;
        literalOperands[3] = abi.encode(uint256(1));
        interactionPowerType[3] =
            isWeighted ? DynamicLogic.InteractionPowerType.WEIGHTED : DynamicLogic.InteractionPowerType.UNIFORM;
        interactionPower[3] = ip_4;

        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(
            abi.encode(targets, signatures, datas, operators, literalOperands, interactionPowerType, interactionPower)
        );

        uint256 creationPowerBeforeMint = logicImpl.calculateCreatorInteractionPower(creator);

        assertEq(erc20Token.balanceOf(creator), 0);
        assertEq(creationPowerBeforeMint, 0);

        erc20Token.mint(creator, 2 * 10 ** 18);
        erc721Token.mint(creator, 1);
        erc1155Token.mint(creator, 1, 1, "");
        mockBool.setBool(true);

        // calculate the max interaction power

        uint256 adjusted_ip_1 = isWeighted ? 2 * 10 ** 18 : ip_1;
        uint256 adjusted_ip_2 = isWeighted ? 1 : ip_2;
        uint256 adjusted_ip_3 = isWeighted ? 1 : ip_3;
        uint256 adjusted_ip_4 = isWeighted ? 1 : ip_4;

        uint256 maxInteractionPower = adjusted_ip_1;

        if (adjusted_ip_2 > maxInteractionPower) {
            maxInteractionPower = adjusted_ip_2;
        }
        if (adjusted_ip_3 > maxInteractionPower) {
            maxInteractionPower = adjusted_ip_3;
        }
        if (adjusted_ip_4 > maxInteractionPower) {
            maxInteractionPower = adjusted_ip_4;
        }

        uint256 creationPowerAfterMint = logicImpl.calculateCreatorInteractionPower(creator);

        assertEq(creationPowerAfterMint, maxInteractionPower);

        vm.stopPrank();
    }

    function test_logic_unapprovedRule() external {
        DynamicLogic newImpl = new DynamicLogic(address(this));

        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        DynamicLogic.Operator[] memory operators = new DynamicLogic.Operator[](1);
        bytes[] memory literalOperands = new bytes[](1);
        DynamicLogic.InteractionPowerType[] memory interactionPowerType = new DynamicLogic.InteractionPowerType[](1);
        uint256[] memory interactionPower = new uint256[](1);

        targets[0] = address(erc20Token);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode(address(0));
        operators[0] = DynamicLogic.Operator.GREATERTHAN;
        literalOperands[0] = abi.encode(uint256(3 * 10 ** 18));
        interactionPowerType[0] = DynamicLogic.InteractionPowerType.UNIFORM;
        interactionPower[0] = 100;

        vm.startPrank(targetChannel);
        vm.expectRevert(DynamicLogic.InvalidSignature.selector);
        newImpl.setCreatorLogic(
            abi.encode(targets, signatures, datas, operators, literalOperands, interactionPowerType, interactionPower)
        );

        vm.stopPrank();
    }

    function test_emptyLogic() public {
        address sampleUser = makeAddr("sampleUser");

        vm.startPrank(targetChannel);

        uint256 creatorResult = logicImpl.calculateCreatorInteractionPower(sampleUser);
        assert(creatorResult == UINT256_MAX);

        uint256 minterResult = logicImpl.calculateMinterInteractionPower(sampleUser);
        assert(minterResult == UINT256_MAX);

        logicImpl.setCreatorLogic(
            abi.encode(
                new address[](0),
                new bytes4[](0),
                new bytes[](0),
                new DynamicLogic.Operator[](0),
                new bytes[](0),
                new DynamicLogic.InteractionPowerType[](0),
                new uint256[](0)
            )
        );
        logicImpl.setMinterLogic(
            abi.encode(
                new address[](0),
                new bytes4[](0),
                new bytes[](0),
                new DynamicLogic.Operator[](0),
                new bytes[](0),
                new DynamicLogic.InteractionPowerType[](0),
                new uint256[](0)
            )
        );

        creatorResult = logicImpl.calculateCreatorInteractionPower(sampleUser);
        assert(creatorResult == UINT256_MAX);

        minterResult = logicImpl.calculateMinterInteractionPower(sampleUser);
        assert(minterResult == UINT256_MAX);

        vm.stopPrank();
    }

    function test_approveLogic_unauthorized() public {
        address sampleUser = makeAddr("sampleUser");
        vm.startPrank(sampleUser);
        vm.expectRevert();
        logicImpl.approveLogic(IERC20.balanceOf.selector, 0);
        vm.stopPrank();
    }

    function test_transferOwnership() public {
        address sampleUser = makeAddr("sampleUser");

        logicImpl.transferOwnership(sampleUser);
        assertEq(logicImpl.owner(), sampleUser);
    }
}
