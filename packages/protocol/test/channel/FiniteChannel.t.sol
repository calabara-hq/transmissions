// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Channel } from "../../src/channel/Channel.sol";
import { FiniteChannel } from "../../src/channel/transport/FiniteChannel.sol";
import { IUpgradePath } from "../../src/interfaces/IUpgradePath.sol";

import { FiniteUplink1155 } from "../../src/proxies/FiniteUplink1155.sol";
import { UpgradePath } from "../../src/utils/UpgradePath.sol";

import { WETH } from "../utils/WETH.t.sol";
import { Test, console } from "forge-std/Test.sol";

struct FuzzedInputs {
    uint40 startRank;
    uint40 endRank;
    uint256 vote_a;
    uint256 vote_b;
    uint256 vote_c;
    uint256 vote_d;
    uint256 vote_e;
    uint256 target_sub_a;
    uint256 target_sub_b;
    uint256 target_sub_c;
    uint256 target_sub_d;
    uint256 target_sub_e;
}

contract FiniteChannelHarness is FiniteChannel {
    constructor(address _upgradePath, address _weth) FiniteChannel(_upgradePath, _weth) { }

    /// get the current ranked tokenIds
    /// used for testing
    function getRankedTokenIds() public view returns (uint256[] memory) {
        uint256[] memory winners = new uint256[](finiteChannelParams.rewards.ranks.length);

        bytes32 currentNodeKey = head;
        uint256 currentRankIndex = 0;
        uint256 counter = 1;

        while (currentNodeKey != 0x00 && currentRankIndex < finiteChannelParams.rewards.ranks.length) {
            Node memory currentNode = nodes[currentNodeKey];
            if (counter == finiteChannelParams.rewards.ranks[currentRankIndex]) {
                winners[currentRankIndex] = currentNode.tokenId;
                currentRankIndex++;
            }
            currentNodeKey = currentNode.next;
            counter++;
        }

        return winners;
    }

    /// call the internal function to get the ranked authors
    function getRankedAuthors() public view returns (address[] memory) {
        return _getWinners();
    }
}

