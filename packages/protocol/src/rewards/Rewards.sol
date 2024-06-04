// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IWETH } from "../interfaces/IWETH.sol";

import { NativeTokenLib } from "../libraries/NativeTokenLib.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { SafeTransferLib } from "solady/utils/SafeTransferLib.sol";
/**
 * @title Rewards.sol
 * @author nick
 * @dev This contract handles the distribution of rewards.
 * Rewards can flow in 2 modes: escrow and pass-through.
 * Escrow rewards are stored in the contract and distributed later.
 * Pass-through rewards are forwarded to intended recipients in the same transaction they are received.
 */

contract Rewards {
    using SafeERC20 for IERC20;
    using SafeTransferLib for address;
    using NativeTokenLib for address;

    /* -------------------------------------------------------------------------- */
    /*                                   ERRORS                                   */
    /* -------------------------------------------------------------------------- */

    error InvalidAmountSent();
    error SplitLengthMismatch();
    error InvalidTotalAllocation();
    error ERC20TransferFailed();
    error InsufficientBalance();

    /* -------------------------------------------------------------------------- */
    /*                                   EVENTS                                   */
    /* -------------------------------------------------------------------------- */

    event ERC20Transferred(address indexed spender, address indexed recipient, uint256 amount, address indexed token);
    event ETHTransferred(address indexed spender, address indexed recipient, uint256 amount);

    /* -------------------------------------------------------------------------- */
    /*                                   STRUCTS                                  */
    /* -------------------------------------------------------------------------- */

    struct Split {
        address[] recipients;
        uint256[] allocations;
        uint256 totalAllocation;
        address token;
    }

    /* -------------------------------------------------------------------------- */
    /*                                   STORAGE                                  */
    /* -------------------------------------------------------------------------- */

    address WETH;

    mapping(address => uint256) public erc20Balances;

    /* -------------------------------------------------------------------------- */
    /*                          CONSTRUCTOR & INITIALIZER                         */
    /* -------------------------------------------------------------------------- */

    constructor(address weth) {
        WETH = weth;
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev deposit eth/erc20 for later distribution
     */
    function _depositToEscrow(address token, uint256 amount) internal {
        _validateIncomingValue(token, amount);

        if (!token.isNativeToken()) {
            erc20Balances[token] += amount;
            _transferExternalERC20(address(this), amount, token);
        }
    }

    /**
     * @dev withdraw eth/erc20 from escrow
     */
    function _withdrawFromEscrow(address token, address to, uint256 amount) internal {
        if (token.isNativeToken()) {
            _processETHTransfer(to, amount);
        } else {
            _transferEscrowERC20(to, amount, token);
        }
    }

    /**
     * @dev distribute eth/erc20 to multiple recipients from escrow
     */
    function _distributeEscrowSplit(Split memory split) internal {
        _validateIncomingAllocations(split.recipients, split.allocations, split.totalAllocation);

        if (split.token.isNativeToken()) {
            for (uint256 i; i < split.recipients.length; i++) {
                if (split.recipients[i] != address(0)) {
                    /// @dev if the address is zero, keep the funds in the contract for the admins to withdraw later
                    // otherwise process the transfer
                    _processETHTransfer(split.recipients[i], split.allocations[i]);
                }
            }
        } else {
            for (uint256 i; i < split.recipients.length; i++) {
                if (split.recipients[i] != address(0)) {
                    /// @dev if the address is zero, keep the funds in the contract for the admins to withdraw later
                    // otherwise process the transfer
                    _transferEscrowERC20(split.recipients[i], split.allocations[i], split.token);
                }
            }
        }
    }

    /**
     * @dev distribute eth/erc20 to multiple recipients in the same transaction
     */
    function _distributePassThroughSplit(Split memory split) internal {
        _validateIncomingValue(split.token, split.totalAllocation);
        _validateIncomingAllocations(split.recipients, split.allocations, split.totalAllocation);

        if (split.token.isNativeToken()) {
            for (uint256 i; i < split.recipients.length; i++) {
                _processETHTransfer(split.recipients[i], split.allocations[i]);
            }
        } else {
            for (uint256 i; i < split.recipients.length; i++) {
                _transferExternalERC20(split.recipients[i], split.allocations[i], split.token);
            }
        }
    }

    /* -------------------------------------------------------------------------- */
    /*                               TRANSFER FUNCTIONS                           */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev transfer an escrowed erc20 to a recipient
     */
    function _transferEscrowERC20(address recipient, uint256 amount, address token) internal {
        emit ERC20Transferred(msg.sender, recipient, amount, token);

        uint256 localBalance = erc20Balances[token];

        if (amount > localBalance) {
            revert InsufficientBalance();
        }

        erc20Balances[token] -= amount;

        uint256 beforeBalance = IERC20(token).balanceOf(recipient);
        IERC20(token).safeTransfer(recipient, amount);
        uint256 afterBalance = IERC20(token).balanceOf(recipient);

        if (beforeBalance + amount != afterBalance) {
            revert ERC20TransferFailed();
        }
    }

    /**
     * @dev transfer an external erc20 to a recipient
     */
    function _transferExternalERC20(address recipient, uint256 amount, address token) internal {
        emit ERC20Transferred(msg.sender, recipient, amount, token);

        uint256 beforeBalance = IERC20(token).balanceOf(recipient);
        IERC20(token).safeTransferFrom(msg.sender, recipient, amount);
        uint256 afterBalance = IERC20(token).balanceOf(recipient);

        if (beforeBalance + amount != afterBalance) {
            revert ERC20TransferFailed();
        }
    }

    /**
     * @notice Transfer ETH with gas cap. If it fails, wrap the ETH and try again as WETH
     * Inspired by NounsDAO auction house bid refunds
     */
    function _processETHTransfer(address recipient, uint256 amount) internal {
        emit ETHTransferred(msg.sender, recipient, amount);

        if (!recipient.trySafeTransferETH(amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF)) {
            IWETH(WETH).deposit{ value: amount }();
            IERC20(WETH).safeTransfer(recipient, amount);
        }
    }

    /* -------------------------------------------------------------------------- */
    /*                               HELPER FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _validateIncomingValue(address token, uint256 expectedValue) internal view {
        if (token.isNativeToken()) {
            // If the token is ETH, the total allocation must match the value sent

            if (msg.value != expectedValue) {
                revert InvalidAmountSent();
            }
        } else if (msg.value != 0) {
            // If the token is not ETH, the value sent must be 0
            revert InvalidAmountSent();
        }
    }

    function _validateIncomingAllocations(
        address[] memory recipients,
        uint256[] memory allocations,
        uint256 totalAllocation
    )
        internal
        pure
    {
        uint256 allocationSum;

        for (uint256 i = 0; i < allocations.length; i++) {
            allocationSum += allocations[i];
        }

        if (recipients.length != allocations.length) {
            revert SplitLengthMismatch();
        }

        if (totalAllocation == 0 || allocationSum != totalAllocation) {
            revert InvalidTotalAllocation();
        }
    }
}
