// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ILogic {
    struct InteractionLogic {
        address[] targets;
        bytes4[] signatures;
        bytes[] datas;
        bytes[] operators;
        bytes[] literalOperands;
    }

    struct ApprovedSignature {
        bool approved;
        uint256 calldataAddressPosition;
    }

    error INVALID_SIGNATURE();

    event CreatorLogicSet(address indexed channel, InteractionLogic logic);
    event MinterLogicSet(address indexed channel, InteractionLogic logic);

    function approveLogic(bytes4 signature, uint256 calldataAddressPosition) external;

    function setCreatorLogic(bytes memory data) external;
    function setMinterLogic(bytes memory data) external;

    function isCreatorApproved(address user) external view returns (bool);
    function isMinterApproved(address user) external view returns (bool);

    error CallFailed();
}