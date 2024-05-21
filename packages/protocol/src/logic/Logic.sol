// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ILogic } from "../interfaces/ILogic.sol";
import { IVersionedContract } from "../interfaces/IVersionedContract.sol";
import { Ownable } from "openzeppelin-contracts/access/Ownable.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";

contract Logic is ILogic, Ownable, IVersionedContract {
    mapping(address => InteractionLogic) internal creatorLogic;
    mapping(address => InteractionLogic) internal minterLogic;

    mapping(bytes4 => ApprovedSignature) approvedSignatures;

    constructor(address _initOwner) Ownable(_initOwner) { }

    /**
     * @notice Approve a signature for use in logic
     * @param signature function signature
     * @param calldataAddressPosition position of address in calldata
     */
    function approveLogic(bytes4 signature, uint256 calldataAddressPosition) external onlyOwner {
        approvedSignatures[signature] = ApprovedSignature(true, calldataAddressPosition);
    }

    function setCreatorLogic(bytes memory data) external {
        InteractionLogic memory logic = _constructInteractionLogic(data);
        if (logic.targets.length > 0) {
            // only set storage if logic is present
            creatorLogic[msg.sender] = logic;
        }
        emit CreatorLogicSet(msg.sender, logic);
    }

    function setMinterLogic(bytes memory data) external {
        InteractionLogic memory logic = _constructInteractionLogic(data);
        if (logic.targets.length > 0) {
            // only set storage if logic is present
            minterLogic[msg.sender] = logic;
        }
        emit MinterLogicSet(msg.sender, logic);
    }

    /**
     * @notice determine if a creator is approved to interact
     * @param user abi encoded representation of the logic
     * @return result boolean is user approved
     *
     */
    function isCreatorApproved(address user) external view returns (bool) {
        return _loopAndExecuteLogic(creatorLogic[msg.sender], user);
    }

    /**
     * @notice determine if a minter is approved to interact
     * @param user abi encoded representation of the logic
     * @return result boolean is user approved
     *
     */
    function isMinterApproved(address user) external view returns (bool) {
        return _loopAndExecuteLogic(minterLogic[msg.sender], user);
    }

    /**
     * @notice construct the interaction logic for a channel
     * @param data abi encoded representation of the logic
     * @return InteractionLogic the constructed logic
     */
    function _constructInteractionLogic(bytes memory data) internal view returns (InteractionLogic memory) {
        (
            address[] memory targets,
            bytes4[] memory signatures,
            bytes[] memory datas,
            bytes[] memory operators,
            bytes[] memory literalOperands
        ) = abi.decode(data, (address[], bytes4[], bytes[], bytes[], bytes[]));

        _validateSignatures(signatures);
        _validateLogic(targets, signatures, datas, operators, literalOperands);

        return InteractionLogic(targets, signatures, datas, operators, literalOperands);
    }

    /**
     * @notice internal helper function to make sure lengths of logic arrays match
     * @param targets array of target addresses
     * @param signatures array of function signatures
     * @param datas array of calldata
     * @param operators array of operators
     * @param literalOperands array of operands
     *
     */
    function _validateLogic(
        address[] memory targets,
        bytes4[] memory signatures,
        bytes[] memory datas,
        bytes[] memory operators,
        bytes[] memory literalOperands
    )
        internal
        pure
    {
        require(
            targets.length == signatures.length && signatures.length == datas.length && datas.length == operators.length
                && operators.length == literalOperands.length,
            "Logic field lengths do not match"
        );
    }

    /**
     * @notice internal function to check registry of valid signatures
     * @param signatures array of function signatures
     */
    function _validateSignatures(bytes4[] memory signatures) internal view {
        uint256 length = signatures.length;
        if (length > 0) {
            for (uint256 i; i < length; i++) {
                if (!approvedSignatures[signatures[i]].approved) {
                    revert INVALID_SIGNATURE();
                }
            }
        }
    }

    /**
     * @notice internal function to loop through logic and apply operators on execution results
     * @param logic the logic to execute
     * @param user the user address to use in staticCalls
     * @return bool is user approved
     */
    function _loopAndExecuteLogic(InteractionLogic storage logic, address user) internal view returns (bool) {
        uint16 length = uint16(logic.targets.length);

        if (length == 0) return true;

        for (uint256 i; i < length; i++) {
            bytes memory adjustedCalldata =
                _adjustCalldata(logic.datas[i], approvedSignatures[logic.signatures[i]].calldataAddressPosition, user);

            (bool success, bytes memory executionResult) =
                _executeLogic(logic.targets[i], logic.signatures[i], adjustedCalldata);

            if (!success) {
                revert CallFailed();
            }

            bool result = _applyOperator(logic.operators[i], executionResult, logic.literalOperands[i]);
            if (result) return true;
        }
        return false;
    }

    /**
     * @notice internal helper function to inject user address into calldata
     * @param data existing calldata
     * @param position index of address argument in calldata
     * @param addr user address
     * @return bytes adjusted calldata
     */
    function _adjustCalldata(bytes memory data, uint256 position, address addr) internal pure returns (bytes memory) {
        require(data.length >= (position * 32) + 32, "Data out of bounds");

        uint256 addrIndex = 32 + (position * 32);

        assembly {
            mstore(add(data, addrIndex), addr)
        }

        return data;
    }

    /**
     * @notice internal helper function to make staticcall
     * @param target target contract
     * @param signature function signature
     * @param data calldata with injected user address
     * @return (bool, bytes) staticcall result
     */
    function _executeLogic(
        address target,
        bytes4 signature,
        bytes memory data
    )
        internal
        view
        returns (bool, bytes memory)
    {
        return target.staticcall(abi.encodePacked(signature, data));
    }

    /**
     * @notice internal helper function to apply operator to execution result
     * @param operator comparison operator string
     * @param executionResult result of staticcall
     * @param literalOperand operand for comparison
     * @return bool result of operation
     */
    function _applyOperator(
        bytes memory operator,
        bytes memory executionResult,
        bytes memory literalOperand
    )
        internal
        pure
        returns (bool)
    {
        bytes32 operatorHash = keccak256(operator);
        uint256 expectedValue = abi.decode(literalOperand, (uint256));
        if (operatorHash == keccak256(abi.encodePacked(">"))) {
            return abi.decode(executionResult, (uint256)) > expectedValue;
        } else if (operatorHash == keccak256(abi.encodePacked("<"))) {
            return abi.decode(executionResult, (uint256)) < expectedValue;
        } else if (operatorHash == keccak256(abi.encodePacked("=="))) {
            return abi.decode(executionResult, (uint256)) == expectedValue;
        }

        return false;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  VERSIONING                                */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Returns the contract version
     * @return string contract version
     */
    function contractVersion() external pure returns (string memory) {
        return "1.0.0";
    }

    /**
     * @notice Returns the contract uri
     * @return string contract uri
     */
    function contractURI() external pure returns (string memory) {
        return "https://github.com/calabara-hq/transmissions/packages/protocol";
    }

    /**
     * @notice Returns the contract name
     * @return string contract name
     */
    function contractName() external pure returns (string memory) {
        return "Channel Logic";
    }
}
