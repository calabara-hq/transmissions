// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IRewards } from "../interfaces/IRewards.sol";
import { IWETH } from "../interfaces/IWETH.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { console } from "forge-std/Test.sol";
import { SafeTransferLib } from "solady/utils/SafeTransferLib.sol";

/**
 * @author nick
 */
contract Rewards is IRewards {
    using SafeERC20 for IERC20;
    using SafeTransferLib for address;

    address NATIVE_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address WETH;

    constructor(address weth) {
        WETH = weth;
    }

    function _distributeIncomingSplit(Split memory split) internal {
        _validateSplit(split);

        if (_isNativeToken(split.token)) {
            for (uint256 i; i < split.recipients.length; i++) {
                _processETHTransfer(split.recipients[i], split.allocations[i]);
            }
        } else {
            for (uint256 i; i < split.recipients.length; i++) {
                _processERC20Transfer(split.recipients[i], split.allocations[i], split.token);
            }
        }
    }

    function _isNativeToken(address token) internal view returns (bool) {
        return token == NATIVE_TOKEN;
    }

    function _validateSplit(Split memory split) internal view {
        if (_isNativeToken(split.token)) {
            // If the token is ETH, the total allocation must match the value sent
            if (msg.value != split.totalAllocation) {
                revert INVALID_AMOUNT_SENT();
            }
        } else if (msg.value != 0) {
            // If the token is not ETH, the value sent must be 0
            revert INVALID_AMOUNT_SENT();
        }

        uint256 allocationSum;

        for (uint256 i = 0; i < split.allocations.length; i++) {
            allocationSum += split.allocations[i];
        }

        if (split.recipients.length != split.allocations.length) {
            revert SPLIT_LENGTH_MISMATCH();
        }

        if (split.totalAllocation == 0 || allocationSum != split.totalAllocation) {
            revert INVALID_TOTAL_ALLOCATION();
        }
    }

    function _processERC20Transfer(address recipient, uint256 amount, address token) internal {
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
}
