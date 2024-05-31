// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IRewards } from "../interfaces/IRewards.sol";
import { IWETH } from "../interfaces/IWETH.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { console } from "forge-std/Test.sol";
import { SafeTransferLib } from "solady/utils/SafeTransferLib.sol";

/**
 * @title Rewards.sol
 * @author nick
 * @dev This contract handles the distribution of rewards.
 * Rewards can flow in 2 modes: escrow and pass-through.
 * Escrow rewards are stored in the contract and distributed later.
 * Pass-through rewards are distributed in the same transaction they are received.
 */
contract Rewards is IRewards {
    using SafeERC20 for IERC20;
    using SafeTransferLib for address;

    address constant NATIVE_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    address WETH;

    mapping(address => uint256) public erc20Balances;

    constructor(address weth) {
        WETH = weth;
    }

    /**
     * @dev deposit eth/erc20 for later distribution
     */
    function _depositToEscrow(address token, uint256 amount) internal {
        _validateIncomingValue(token, amount);

        if (!_isNativeToken(token)) {
            erc20Balances[token] += amount;
            _processExternalERC20Transfer(address(this), amount, token);
        }
    }

    /**
     * @dev withdraw eth/erc20 from escrow
     */
    function _withdrawFromEscrow(address token, address to, uint256 amount) internal {
        if (_isNativeToken(token)) {
            _processETHTransfer(to, amount);
        } else {
            _processInternalERC20Transfer(to, amount, token);
        }
    }

    /**
     * @dev distribute eth/erc20 to multiple recipients from escrow
     */
    function _distributeEscrowSplit(Split memory split) internal {
        _validateIncomingAllocations(split.recipients, split.allocations, split.totalAllocation);

        if (_isNativeToken(split.token)) {
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
                    _processInternalERC20Transfer(split.recipients[i], split.allocations[i], split.token);
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

        if (_isNativeToken(split.token)) {
            for (uint256 i; i < split.recipients.length; i++) {
                _processETHTransfer(split.recipients[i], split.allocations[i]);
            }
        } else {
            for (uint256 i; i < split.recipients.length; i++) {
                _processExternalERC20Transfer(split.recipients[i], split.allocations[i], split.token);
            }
        }
    }

    /* -------------------------------------------------------------------------- */
    /*                               TRANSFER FUNCTIONS                           */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev transfer an escrowed erc20 to a recipient
     */
    function _processInternalERC20Transfer(address recipient, uint256 amount, address token) internal {
        emit ERC20Transferred(msg.sender, recipient, amount, token);

        uint256 localBalance = erc20Balances[token];

        if (amount > localBalance) {
            revert INSUFFICIENT_BALANCE();
        }

        erc20Balances[token] -= amount;

        uint256 beforeBalance = IERC20(token).balanceOf(recipient);
        IERC20(token).safeTransfer(recipient, amount);
        uint256 afterBalance = IERC20(token).balanceOf(recipient);

        if (beforeBalance + amount != afterBalance) {
            revert ERC20_TRANSFER_FAILED();
        }
    }

    /**
     * @dev transfer an external erc20 to a recipient
     */
    function _processExternalERC20Transfer(address recipient, uint256 amount, address token) internal {
        emit ERC20Transferred(msg.sender, recipient, amount, token);

        uint256 beforeBalance = IERC20(token).balanceOf(recipient);
        IERC20(token).safeTransferFrom(msg.sender, recipient, amount);
        uint256 afterBalance = IERC20(token).balanceOf(recipient);

        if (beforeBalance + amount != afterBalance) {
            revert ERC20_TRANSFER_FAILED();
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
            IERC20(WETH).transfer(recipient, amount);
        }
    }

    /* -------------------------------------------------------------------------- */
    /*                               HELPER FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _isNativeToken(address token) internal view returns (bool) {
        return token == NATIVE_TOKEN;
    }

    // todo determine if this fn will ever see a ev of 0 in normal application
    function _validateIncomingValue(address token, uint256 expectedValue) internal view {
        if (_isNativeToken(token)) {
            // If the token is ETH, the total allocation must match the value sent
            if (msg.value != expectedValue) {
                revert INVALID_AMOUNT_SENT();
            }
        } else if (msg.value != 0) {
            // If the token is not ETH, the value sent must be 0
            revert INVALID_AMOUNT_SENT();
        }
    }

    function _validateIncomingAllocations(
        address[] memory recipients,
        uint256[] memory allocations,
        uint256 totalAllocation
    )
        internal
        view
    {
        uint256 allocationSum;

        for (uint256 i = 0; i < allocations.length; i++) {
            allocationSum += allocations[i];
        }

        if (recipients.length != allocations.length) {
            revert SPLIT_LENGTH_MISMATCH();
        }

        if (totalAllocation == 0 || allocationSum != totalAllocation) {
            revert INVALID_TOTAL_ALLOCATION();
        }
    }
}
