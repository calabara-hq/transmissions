// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ILogic, Logic} from "../../src/logic/Logic.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";

contract ChannelTest is Test {
    address nick = 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C;
    address targetChannel = makeAddr("targetContract");
    ILogic logicImpl;

    function setUp() public {
        logicImpl = new Logic();

        /// approve some sample logic

        logicImpl.approveLogic(IERC20.balanceOf.selector, 0);
        logicImpl.approveLogic(IERC1155.balanceOf.selector, 0);
    }

    function test_creatorLogic_erc20Rule() external {
        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        bytes[] memory operators = new bytes[](1);
        bytes[] memory literalOperands = new bytes[](1);

        targets[0] = address(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode(address(0));

        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(uint256(3 * 10 ** 6));

        logicImpl.setCreatorLogic(
            targetChannel,
            abi.encode(targets, signatures, datas, operators, literalOperands)
        );

        vm.startPrank(nick);
        bool result = logicImpl.isCreatorApproved(targetChannel, nick);
        vm.stopPrank();

        assert(result == true);
    }

    function test_creatorLogic_erc1155Rule() external {
        address targetChannel = makeAddr("targetChannel");

        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        bytes[] memory operators = new bytes[](1);
        bytes[] memory literalOperands = new bytes[](1);

        targets[0] = address(0xcf6e80deFd9BE067f5adDa2924B55C2186D3e930);
        signatures[0] = IERC1155.balanceOf.selector;

        datas[0] = abi.encode(address(0), 1);
        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(1);

        logicImpl.setCreatorLogic(
            targetChannel,
            abi.encode(targets, signatures, datas, operators, literalOperands)
        );

        vm.startPrank(nick);
        bool result = logicImpl.isCreatorApproved(targetChannel, nick);
        vm.stopPrank();

        assert(result == true);
    }

    function test_creatorLogic_multiRule() external {
        address[] memory targets = new address[](2);
        bytes4[] memory signatures = new bytes4[](2);
        bytes[] memory datas = new bytes[](2);
        bytes[] memory operators = new bytes[](2);
        bytes[] memory literalOperands = new bytes[](2);

        /// this rule should return true
        targets[0] = address(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode(address(0));
        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(uint256(3 * 10 ** 6));

        /// this rule should return false
        targets[1] = address(0xcf6e80deFd9BE067f5adDa2924B55C2186D3e930);
        signatures[1] = IERC1155.balanceOf.selector;
        datas[1] = abi.encode(address(0), 1);
        operators[1] = abi.encodePacked(">");
        literalOperands[1] = abi.encode(5);

        logicImpl.setCreatorLogic(
            targetChannel,
            abi.encode(targets, signatures, datas, operators, literalOperands)
        );

        vm.startPrank(nick);
        bool result = logicImpl.isCreatorApproved(targetChannel, nick);
        vm.stopPrank();

        assert(result == true);
    }

    function test_minterLogic_multiRule() external {
        address[] memory targets = new address[](2);
        bytes4[] memory signatures = new bytes4[](2);
        bytes[] memory datas = new bytes[](2);
        bytes[] memory operators = new bytes[](2);
        bytes[] memory literalOperands = new bytes[](2);

        /// this rule should return true
        targets[0] = address(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode(address(0));
        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(uint256(3 * 10 ** 6));

        /// this rule should return false
        targets[1] = address(0xcf6e80deFd9BE067f5adDa2924B55C2186D3e930);
        signatures[1] = IERC1155.balanceOf.selector;
        datas[1] = abi.encode(address(0), 1);
        operators[1] = abi.encodePacked(">");
        literalOperands[1] = abi.encode(5);

        logicImpl.setMinterLogic(
            targetChannel,
            abi.encode(targets, signatures, datas, operators, literalOperands)
        );

        vm.startPrank(nick);
        bool result = logicImpl.isMinterApproved(targetChannel, nick);
        vm.stopPrank();

        assert(result == true);
    }

}
