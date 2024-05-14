// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IWETH } from "../interfaces/IWETH.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import { console } from "forge-std/Test.sol";
import { SafeTransferLib } from "solady/utils/SafeTransferLib.sol";

/**
 * @author nick
 */
interface IRewards {
    struct Split {
        address[] recipients;
        uint256[] allocations;
        uint256 totalAllocation;
        address token;
    }

    struct SplitReceipt {
        Split split;
        bool fulfilled;
    }
}

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
            for (uint256 i = 0; i < split.recipients.length; i++) {
                _processETHTransfer(split.recipients[i], split.allocations[i]);
            }
        } else {
            for (uint256 i = 0; i < split.recipients.length; i++) {
                _processERC20Transfer(split.recipients[i], split.allocations[i], split.token);
            }
        }
    }

    function _isNativeToken(address token) internal view returns (bool) {
        return token == NATIVE_TOKEN;
    }

    function _validateSplit(Split memory split) internal view {
        uint256 allocationSum;

        for (uint256 i = 0; i < split.allocations.length; i++) {
            allocationSum += split.allocations[i];
        }

        if (split.token == NATIVE_TOKEN) {
            require(msg.value == split.totalAllocation, "Rewards: invalid amount");
        } else {
            require(msg.value == 0, "Rewards: invalid amount");
        }

        require(split.recipients.length == split.allocations.length, "Rewards: invalid split");
        require(split.totalAllocation > 0, "Rewards: invalid total allocation");
        require(allocationSum == split.totalAllocation, "Rewards: invalid total allocation");
    }

    function _processERC20Transfer(address recipient, uint256 amount, address token) internal {
        uint256 beforeBalance = IERC20(token).balanceOf(recipient);
        IERC20(token).safeTransferFrom(msg.sender, recipient, amount);
        uint256 afterBalance = IERC20(token).balanceOf(recipient);

        if (beforeBalance + amount != afterBalance) {
            revert("ERC20 transfer failed");
        }
    }

    /**
     * @notice Transfer ETH with gas cap. If it fails, wrap the ETH and try again as WETH
     * Inspired by NounsDAO auction house bid refunds
     */
    function _processETHTransfer(address to, uint256 amount) internal {
        if (!to.trySafeTransferETH(amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF)) {
            IWETH(WETH).deposit{ value: amount }();
            IERC20(WETH).transfer(to, amount);
        }
    }
}
