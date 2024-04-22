// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {console} from "forge-std/Test.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

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

    function approveLogic(
        bytes4 signature,
        uint256 calldataAddressPosition
    ) external;

    function setCreatorLogic(address channel, bytes memory data) external;

    function setMinterLogic(address channel, bytes memory data) external;

    function isCreatorApproved(
        address channel,
        address user
    ) external view returns (bool);

    function isMinterApproved(
        address channel,
        address user
    ) external view returns (bool);
}

contract Logic is ILogic {
    mapping(address => InteractionLogic) internal creatorLogic;
    mapping(address => InteractionLogic) internal minterLogic;
    mapping(bytes4 => ApprovedSignature) approvedSignatures;

    /// todo only owner
    function approveLogic(
        bytes4 signature,
        uint256 calldataAddressPosition
    ) external {
        approvedSignatures[signature] = ApprovedSignature(
            true,
            calldataAddressPosition
        );
    }

    function setCreatorLogic(address channel, bytes memory data) external {
        (
            address[] memory targets,
            bytes4[] memory signatures,
            bytes[] memory datas,
            bytes[] memory operators,
            bytes[] memory literalOperands
        ) = abi.decode(data, (address[], bytes4[], bytes[], bytes[], bytes[]));

        validateSignatures(signatures);
        validateLogic(targets, signatures, datas, operators, literalOperands);

        creatorLogic[channel] = InteractionLogic(
            targets,
            signatures,
            datas,
            operators,
            literalOperands
        );
    }

    function setMinterLogic(address channel, bytes memory data) external {
        (
            address[] memory targets,
            bytes4[] memory signatures,
            bytes[] memory datas,
            bytes[] memory operators,
            bytes[] memory literalOperands
        ) = abi.decode(data, (address[], bytes4[], bytes[], bytes[], bytes[]));

        validateSignatures(signatures);
        validateLogic(targets, signatures, datas, operators, literalOperands);

        minterLogic[channel] = InteractionLogic(
            targets,
            signatures,
            datas,
            operators,
            literalOperands
        );
    }

    function isCreatorApproved(
        address channel,
        address user
    ) external view returns (bool) {
        return loopAndExecuteLogic(creatorLogic[channel], user);
    }

    function isMinterApproved(
        address channel,
        address user
    ) external view returns (bool) {
        return loopAndExecuteLogic(minterLogic[channel], user);
    }

    function validateLogic(
        address[] memory targets,
        bytes4[] memory signatures,
        bytes[] memory datas,
        bytes[] memory operators,
        bytes[] memory literalOperands
    ) internal pure {
        require(
            targets.length == signatures.length &&
                signatures.length == datas.length &&
                datas.length == operators.length &&
                operators.length == literalOperands.length,
            "Logic field lengths do not match"
        );
    }

    function validateSignatures(bytes4[] memory signatures) internal view {
        for (uint256 i = 0; i < signatures.length; i++) {
            require(
                approvedSignatures[signatures[i]].approved,
                "Signature not approved"
            );
        }
    }

    function loopAndExecuteLogic(
        InteractionLogic storage logic,
        address user
    ) internal view returns (bool) {
        for (uint i = 0; i < logic.targets.length; i++) {
            bytes memory adjustedCalldata = adjustCalldata(
                logic.datas[i],
                approvedSignatures[logic.signatures[i]].calldataAddressPosition,
                user
            );

            (bool success, bytes memory executionResult) = executeLogic(
                logic.targets[i],
                logic.signatures[i],
                adjustedCalldata
            );

            bool result = applyOperator(
                logic.operators[i],
                executionResult,
                logic.literalOperands[i]
            );
            if (result) return true;
        }
        return false;
    }

    function adjustCalldata(
        bytes memory data,
        uint256 position,
        address addr
    ) internal view returns (bytes memory) {
        require(data.length >= (position * 32) + 32, "Data out of bounds");

        uint256 addrIndex = 32 + (position * 32);

        assembly {
            mstore(add(data, addrIndex), addr)
        }

        return data;
    }

    function executeLogic(
        address target,
        bytes4 signature,
        bytes memory data
    ) internal view returns (bool, bytes memory) {
        return target.staticcall(abi.encodePacked(signature, data));
    }

    function applyOperator(
        bytes memory operator,
        bytes memory executionResult,
        bytes memory literalOperand
    ) internal view returns (bool) {
        bytes32 operatorHash = keccak256(operator);
        uint expectedValue = abi.decode(literalOperand, (uint));
        if (operatorHash == keccak256(abi.encodePacked(">"))) {
            return abi.decode(executionResult, (uint)) > expectedValue;
        } else if (operatorHash == keccak256(abi.encodePacked("<"))) {
            return abi.decode(executionResult, (uint)) < expectedValue;
        } else if (operatorHash == keccak256(abi.encodePacked("=="))) {
            return abi.decode(executionResult, (uint)) == expectedValue;
        }

        return false;
    }

    function applyVerifier(
        uint result,
        bytes memory verifier
    ) internal pure returns (bool) {
        (string memory operator, uint expectedValue) = abi.decode(
            verifier,
            (string, uint)
        );

        bytes32 operatorHash = keccak256(abi.encodePacked(operator));

        if (operatorHash == keccak256(abi.encodePacked(">"))) {
            return result > expectedValue;
        } else if (operatorHash == keccak256(abi.encodePacked("<"))) {
            return result < expectedValue;
        } else if (operatorHash == keccak256(abi.encodePacked("=="))) {
            return result == expectedValue;
        }

        return false;
    }
}
