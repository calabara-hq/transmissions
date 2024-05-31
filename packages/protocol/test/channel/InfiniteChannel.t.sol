// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Test, console } from "forge-std/Test.sol";

import { InfiniteChannel } from "../../src/channel/transport/InfiniteChannel.sol";

import { CustomFees } from "../../src/fees/CustomFees.sol";
import { Logic } from "../../src/logic/Logic.sol";

import { IFees } from "../../src/interfaces/IFees.sol";
import { ILogic } from "../../src/interfaces/ILogic.sol";

import { IUpgradePath, UpgradePath } from "../../src/utils/UpgradePath.sol";
import { MockERC1155, MockERC20, MockERC721 } from "../utils/TokenHelpers.t.sol";
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
    address channelTreasury = makeAddr("channel treasury");
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
    }

    function test_infChannel_initializeWithProxy() external {
        InfiniteChannel newChannelImpl = new InfiniteChannel(address(upgradePath), address(0));
        InfiniteChannel sampleChannel = InfiniteChannel(payable(address(new InfiniteUplink1155(address(channelImpl)))));
        sampleChannel.initialize(
            "https://example.com/api/token/0", nick, new address[](0), new bytes[](0), abi.encode(100)
        );
        assertEq("https://example.com/api/token/0", sampleChannel.getToken(0).uri);
        assertEq(0, sampleChannel.getToken(0).maxSupply);
        assertEq(0, sampleChannel.getToken(0).totalMinted);
    }

    function test_infChannel_versioning() external {
        assertEq("1.0.0", targetChannel.contractVersion());
        assertEq("Infinite Channel", targetChannel.contractName());
        assertEq(targetChannel.contractURI(), "https://github.com/calabara-hq/transmissions/packages/protocol");
    }

    function test_infChannel_revertOnInvalidTimingConfig() external {
        vm.expectRevert();
        targetChannel.initialize(
            "https://example.com/api/token/0", nick, new address[](0), new bytes[](0), abi.encode(0)
        );
    }

    function test_infChannel_revertOnSaleEnd() external {
        targetChannel.initialize(
            "https://example.com/api/token/0", nick, new address[](0), new bytes[](0), abi.encode(1)
        );

        targetChannel.createToken("test", nick, 100);

        vm.warp(block.timestamp + 10);

        vm.expectRevert();
        targetChannel.mint(nick, 1, 1, address(0), "");
    }
}
