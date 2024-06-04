// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ILogic } from "../interfaces/ILogic.sol";
import { Ownable } from "openzeppelin-contracts/access/Ownable.sol";

import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";

/**
 * @title Dynamic Logic
 * @author nick
 * @notice Used to manage the interaction power for users in a channel.
 */
contract DynamicLogic is ILogic, Ownable {
    /* -------------------------------------------------------------------------- */
    /*                                   ERRORS                                   */
    /* -------------------------------------------------------------------------- */

    error InvalidSignature();
    error CallFailed();

    /* -------------------------------------------------------------------------- */
    /*                                   EVENTS                                   */
    /* -------------------------------------------------------------------------- */

    event CreatorLogicSet(address indexed channel, InteractionLogic logic);
    event MinterLogicSet(address indexed channel, InteractionLogic logic);

    /* -------------------------------------------------------------------------- */
    /*                                   STRUCTS                                  */
    /* -------------------------------------------------------------------------- */
    enum InteractionPowerType {
        UNIFORM,
        WEIGHTED
    }

    enum Operator {
        LESSTHAN,
        GREATERTHAN,
        EQUALS
    }

    struct InteractionLogic {
        address[] targets;
        bytes4[] signatures;
        bytes[] datas;
        Operator[] operators;
        bytes[] literalOperands;
        InteractionPowerType[] interactionPowerType;
        uint256[] interactionPower;
    }

    struct ApprovedSignature {
        bool approved;
        uint256 calldataAddressPosition;
    }
    /* -------------------------------------------------------------------------- */
    /*                                   STORAGE                                  */
    /* -------------------------------------------------------------------------- */

    mapping(address => InteractionLogic) internal creatorLogic;
    mapping(address => InteractionLogic) internal minterLogic;

    mapping(bytes4 => ApprovedSignature) approvedSignatures;

    /* -------------------------------------------------------------------------- */
    /*                          CONSTRUCTOR & INITIALIZER                         */
    /* -------------------------------------------------------------------------- */

    constructor(address _initOwner) Ownable(_initOwner) { }

    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Approve a signature for use in logic
     * @param signature function signature
     * @param calldataAddressPosition position of address in calldata
     */
    function approveLogic(bytes4 signature, uint256 calldataAddressPosition) external onlyOwner {
        approvedSignatures[signature] = ApprovedSignature(true, calldataAddressPosition);
    }

    /**
     * @notice Set the creator logic for a channel
     * @param data abi encoded representation of the logic
     */
    function setCreatorLogic(bytes memory data) external {
        InteractionLogic memory logic = _constructInteractionLogic(data);
        if (logic.targets.length > 0) {
            // only set storage if logic is present
            creatorLogic[msg.sender] = logic;
        }
        emit CreatorLogicSet(msg.sender, logic);
    }

    /**
     * @notice Set the minter logic for a channel
     * @param data abi encoded representation of the logic
     */
    function setMinterLogic(bytes memory data) external {
        InteractionLogic memory logic = _constructInteractionLogic(data);
        if (logic.targets.length > 0) {
            // only set storage if logic is present
            minterLogic[msg.sender] = logic;
        }
        emit MinterLogicSet(msg.sender, logic);
    }

    /**
     * @notice determine creation power for a user
     * @param user abi encoded representation of the logic
     * @return uint256 creation power
     */
    function calculateCreatorInteractionPower(address user) external view returns (uint256) {
        uint256 result = _getArrayMax(_loopAndExecuteLogic(creatorLogic[msg.sender], user));
        return result;
    }

    /**
     * @notice determine minting power for a user
     * @param user abi encoded representation of the logic
     * @return uint256 minting power
     */
    function calculateMinterInteractionPower(address user) external view returns (uint256) {
        uint256 result = _getArrayMax(_loopAndExecuteLogic(minterLogic[msg.sender], user));
        return result;
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev construct the interaction logic for a channel
     * @param data abi encoded representation of the logic
     * @return InteractionLogic the constructed logic
     */
    function _constructInteractionLogic(bytes memory data) internal view returns (InteractionLogic memory) {
        (
            address[] memory targets,
            bytes4[] memory signatures,
            bytes[] memory datas,
            Operator[] memory operators,
            bytes[] memory literalOperands,
            InteractionPowerType[] memory interactionPowerType,
            uint256[] memory interactionPower
        ) = abi.decode(data, (address[], bytes4[], bytes[], Operator[], bytes[], InteractionPowerType[], uint256[]));

        _validateSignatures(signatures);
        _validateLogic(targets, signatures, datas, operators, literalOperands, interactionPowerType, interactionPower);

        return InteractionLogic(
            targets, signatures, datas, operators, literalOperands, interactionPowerType, interactionPower
        );
    }

    function _getArrayMax(uint256[] memory arr) internal pure returns (uint256) {
        uint256 max = 0;
        for (uint256 i = 0; i < arr.length; i++) {
            if (arr[i] > max) {
                max = arr[i];
            }
        }
        return max;
    }

    /**
     * @dev internal helper function to make sure lengths of logic arrays match
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
        Operator[] memory operators,
        bytes[] memory literalOperands,
        InteractionPowerType[] memory interactionPowerType,
        uint256[] memory interactionPower
    )
        internal
        pure
    {
        require(
            targets.length == signatures.length && signatures.length == datas.length && datas.length == operators.length
                && operators.length == literalOperands.length && literalOperands.length == interactionPowerType.length
                && interactionPowerType.length == interactionPower.length,
            "Logic field lengths do not match"
        );
    }

    /**
     * @dev internal function to check registry of valid signatures
     * @param signatures array of function signatures
     */
    function _validateSignatures(bytes4[] memory signatures) internal view {
        uint256 length = signatures.length;
        if (length > 0) {
            for (uint256 i; i < length; i++) {
                if (!approvedSignatures[signatures[i]].approved) {
                    revert InvalidSignature();
                }
            }
        }
    }

    /**
     * @dev internal function to loop through logic and apply operators on execution results
     * @param logic the logic to execute
     * @param user the user address to use in staticCalls
     * @return uint256[] array of interaction power results
     */
    function _loopAndExecuteLogic(
        InteractionLogic storage logic,
        address user
    )
        internal
        view
        returns (uint256[] memory)
    {
        uint16 length = uint16(logic.targets.length);

        uint256[] memory results = new uint256[](length > 0 ? length : 1);

        if (length == 0) {
            results[0] = type(uint256).max;
            return results;
        }

        for (uint256 i; i < length; i++) {
            bytes memory adjustedCalldata =
                _adjustCalldata(logic.datas[i], approvedSignatures[logic.signatures[i]].calldataAddressPosition, user);

            (bool success, bytes memory executionResult) =
                _executeLogic(logic.targets[i], logic.signatures[i], adjustedCalldata);

            if (!success) {
                revert CallFailed();
            }

            bool result = _applyOperator(logic.operators[i], executionResult, logic.literalOperands[i]);
            if (result) {
                if (logic.interactionPowerType[i] == InteractionPowerType.UNIFORM) {
                    /// @dev If uniform, interaction power is a constant from the logic parameters
                    results[i] = logic.interactionPower[i];
                } else {
                    /// @dev If weighted, interaction power is the result of the staticcall
                    /// @dev For rules returning booleans, this will be 1 / 0.
                    /// @dev For this reason, weighted power types with boolean results should be used with care.
                    results[i] = abi.decode(executionResult, (uint256));
                }
            }
        }
        return results;
    }

    /**
     * @dev internal helper function to inject user address into calldata
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
     * @dev internal helper function to make staticcall
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
     * @dev internal helper function to apply operator to execution result
     * @param operator comparison operator string
     * @param executionResult result of staticcall
     * @param literalOperand operand for comparison
     * @return bool result of operation
     */
    function _applyOperator(
        Operator operator,
        bytes memory executionResult,
        bytes memory literalOperand
    )
        internal
        pure
        returns (bool)
    {
        uint256 operand = abi.decode(literalOperand, (uint256));
        uint256 result = abi.decode(executionResult, (uint256));

        if (operator == Operator.LESSTHAN) {
            return result < operand;
        } else if (operator == Operator.GREATERTHAN) {
            return result > operand;
        } else if (operator == Operator.EQUALS) {
            return result == operand;
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
        return "Dynamic Logic";
    }
}
