// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IFiniteChannel } from "../../interfaces/IFiniteChannel.sol";

import { IVersionedContract } from "../../interfaces/IVersionedContract.sol";

import { Rewards } from "../../rewards/Rewards.sol";
import { Channel } from "../Channel.sol";
/**
 * @title Finite Channel
 * @author nick
 * @notice Finite channels allow token creation and minting for a fixed period.
 * @dev Rewards are defined on initialization, and distributed after the minting period ends.
 */

contract FiniteChannel is IFiniteChannel, Channel, IVersionedContract {
  /* -------------------------------------------------------------------------- */
  /*                                   ERRORS                                   */
  /* -------------------------------------------------------------------------- */

  error NotAcceptingCreations();
  error NotAcceptingMints();
  error InvalidTiming();
  error AlreadySettled();
  error StillActive();
  error InvalidRewards();

  /* -------------------------------------------------------------------------- */
  /*                                   EVENTS                                   */
  /* -------------------------------------------------------------------------- */

  event Settled(address indexed caller);

  /* -------------------------------------------------------------------------- */
  /*                                   STRUCTS                                  */
  /* -------------------------------------------------------------------------- */

  struct Node {
    bytes32 next;
    bytes32 prev;
    uint256 tokenId;
  }

  struct FiniteRewards {
    uint40[] ranks;
    uint256[] allocations;
    uint256 totalAllocation;
    address token;
  }

  struct FiniteParams {
    uint80 createStart;
    uint80 mintStart;
    uint80 mintEnd;
    FiniteRewards rewards;
  }

  /* -------------------------------------------------------------------------- */
  /*                                   STORAGE                                  */
  /* -------------------------------------------------------------------------- */

  bytes32 internal head;
  bytes32 internal tail;
  uint256 internal length;

  bool internal isSettled;

  mapping(bytes32 => Node) internal nodes;

  FiniteParams public finiteChannelParams;

  /* -------------------------------------------------------------------------- */
  /*                          CONSTRUCTOR & INITIALIZER                         */
  /* -------------------------------------------------------------------------- */

  constructor(address _upgradePath, address _weth) initializer Channel(_upgradePath, _weth) {}

  /* -------------------------------------------------------------------------- */
  /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
  /* -------------------------------------------------------------------------- */

  /**
   * @notice Settle the finite channel results and distribute rewards
   */
  function settle() external {
    if (isSettled) revert AlreadySettled();

    if (block.timestamp < finiteChannelParams.mintEnd) {
      revert StillActive();
    }

    address[] memory winners = _getWinners();
    Rewards.Split memory split = Rewards.Split({
      recipients: winners,
      allocations: finiteChannelParams.rewards.allocations,
      totalAllocation: finiteChannelParams.rewards.totalAllocation,
      token: finiteChannelParams.rewards.token
    });

    isSettled = true;

    _distributeEscrowSplit(split);

    emit Settled(msg.sender);
  }

  /**
   * @notice Withdraw rewards from escrow
   * @dev Withdraw is callable at any time. If the contest is ongoing, set the contest as settled so clients can
   * flag the contest as complete.
   */
  function withdrawRewards(address token, address to, uint256 amount) external onlyAdminOrManager {
    isSettled = true;
    _withdrawFromEscrow(token, to, amount);
  }

  /**
   * @notice Set the transport configuration for the finite channel
   * @param data encoded FiniteParams
   * @dev only callable during initialization
   */
  function setTransportConfig(bytes calldata data) public override onlyAdminOrManager onlyInitializing {
    FiniteParams memory _params = abi.decode(data, (FiniteParams));

    _validateTimingParameters(_params.createStart, _params.mintStart, _params.mintEnd);
    _validateRewardParameters(_params.rewards);

    finiteChannelParams = _params;
    _depositToEscrow(_params.rewards.token, _params.rewards.totalAllocation);
  }

  receive() external payable {}
  fallback() external payable {}

  /* -------------------------------------------------------------------------- */
  /*                             INTERNAL FUNCTIONS                             */
  /* -------------------------------------------------------------------------- */

  function _processIncoming(uint256 tokenId) internal {
    TokenConfig memory incomingToken = tokens[tokenId];
    bytes32 id = keccak256(abi.encode(tokenId));

    if (length == 0) {
      _insertBeginning(tokenId, id);
      return;
    }

    if (nodes[id].tokenId == tokenId) {
      _promoteNode(tokenId, id);
      return;
    }

    if (incomingToken.totalMinted >= tokens[nodes[head].tokenId].totalMinted) {
      _insertBeginning(tokenId, id);
      return;
    }

    bytes32 currentId = head;
    while (currentId != 0x00) {
      Node memory currentNode = nodes[currentId];
      if (incomingToken.totalMinted >= tokens[currentNode.tokenId].totalMinted) {
        _insertMiddle(tokenId, id, currentNode);
        return;
      }

      if (currentNode.next == 0x00) {
        _insertEnd(tokenId, id);
        return;
      }
      currentId = currentNode.next;
    }
  }

  function _insertBeginning(uint256 tokenId, bytes32 id) internal {
    Node memory toInsert = Node({ next: head, prev: 0x00, tokenId: tokenId });

    if (length == 0) {
      head = id;
      tail = id;
    } else {
      nodes[head].prev = id;
      head = id;
    }

    _setDLLStorage(id, toInsert);
    length++;
  }

  function _insertMiddle(uint256 tokenId, bytes32 id, Node memory currentNode) internal {
    bytes32 currentId = keccak256(abi.encode(currentNode.tokenId));
    Node memory toInsert = Node({ next: currentId, prev: currentNode.prev, tokenId: tokenId });

    if (currentNode.prev != 0x00) {
      nodes[currentNode.prev].next = id;
    } else {
      head = id;
    }

    nodes[currentId].prev = id;
    _setDLLStorage(id, toInsert);
    length++;
  }

  function _insertEnd(uint256 tokenId, bytes32 id) internal {
    Node memory toInsert = Node({ next: 0x00, prev: tail, tokenId: tokenId });

    if (tail == 0x00) {
      head = id;
      tail = id;
    } else {
      nodes[tail].next = id;
      tail = id;
    }

    _setDLLStorage(id, toInsert);
    length++;
  }

  function _promoteNode(uint256 tokenId, bytes32 promotedNodeKey) internal {
    /// @dev do nothing if node to promote is only node in DLL
    if (length == 1) return;

    Node memory promotedNode = nodes[promotedNodeKey];
    _removeNode(promotedNodeKey);

    bytes32 currentId = head;
    while (currentId != 0x00) {
      Node memory currentNode = nodes[currentId];
      if (tokens[promotedNode.tokenId].totalMinted >= tokens[currentNode.tokenId].totalMinted) {
        _insertMiddle(promotedNode.tokenId, promotedNodeKey, currentNode);
        return;
      }
      if (currentNode.next == 0x00) {
        _insertEnd(promotedNode.tokenId, promotedNodeKey);
        return;
      }
      currentId = currentNode.next;
    }
  }

  function _removeNode(bytes32 nodeKey) internal {
    Node memory node = nodes[nodeKey];

    if (node.prev != 0x00) {
      nodes[node.prev].next = node.next;
    } else {
      head = node.next;
    }

    if (node.next != 0x00) {
      nodes[node.next].prev = node.prev;
    } else {
      tail = node.prev;
    }

    delete nodes[nodeKey];
    length--;
  }

  function _setDLLStorage(bytes32 key, Node memory toInsert) internal {
    nodes[key] = toInsert;
  }

  function _getWinners() internal view returns (address[] memory) {
    address[] memory winners = new address[](finiteChannelParams.rewards.ranks.length);

    bytes32 currentNodeKey = head;
    uint256 currentRankIndex = 0;
    uint256 counter = 1;

    while (currentNodeKey != 0x00 && currentRankIndex < finiteChannelParams.rewards.ranks.length) {
      Node memory currentNode = nodes[currentNodeKey];
      if (counter == finiteChannelParams.rewards.ranks[currentRankIndex]) {
        winners[currentRankIndex] = tokens[currentNode.tokenId].author;
        currentRankIndex++;
      }
      currentNodeKey = currentNode.next;
      counter++;
    }

    return winners;
  }

  function _transportProcessNewToken(uint256 tokenId) internal override {
    if (isSettled) {
      revert AlreadySettled();
    }

    if (block.timestamp < finiteChannelParams.createStart || block.timestamp >= finiteChannelParams.mintStart) {
      revert NotAcceptingCreations();
    }
  }

  function _transportProcessMint(uint256 tokenId) internal override {
    if (isSettled) {
      revert AlreadySettled();
    }

    if (block.timestamp < finiteChannelParams.mintStart || block.timestamp >= finiteChannelParams.mintEnd) {
      revert NotAcceptingMints();
    }

    if (finiteChannelParams.rewards.ranks.length == 0) return;

    _processIncoming(tokenId);
  }

  function _validateTimingParameters(uint80 _createStart, uint80 _mintStart, uint80 _mintEnd) internal pure {
    if (_createStart >= _mintStart || _mintStart >= _mintEnd) {
      revert InvalidTiming();
    }
  }

  function _validateRewardParameters(FiniteRewards memory rewards) internal {
    if (rewards.ranks.length == 0 || rewards.ranks.length != rewards.allocations.length) revert InvalidRewards();

    uint256 _totalAllocation = 0;

    for (uint256 i = 0; i < rewards.allocations.length; i++) {
      _totalAllocation += rewards.allocations[i];

      /// @dev ensure ranks are in ascending order without duplicates

      if (i < rewards.allocations.length - 1 && rewards.ranks[i + 1] <= rewards.ranks[i]) {
        revert InvalidRewards();
      }
    }

    if (_totalAllocation == 0) revert InvalidRewards();

    if (rewards.totalAllocation != _totalAllocation) {
      revert InvalidRewards();
    }
  }

  /* -------------------------------------------------------------------------- */
  /*                                  VERSIONING                                */
  /* -------------------------------------------------------------------------- */

  function contractVersion() external pure returns (string memory) {
    return "1.0.0";
  }

  function codeRepository() external pure returns (string memory) {
    return "https://github.com/calabara-hq/transmissions/packages/protocol";
  }

  function contractName() external pure returns (string memory) {
    return "Finite Channel";
  }
}