contract FiniteChannelTest is Test {
    address nick = makeAddr("nick");
    address admin = makeAddr("admin");
    address channelTreasury = makeAddr("channel treasury");
    IUpgradePath upgradePath;
    FiniteChannelHarness channelImpl;
    FiniteChannelHarness targetChannel;

    error Unauthorized();

    function setUp() public {
        upgradePath = new UpgradePath();
        upgradePath.initialize(admin);
        channelImpl = new FiniteChannelHarness(address(upgradePath), address(new WETH()));
        targetChannel = FiniteChannelHarness(payable(address(new FiniteUplink1155(address(channelImpl)))));
    }

    function createChannelTestCase(
        FuzzedInputs memory inputs,
        address rewardToken
    )
        internal
        returns (uint40[] memory _ranks, uint256[] memory _allocations, uint256 _totalAllocation)
    {
        uint40 startRank = uint40(bound(inputs.startRank, 1, 10));
        uint40 endRank = uint40(bound(inputs.endRank, 11, 100));

        uint256 vote_a = bound(inputs.vote_a, 1, 99);
        uint256 vote_b = bound(inputs.vote_b, 1, 99);
        uint256 vote_c = bound(inputs.vote_c, 1, 99);
        uint256 vote_d = bound(inputs.vote_d, 1, 99);
        uint256 vote_e = bound(inputs.vote_e, 1, 99);

        uint256 target_sub_a = bound(inputs.target_sub_a, 1, 10);
        uint256 target_sub_b = bound(inputs.target_sub_b, 1, 10);
        uint256 target_sub_c = bound(inputs.target_sub_c, 1, 10);
        uint256 target_sub_d = bound(inputs.target_sub_d, 1, 10);
        uint256 target_sub_e = bound(inputs.target_sub_e, 1, 10);

        uint8 numSubmissions = 10;

        _ranks = new uint40[](endRank - startRank + 1);
        _allocations = new uint256[](endRank - startRank + 1);
        uint8 counter = 0;
        _totalAllocation = 0;

        while (counter != endRank - startRank + 1) {
            _ranks[counter] = startRank + counter;
            _allocations[counter] = 1;
            _totalAllocation += 1;
            counter++;
        }

        targetChannel.initialize{ value: _totalAllocation }(
            "https://example.com/api/token/0",
            admin,
            new address[](0),
            new bytes[](0),
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: uint80(block.timestamp),
                    mintStart: uint80(block.timestamp + 1),
                    mintEnd: uint80(block.timestamp + 20),
                    userCreateLimit: UINT256_MAX,
                    userMintLimit: UINT256_MAX,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: _ranks,
                        allocations: _allocations,
                        totalAllocation: _totalAllocation,
                        token: rewardToken
                    })
                })
            )
        );

        for (uint8 i = 0; i < numSubmissions; i++) {
            address sampleCreator = vm.addr(i + 1);
            targetChannel.createToken("test", sampleCreator, 1000);
        }

        vm.warp(block.timestamp + 10);

        targetChannel.mint(nick, target_sub_a, vote_a, nick, "");
        targetChannel.mint(nick, target_sub_b, vote_b, nick, "");
        targetChannel.mint(nick, target_sub_c, vote_c, nick, "");
        targetChannel.mint(nick, target_sub_d, vote_d, nick, "");
        targetChannel.mint(nick, target_sub_e, vote_e, nick, "");
    }

    function test_finiteChannel_sortWinners(FuzzedInputs memory inputs) public {
        address rewardToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        createChannelTestCase(inputs, rewardToken);

        uint256[] memory winningTokenIds = targetChannel.getRankedTokenIds();

        /// @dev ensure the winningTokenIds are in order from highest to lowest totalMinted

        for (uint8 i = 0; i < winningTokenIds.length; i++) {
            console.log(winningTokenIds[i]);
            if (i != winningTokenIds.length - 1) {
                assertTrue(
                    targetChannel.getToken(winningTokenIds[i]).totalMinted
                        >= targetChannel.getToken(winningTokenIds[i + 1]).totalMinted
                );
            }
        }
    }

    function test_finiteChannel_settleDistributeRewards(FuzzedInputs memory inputs) public {
        address rewardToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        (uint40[] memory _ranks, uint256[] memory _allocations, uint256 _totalAllocation) =
            createChannelTestCase(inputs, rewardToken);

        vm.warp(block.timestamp + 20);
        targetChannel.settle();

        address[] memory winningAuthors = targetChannel.getRankedAuthors();

        uint256 totalDistributed = 0;
        bool isLeftovers = false;

        /// @dev ensure rewards were distributed correctly
        for (uint8 i = 0; i < winningAuthors.length; i++) {
            if (winningAuthors[i] != address(0)) {
                assertEq(winningAuthors[i].balance, _allocations[i]);
                totalDistributed += _allocations[i];
            } else {
                isLeftovers = true;
            }
        }

        if (isLeftovers) {
            /// @dev ensure the leftovers are in the contract and claimable by the admin
            assertEq(address(targetChannel).balance, _totalAllocation - totalDistributed);

            /// @dev attempt to withdraw the leftovers

            /// @dev ensure non admin / manager cannot initiate a withdrawal
            vm.expectRevert(Unauthorized.selector);
            targetChannel.withdrawRewards(nick, rewardToken, address(targetChannel).balance);

            vm.startPrank(admin);
            targetChannel.withdrawRewards(rewardToken, nick, address(targetChannel).balance);
            assertEq(nick.balance, _totalAllocation - totalDistributed);
            vm.stopPrank();
        }
    }

    function test_finiteChannel_settleRevertConditions(FuzzedInputs memory inputs) public {
        address rewardToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        createChannelTestCase(inputs, rewardToken);

        /// @dev ensure the settle function reverts if called before the mintEnd time
        vm.expectRevert(FiniteChannel.StillActive.selector);
        targetChannel.settle();

        /// @dev ensure the settle function reverts if it has already been called succesfully
        vm.warp(block.timestamp + 20);

        targetChannel.settle();

        vm.expectRevert(FiniteChannel.AlreadySettled.selector);
        targetChannel.settle();
    }

    function test_finiteChannel_transportCannotBeModifiedAfterInitialization(FuzzedInputs memory inputs) public {
        address rewardToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        createChannelTestCase(inputs, rewardToken);

        vm.expectRevert();
        targetChannel.setTransportConfig{ value: 1 }(
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: uint80(block.timestamp),
                    mintStart: uint80(block.timestamp + 1),
                    mintEnd: uint80(block.timestamp + 20),
                    userCreateLimit: UINT256_MAX,
                    userMintLimit: UINT256_MAX,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: new uint40[](1),
                        allocations: new uint256[](1),
                        totalAllocation: 1,
                        token: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
                    })
                })
            )
        );
    }

    function test_finiteChannel_sortWinnersGappedRanks() public {
        uint256 vote_a = 54;
        uint256 vote_b = 34;
        uint256 vote_c = 97;
        uint256 vote_d = 37;
        uint256 vote_e = 64;
        uint256 target_sub_a = 10;
        uint256 target_sub_b = 2;
        uint256 target_sub_c = 1;
        uint256 target_sub_d = 1;
        uint256 target_sub_e = 6;

        uint8 numSubmissions = 10;

        uint40[] memory _ranks = new uint40[](5);
        _ranks[0] = 2;
        _ranks[1] = 4;
        _ranks[2] = 5;
        _ranks[3] = 7;
        _ranks[4] = 10;

        uint256[] memory _allocations = new uint256[](_ranks.length);
        uint8 counter = 0;
        uint256 _totalAllocation = 0;

        for (uint8 i = 0; i < _ranks.length; i++) {
            _allocations[i] = 1;
            _totalAllocation += 1;
        }

        targetChannel.initialize{ value: _totalAllocation }(
            "https://example.com/api/token/0",
            admin,
            new address[](0),
            new bytes[](0),
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: uint80(block.timestamp),
                    mintStart: uint80(block.timestamp + 1),
                    mintEnd: uint80(block.timestamp + 20),
                    userCreateLimit: UINT256_MAX,
                    userMintLimit: UINT256_MAX,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: _ranks,
                        allocations: _allocations,
                        totalAllocation: _totalAllocation,
                        token: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
                    })
                })
            )
        );

        address sampleCreator = makeAddr("sampleCreator");

        for (uint8 i = 0; i < numSubmissions; i++) {
            targetChannel.createToken("test", sampleCreator, 1000);
        }

        vm.warp(block.timestamp + 10);

        targetChannel.mint(nick, target_sub_a, vote_a, nick, "");
        targetChannel.mint(nick, target_sub_b, vote_b, nick, "");
        targetChannel.mint(nick, target_sub_c, vote_c, nick, "");
        targetChannel.mint(nick, target_sub_d, vote_d, nick, "");
        targetChannel.mint(nick, target_sub_e, vote_e, nick, "");

        uint256[] memory winningTokenIds = targetChannel.getRankedTokenIds();

        // ranks 2 and 4 should be the winners
        // the rest should be 0
        assertEq(winningTokenIds[0], target_sub_e);
        assertEq(winningTokenIds[1], target_sub_b);
        assertEq(winningTokenIds[2], 0);
        assertEq(winningTokenIds[3], 0);
        assertEq(winningTokenIds[4], 0);
    }

    function test_finiteChannel_timingValidationOnSetParams(
        uint80 createStart,
        uint80 mintStart,
        uint80 mintEnd
    )
        public
    {
        uint40[] memory ranks = new uint40[](1);
        ranks[0] = 1;

        uint256[] memory allocations = new uint256[](1);
        allocations[0] = 1;

        if (createStart >= mintStart || mintStart >= mintEnd) vm.expectRevert();
        targetChannel.initialize{ value: 1 }(
            "https://example.com/api/token/0",
            admin,
            new address[](0),
            new bytes[](0),
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: createStart,
                    mintStart: mintStart,
                    mintEnd: mintEnd,
                    userCreateLimit: UINT256_MAX,
                    userMintLimit: UINT256_MAX,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: ranks,
                        allocations: allocations,
                        totalAllocation: 1,
                        token: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
                    })
                })
            )
        );
    }

    function test_finiteChannel_timingValidationOnSetParams(uint256 userCreateLimit, uint256 userMintLimit) public {
        uint40[] memory ranks = new uint40[](1);
        ranks[0] = 1;

        uint256[] memory allocations = new uint256[](1);
        allocations[0] = 1;

        if (userCreateLimit == 0 || userMintLimit == 0) vm.expectRevert();
        targetChannel.initialize{ value: 1 }(
            "https://example.com/api/token/0",
            admin,
            new address[](0),
            new bytes[](0),
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: uint80(block.timestamp + 10),
                    mintStart: uint80(block.timestamp + 20),
                    mintEnd: uint80(block.timestamp + 30),
                    userCreateLimit: userCreateLimit,
                    userMintLimit: userMintLimit,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: ranks,
                        allocations: allocations,
                        totalAllocation: 1,
                        token: 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
                    })
                })
            )
        );
    }

    function test_finiteChannel_timingValidationOnCreateToken(FuzzedInputs memory inputs) public {
        address rewardToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        uint40[] memory _ranks = new uint40[](1);
        _ranks[0] = 1;
        uint256[] memory _allocations = new uint256[](1);
        _allocations[0] = 1 ether;

        targetChannel.initialize{ value: 1 ether }(
            "https://example.com/api/token/0",
            admin,
            new address[](0),
            new bytes[](0),
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: uint80(block.timestamp + 10),
                    mintStart: uint80(block.timestamp + 20),
                    mintEnd: uint80(block.timestamp + 30),
                    userCreateLimit: UINT256_MAX,
                    userMintLimit: UINT256_MAX,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: _ranks,
                        allocations: _allocations,
                        totalAllocation: 1 ether,
                        token: rewardToken
                    })
                })
            )
        );

        vm.expectRevert(FiniteChannel.NotAcceptingCreations.selector);
        targetChannel.createToken("test", nick, 1000);

        vm.warp(block.timestamp + 10);
        targetChannel.createToken("test", nick, 1000);

        vm.warp(block.timestamp + 100);
        vm.expectRevert(FiniteChannel.NotAcceptingCreations.selector);
        targetChannel.createToken("test", nick, 1000);
    }

    function test_finiteChannel_timingValidationOnMintToken(FuzzedInputs memory inputs) public {
        address rewardToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        uint40[] memory _ranks = new uint40[](1);
        _ranks[0] = 1;
        uint256[] memory _allocations = new uint256[](1);
        _allocations[0] = 1 ether;

        targetChannel.initialize{ value: 1 ether }(
            "https://example.com/api/token/0",
            admin,
            new address[](0),
            new bytes[](0),
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: uint80(block.timestamp),
                    mintStart: uint80(block.timestamp + 10),
                    mintEnd: uint80(block.timestamp + 20),
                    userCreateLimit: UINT256_MAX,
                    userMintLimit: UINT256_MAX,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: _ranks,
                        allocations: _allocations,
                        totalAllocation: 1 ether,
                        token: rewardToken
                    })
                })
            )
        );

        targetChannel.createToken("test", nick, 1000);

        vm.expectRevert(FiniteChannel.NotAcceptingMints.selector);
        targetChannel.mint(nick, 1, 1, nick, "");

        vm.warp(block.timestamp + 10);
        targetChannel.mint(nick, 1, 1, nick, "");

        vm.warp(block.timestamp + 30);
        vm.expectRevert(FiniteChannel.NotAcceptingMints.selector);
        targetChannel.mint(nick, 1, 1, nick, "");
    }

    function test_finiteChannel_revertOnExceedInteractionLimit(FuzzedInputs memory inputs) public {
        address rewardToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

        uint40[] memory _ranks = new uint40[](1);
        _ranks[0] = 1;
        uint256[] memory _allocations = new uint256[](1);
        _allocations[0] = 1 ether;

        targetChannel.initialize{ value: 1 ether }(
            "https://example.com/api/token/0",
            admin,
            new address[](0),
            new bytes[](0),
            abi.encode(
                FiniteChannel.FiniteParams({
                    createStart: uint80(block.timestamp),
                    mintStart: uint80(block.timestamp + 10),
                    mintEnd: uint80(block.timestamp + 20),
                    userCreateLimit: 1,
                    userMintLimit: 1,
                    rewards: FiniteChannel.FiniteRewards({
                        ranks: _ranks,
                        allocations: _allocations,
                        totalAllocation: 1 ether,
                        token: rewardToken
                    })
                })
            )
        );

        targetChannel.createToken("test", nick, 1000);

        vm.expectRevert(FiniteChannel.InteractionLimitReached.selector);
        targetChannel.createToken("test", nick, 1000);

        vm.warp(block.timestamp + 10);
        targetChannel.mint(nick, 1, 1, nick, "");

        vm.expectRevert(FiniteChannel.InteractionLimitReached.selector);
        targetChannel.mint(nick, 1, 1, nick, "");
    }

    function test_finiteChannel_versioning() public {
        assertEq("1.0.0", targetChannel.contractVersion());
        assertEq("Finite Channel", targetChannel.contractName());
        assertEq(targetChannel.contractURI(), "https://github.com/calabara-hq/transmissions/packages/protocol");
    }
}
