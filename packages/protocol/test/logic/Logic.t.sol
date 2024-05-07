// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {ILogic, Logic} from "../../src/logic/Logic.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {IERC721} from "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import {IERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol";
import {MockERC20, MockERC721, MockERC1155} from "../TokenHelpers.sol";

interface IMockBool {
    function getBool(address _address) external view returns (bool);
}

contract MockBool {
    function getBool(address _address) public view returns (bool) {
        return true;
    }
}

contract ChannelTest is Test {
    address nick = 0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C;
    address targetChannel = makeAddr("targetChannel");
    Logic logicImpl;

    MockERC20 erc20Token;
    MockERC721 erc721Token;
    MockERC1155 erc1155Token;
    MockBool mockBool;

    function setUp() public {
        logicImpl = new Logic(address(this));

        /// approve some sample logic

        logicImpl.approveLogic(IERC20.balanceOf.selector, 0);
        logicImpl.approveLogic(IERC1155.balanceOf.selector, 0);
        logicImpl.approveLogic(IMockBool.getBool.selector, 0);

        erc20Token = new MockERC20("testERC20", "TEST1");
        erc721Token = new MockERC721("testERC721", "TEST2");
        erc1155Token = new MockERC1155("testERC1155");
        mockBool = new MockBool();
    }

    function test_creatorLogic_erc20Rule() external {
        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        bytes[] memory operators = new bytes[](1);
        bytes[] memory literalOperands = new bytes[](1);

        targets[0] = address(erc20Token);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode(address(0));
        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(uint256(3 * 10 ** 18));

        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(abi.encode(targets, signatures, datas, operators, literalOperands));

        bool result1 = logicImpl.isCreatorApproved(nick);
        assert(result1 == false);

        erc20Token.mint(nick, 4 * 10 ** 18);

        bool result2 = logicImpl.isCreatorApproved(nick);
        assert(result2 == true);
        vm.stopPrank();
    }

    function test_creatorLogic_booleanRule() external {
        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        bytes[] memory operators = new bytes[](1);
        bytes[] memory literalOperands = new bytes[](1);

        targets[0] = address(mockBool);
        signatures[0] = IMockBool.getBool.selector;
        datas[0] = abi.encode(address(0));
        operators[0] = abi.encodePacked("==");
        literalOperands[0] = abi.encode(1);

        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(abi.encode(targets, signatures, datas, operators, literalOperands));

        bool result = logicImpl.isCreatorApproved(nick);
        assert(result == true);
        vm.stopPrank();
    }

    function test_creatorLogic_erc721Rule() external {
        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        bytes[] memory operators = new bytes[](1);
        bytes[] memory literalOperands = new bytes[](1);

        targets[0] = address(erc721Token);
        signatures[0] = IERC721.balanceOf.selector;
        datas[0] = abi.encode(address(0));
        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(uint256(0));

        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(abi.encode(targets, signatures, datas, operators, literalOperands));

        bool result1 = logicImpl.isCreatorApproved(nick);
        assert(result1 == false);

        erc721Token.mint(nick, 1);

        bool result2 = logicImpl.isCreatorApproved(nick);
        assert(result2 == true);
        vm.stopPrank();
    }

    function test_creatorLogic_erc1155Rule() external {
        address[] memory targets = new address[](1);
        bytes4[] memory signatures = new bytes4[](1);
        bytes[] memory datas = new bytes[](1);
        bytes[] memory operators = new bytes[](1);
        bytes[] memory literalOperands = new bytes[](1);

        targets[0] = address(erc1155Token);
        signatures[0] = IERC1155.balanceOf.selector;
        datas[0] = abi.encode(address(0), 1);
        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(uint256(0));

        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(abi.encode(targets, signatures, datas, operators, literalOperands));

        bool result1 = logicImpl.isCreatorApproved(nick);
        assert(result1 == false);

        erc1155Token.mint(nick, 1, 1, "");

        bool result2 = logicImpl.isCreatorApproved(nick);
        assert(result2 == true);
        vm.stopPrank();
    }

    function test_creatorLogic_multiRule() external {
        address[] memory targets = new address[](3);
        bytes4[] memory signatures = new bytes4[](3);
        bytes[] memory datas = new bytes[](3);
        bytes[] memory operators = new bytes[](3);
        bytes[] memory literalOperands = new bytes[](3);

        targets[0] = address(erc20Token);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode(address(0));
        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(uint256(3 * 10 ** 18));

        targets[1] = address(erc721Token);
        signatures[1] = IERC721.balanceOf.selector;
        datas[1] = abi.encode(address(0));
        operators[1] = abi.encodePacked(">");
        literalOperands[1] = abi.encode(uint256(0));

        targets[2] = address(erc1155Token);
        signatures[2] = IERC1155.balanceOf.selector;
        datas[2] = abi.encode(address(0), 1);
        operators[2] = abi.encodePacked(">");
        literalOperands[2] = abi.encode(uint256(0));

        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(abi.encode(targets, signatures, datas, operators, literalOperands));

        bool result1 = logicImpl.isCreatorApproved(nick);
        assert(result1 == false);

        erc20Token.mint(nick, 4 * 10 ** 18);

        bool result2 = logicImpl.isCreatorApproved(nick);
        assert(result2 == true);

        vm.stopPrank();
    }

    function test_minterLogic_multiRule() external {
        address[] memory targets = new address[](3);
        bytes4[] memory signatures = new bytes4[](3);
        bytes[] memory datas = new bytes[](3);
        bytes[] memory operators = new bytes[](3);
        bytes[] memory literalOperands = new bytes[](3);

        targets[0] = address(erc20Token);
        signatures[0] = IERC20.balanceOf.selector;
        datas[0] = abi.encode(address(0));
        operators[0] = abi.encodePacked(">");
        literalOperands[0] = abi.encode(uint256(3 * 10 ** 18));

        targets[1] = address(erc721Token);
        signatures[1] = IERC721.balanceOf.selector;
        datas[1] = abi.encode(address(0));
        operators[1] = abi.encodePacked(">");
        literalOperands[1] = abi.encode(uint256(0));

        targets[2] = address(erc1155Token);
        signatures[2] = IERC1155.balanceOf.selector;
        datas[2] = abi.encode(address(0), 1);
        operators[2] = abi.encodePacked(">");
        literalOperands[2] = abi.encode(uint256(0));

        vm.startPrank(targetChannel);
        logicImpl.setMinterLogic(abi.encode(targets, signatures, datas, operators, literalOperands));

        bool result1 = logicImpl.isMinterApproved(nick);
        assert(result1 == false);

        erc20Token.mint(nick, 4 * 10 ** 18);

        bool result2 = logicImpl.isMinterApproved(nick);
        assert(result2 == true);

        vm.stopPrank();
    }

    function test_emptyLogic() public {
        vm.startPrank(targetChannel);
        logicImpl.setCreatorLogic(abi.encode(new address[](0), new bytes4[](0), new bytes[](0), new bytes[](0), new bytes[](0)));
        bool result = logicImpl.isCreatorApproved(nick);
        assert(result == true);
        vm.stopPrank();
    }

    function test_approveLogic_unauthorized() public {
        vm.startPrank(nick);
        vm.expectRevert();
        logicImpl.approveLogic(IERC20.balanceOf.selector, 0);
        vm.stopPrank();
    }

    function test_transferOwnership() public {
        logicImpl.transferOwnership(nick);
        assertEq(logicImpl.owner(), nick);
    }
}
