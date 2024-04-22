// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {console2} from "forge-std/Test.sol";
import {ChannelFactory} from "../../src/factory/ChannelFactoryImpl.sol";
import {Channel} from "../../src/channel/ChannelImpl.sol";
import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {Uplink1155} from "../../src/proxies/Uplink1155.sol";
import {IFees} from "../../src/fees/IFees.sol";
import {DynamicFees} from "../../src/fees/DynamicFees.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ILogic, Logic} from "../../src/logic/Logic.sol";

contract ChannelTest is Test {
    address nick = makeAddr("nick");
    address uplink = makeAddr("uplink");
    address sampleAdmin1 = makeAddr("sampleAdmin1");
    address sampleAdmin2 = makeAddr("sampleAdmin2");
    Channel channelImpl;
    Channel targetChannel;
    IFees dynamicFeesImpl;
    ILogic logicImpl;

    function setUp() public {
        channelImpl = new Channel(uplink);
        targetChannel = Channel(
            payable(address(new Uplink1155(address(channelImpl))))
        );
        dynamicFeesImpl = new DynamicFees();
        logicImpl = new Logic();
        logicImpl.approveLogic(IERC20.balanceOf.selector, 0);
    }

    function test_initialize() external {
        address[] memory channelManagers = new address[](0);
        //  targetChannel.initialize("https://example.com/api/token/0", nick, channelManagers, new bytes[](0));
        // console.log("Channel uri:", targetChannel.uri());
    }

    function test_managers_callerNotAdminAfterInitialization() external {
        address[] memory channelManagers = new address[](1);
        channelManagers[0] = sampleAdmin1;

        targetChannel.initialize(
            "https://example.com/api/token/0",
            nick,
            channelManagers,
            new bytes[](0)
        );

        // check managers after initialization
        assertTrue(targetChannel.isManager(sampleAdmin1));
        assertTrue(targetChannel.isManager(nick));
        assertFalse(targetChannel.isManager(sampleAdmin2));
        // ensure the initializer is no longer a manager
        assertFalse(targetChannel.isManager(address(this)));
    }

    function test_managers_shouldRevertIfCallerHasManagerRole() external {
        address[] memory channelManagers = new address[](1);
        channelManagers[0] = sampleAdmin1;

        targetChannel.initialize(
            "https://example.com/api/token/0",
            nick,
            channelManagers,
            new bytes[](0)
        );

        // verify that a manager cannot revoke another manager
        vm.startPrank(sampleAdmin1);
        assertTrue(targetChannel.isManager(sampleAdmin1));
        vm.expectRevert();
        targetChannel.revokeManager(sampleAdmin2);
        assertTrue(targetChannel.isManager(sampleAdmin1));
        vm.stopPrank();

        // verify that a manager cannot grant another manager
        // vm.expectRevert();
        // vm.startPrank(sampleAdmin2);
        // targetChannel.revokeManager(sampleAdmin1);
        // vm.stopPrank();
    }

    function test_managers_revokeManagerRoleWithAdminCaller() external {
        address[] memory channelManagers = new address[](1);
        channelManagers[0] = sampleAdmin1;

        targetChannel.initialize(
            "https://example.com/api/token/0",
            nick,
            channelManagers,
            new bytes[](0)
        );

        // verify that the admin can revoke another manager
        vm.startPrank(nick);
        assertTrue(targetChannel.isManager(sampleAdmin1));
        targetChannel.revokeManager(sampleAdmin1);
        assertFalse(targetChannel.isManager(sampleAdmin1));
        vm.stopPrank();
    }

    function test_initialize_channelToken() external {
        targetChannel.initialize(
            "https://example.com/api/token/0",
            nick,
            new address[](0),
            new bytes[](0)
        );

        // ensure channel token is initialized properly
        assertEq(
            "https://example.com/api/token/0",
            targetChannel.getTokenInfo(0).uri
        );
        assertEq(0, targetChannel.getTokenInfo(0).maxSupply);
        assertEq(0, targetChannel.getTokenInfo(0).totalMinted);
    }

    function test_initializeWithSetupActions() external {
        bytes[] memory setupActions = new bytes[](2);
        bytes memory feeArgs = abi.encode(
            address(0),
            11100000000000000,
            11100000000000000,
            33300000000000000,
            11100000000000000,
            11100000000000000
        );
        setupActions[0] = abi.encodeWithSelector(
            Channel.setChannelFeeConfig.selector,
            dynamicFeesImpl,
            feeArgs
        );

        /// creator logic

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

        setupActions[1] = abi.encodeWithSelector(
            Channel.setCreatorLogic.selector,
            logicImpl,
            abi.encode(targets, signatures, datas, operators, literalOperands)
        );

        targetChannel.initialize(
            "https://example.com/api/token/0",
            nick,
            new address[](0),
            setupActions
        );

        assertEq(targetChannel.mintPrice(), 77700000000000000);

    }

    function test_initializeWithSetupActions_createInitialToken() external {
        //     bytes[] memory setupActions = new bytes[](2);
        //     bytes memory feeArgs = abi.encode(
        //         address(0),
        //         11100000000000000,
        //         11100000000000000,
        //         33300000000000000,
        //         11100000000000000,
        //         11100000000000000
        //     );
        //     setupActions[0] = abi.encodeWithSelector(
        //         Channel.setChannelFeeConfig.selector,
        //         dynamicFeesImpl,
        //         feeArgs
        //     );
        //     setupActions[1] = abi.encodeWithSelector(
        //         Channel.createToken.selector,
        //         "https://example.com/api/token/1", nick, 100, new bytes[](0)
        //     );
        //     targetChannel.initialize(
        //         "https://example.com/api/token/0",
        //         nick,
        //         new address[](0),
        //         setupActions
        //     );
        //     assertEq(
        //         "https://example.com/api/token/1",
        //         targetChannel.getTokenInfo(1).uri
        //     );
        //     assertEq(100, targetChannel.getTokenInfo(1).maxSupply);
        //     assertEq(0, targetChannel.getTokenInfo(1).totalMinted);
        // }
        //    function test_initializeWithSetupActions_setCreatorLogic() external {
        //     IERC20 sharkToken = IERC20(0x232AFcE9f1b3AAE7cb408e482E847250843DB931);
        //     bytes[] memory setupActions = new bytes[](2);
        //     bytes memory feeArgs = abi.encode(
        //         address(0),
        //         11100000000000000,
        //         11100000000000000,
        //         33300000000000000,
        //         11100000000000000,
        //         11100000000000000
        //     );
        //     setupActions[0] = abi.encodeWithSelector(
        //         Channel.setChannelFeeConfig.selector,
        //         dynamicFeesImpl,
        //         feeArgs
        //     );
        // bytes[] memory creatorLogic = new bytes[](1);
        // creatorLogic[0] = abi.encodeWithSelector(
        //     IERC20(0x232AFcE9f1b3AAE7cb408e482E847250843DB931).balanceOf.selector,
        //     0xedcC867bc8B5FEBd0459af17a6f134F41f422f0C
        // );
        // setupActions[1] = abi.encodeWithSelector(
        //     Channel.setTokenCreationLogic.selector,
        //     standardAuthImpl,
        //     creatorLogic
        // );
    }
}
