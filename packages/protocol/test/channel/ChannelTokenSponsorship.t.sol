// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";
import { ChannelStorage } from "../../src/channel/ChannelStorage.sol";
import { CustomFees } from "../../src/fees/CustomFees.sol";
import { IFees } from "../../src/interfaces/IFees.sol";
import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";
import { DeferredTokenAuthorization } from "../../src/utils/DeferredTokenAuthorization.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";
import { ChannelHarness } from "../utils/ChannelHarness.t.sol";
import { SigUtils } from "../utils/SigUtils.t.sol";

import { MockERC20 } from "../utils/TokenHelpers.t.sol";
import { WETH } from "../utils/WETH.t.sol";
import { Test, console } from "forge-std/Test.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { ERC1271 } from "solady/accounts/ERC1271.sol";

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

    struct SignatureWrapper {
        /// @dev The index of the owner that signed, see `MultiOwnable.ownerAtIndex`
        uint256 ownerIndex;
        /// @dev If `MultiOwnable.ownerAtIndex` is an Ethereum address, this should be `abi.encodePacked(r, s, v)`
        ///      If `MultiOwnable.ownerAtIndex` is a public key, this should be `abi.encode(WebAuthnAuth)`.
        bytes signatureData;
    }

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
            "https://example.com/api/token/0", "my contract", admin, new address[](0), setupActions, abi.encode(100)
        );
    }

    function createSampleFees(uint256 ethMintPrice, uint256 erc20MintPrice) internal returns (bytes memory) {
        return abi.encode(
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

    // function test_channelSponsorship_sponsorWithERC20() external {
    //   uint256 ethMintPrice = 0.000777 ether;
    //   uint256 erc20MintPrice = 1_000_000;

    //   initializeChannelWithSetupActions(
    //     encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
    //     new bytes(0)
    //   );

    //   vm.startPrank(minter);

    //   erc20Token.mint(minter, 1_000_000);
    //   erc20Token.approve(address(channelImpl), 1_000_000);

    //   DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
    //     .DeferredTokenPermission(
    //       "https://transmissions.network/nft/1",
    //       1000,
    //       block.timestamp + 10,
    //       stringToBytes32("abc")
    //     );

    //   bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

    //   (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

    //   channelImpl.sponsorWithERC20(deferredToken, author, v, r, s, minter, 1, referral, "");

    //   vm.stopPrank();

    //   /// check token creation state

    //   assertEq(channelImpl.getToken(1).uri, "https://transmissions.network/nft/1");
    //   assertEq(channelImpl.getToken(1).maxSupply, 1000);

    //   /// check mint reward state

    //   assertEq(erc20Token.balanceOf(author), (1_000_000 * 60) / 100); // 60%
    //   assertEq(erc20Token.balanceOf(channelTreasury), (1_000_000 * 10) / 100); // 10%
    //   assertEq(erc20Token.balanceOf(uplinkRewardsAddr), (1_000_000 * 10) / 100); // 10%
    //   assertEq(erc20Token.balanceOf(referral), (1_000_000 * 10) / 100); // 10%
    //   assertEq(erc20Token.balanceOf(minter), (1_000_000 * 10) / 100); // 10%
    // }

    function test_channelSponsorship_EOASigner() external {
        uint256 ethMintPrice = 0.000777 ether;
        uint256 erc20MintPrice = 1_000_000;

        initializeChannelWithSetupActions(
            encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)), new bytes(0)
        );

        vm.deal(minter, ethMintPrice);

        vm.startPrank(minter);

        DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
            .DeferredTokenPermission(
            "https://transmissions.network/nft/1", 1000, block.timestamp + 10, stringToBytes32("abc")
        );

        bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

        bytes memory signature = abi.encodePacked(r, s, v);

        channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken, author, signature, minter, 1, referral, "");
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

    function test_channelSponsorship_PasskeySigner() external {
        uint256 ethMintPrice = 0.000777 ether;
        uint256 erc20MintPrice = 1_000_000;

        initializeChannelWithSetupActions(
            encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)), new bytes(0)
        );

        vm.deal(minter, ethMintPrice);

        vm.startPrank(minter);

        DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
            .DeferredTokenPermission(
            "https://transmissions.network/nft/1", 1000, block.timestamp + 10, stringToBytes32("abc")
        );

        bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

        // uint256 signerPrivateKey = 0xa11ce;
        // address signer = vm.addr(signerPrivateKey);
        // bytes[] owners;
        // uint256 passkeyPrivateKey = uint256(0x03d99692017473e2d631945a812607b23269d85721e0f370b8d3e7d29a874fd2);

        // bytes32 hash = 0x15fa6f8c855db1dccbb8a42eef3a7b83f11d29758e84aed37312527165d5eec5;
        // bytes32 challenge = replaySafeHash(hash);
        // WebAuthnInfo memory webAuthn = Utils.getWebAuthnStruct(challenge);

        // (bytes32 r, bytes32 s) = vm.signP256(passkeyPrivateKey, webAuthn.messageHash);
        // s = bytes32(Utils.normalizeS(uint256(s)));
        // bytes memory sig = abi.encode(
        //     CoinbaseSmartWallet.SignatureWrapper({
        //         ownerIndex: 1,
        //         signatureData: abi.encode(
        //             WebAuthn.WebAuthnAuth({
        //                 authenticatorData: webAuthn.authenticatorData,
        //                 clientDataJSON: webAuthn.clientDataJSON,
        //                 typeIndex: 1,
        //                 challengeIndex: 23,
        //                 r: uint256(r),
        //                 s: uint256(s)
        //             })
        //         )
        //     })
        // );

        // (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

        // bytes memory signature = abi.encodePacked(r, s, v);

        address passkeyAuthor = 0xCd89C020F20b18693632249cE9776Fe3DFf3F281;

        bytes memory signature =
            hex"0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000260000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000c0000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000170000000000000000000000000000000000000000000000000000000000000001f6b8c7ef657b85c602861a7eebf3dbc9baeb029e2b13f05968f30179a7a6c95355b0597e1ad423118572c44059bd910c7c8254516240e56a8be13451311028650000000000000000000000000000000000000000000000000000000000000025f198086b2db17256731bc456673b96bcef23f51d1fbacdd7c4379ef65465572f1d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f77b2274797065223a22776562617574686e2e676574222c226368616c6c656e6765223a22726c4e48776a354d316e50477079534e444650356a38785f73306f3972562d38646476644c524966517367222c226f726967696e223a2268747470733a2f2f6b6579732e636f696e626173652e636f6d222c2263726f73734f726967696e223a66616c73652c226f746865725f6b6579735f63616e5f62655f61646465645f68657265223a22646f206e6f7420636f6d7061726520636c69656e74446174614a534f4e20616761696e737420612074656d706c6174652e205365652068747470733a2f2f676f6f2e676c2f796162506578227d000000000000000000";

        SignatureWrapper memory sigWrapper = abi.decode(signature, (SignatureWrapper));

        channelImpl.sponsorWithETH{ value: 0.000777 ether }(
            deferredToken, passkeyAuthor, sigWrapper.signatureData, minter, 1, referral, ""
        );
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

    // function test_channelSponsorship_allowNonLinearExecution() public {
    //   uint256 ethMintPrice = 0.000777 ether;
    //   uint256 erc20MintPrice = 1_000_000;

    //   initializeChannelWithSetupActions(
    //     encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
    //     new bytes(0)
    //   );

    //   vm.deal(minter, ethMintPrice * 2);

    //   vm.startPrank(minter);

    //   DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken1 = DeferredTokenAuthorization
    //     .DeferredTokenPermission(
    //       "https://transmissions.network/nft/1",
    //       1000,
    //       block.timestamp + 10,
    //       stringToBytes32("abc")
    //     );

    //   bytes32 digest1 = sigUtils.getTypedDataHash(deferredToken1);

    //   (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(authorPrivateKey, digest1);

    //   DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken2 = DeferredTokenAuthorization
    //     .DeferredTokenPermission(
    //       "https://transmissions.network/nft/1",
    //       10_001,
    //       block.timestamp + 10,
    //       stringToBytes32("xyz")
    //     );

    //   bytes32 digest2 = sigUtils.getTypedDataHash(deferredToken2);

    //   (uint8 v2, bytes32 r2, bytes32 s2) = vm.sign(authorPrivateKey, digest2);

    //   channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken2, author, v2, r2, s2, minter, 1, referral,
    // "");

    //   channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken1, author, v1, r1, s1, minter, 1, referral,
    // "");
    //   vm.stopPrank();
    // }

    // function test_channelSponsorship_revertOnUsedSignature() public {
    //   uint256 ethMintPrice = 0.000777 ether;
    //   uint256 erc20MintPrice = 1_000_000;

    //   initializeChannelWithSetupActions(
    //     encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
    //     new bytes(0)
    //   );

    //   vm.deal(minter, ethMintPrice);

    //   vm.startPrank(minter);

    //   DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
    //     .DeferredTokenPermission(
    //       "https://transmissions.network/nft/1",
    //       1000,
    //       block.timestamp + 10,
    //       stringToBytes32("abc")
    //     );

    //   bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

    //   (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

    //   channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken, author, v, r, s, minter, 1, referral, "");

    //   vm.expectRevert();
    //   channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken, author, v, r, s, minter, 1, referral, "");
    //   vm.stopPrank();
    // }

    // function test_channelSponsorship_revertOnExpiredSignature() public {
    //   uint256 ethMintPrice = 0.000777 ether;
    //   uint256 erc20MintPrice = 1_000_000;

    //   initializeChannelWithSetupActions(
    //     encodeFeesWithSelector(createSampleFees(ethMintPrice, erc20MintPrice)),
    //     new bytes(0)
    //   );

    //   vm.deal(minter, ethMintPrice);

    //   vm.startPrank(minter);

    //   DeferredTokenAuthorization.DeferredTokenPermission memory deferredToken = DeferredTokenAuthorization
    //     .DeferredTokenPermission(
    //       "https://transmissions.network/nft/1",
    //       1000,
    //       block.timestamp + 10,
    //       stringToBytes32("abc")
    //     );

    //   bytes32 digest = sigUtils.getTypedDataHash(deferredToken);

    //   (uint8 v, bytes32 r, bytes32 s) = vm.sign(authorPrivateKey, digest);

    //   vm.warp(block.timestamp + 20);
    //   vm.expectRevert();
    //   channelImpl.sponsorWithETH{ value: 0.000777 ether }(deferredToken, author, v, r, s, minter, 1, referral, "");
    //   vm.stopPrank();
    // }
}
