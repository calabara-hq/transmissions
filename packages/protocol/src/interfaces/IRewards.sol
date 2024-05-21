// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRewards {
    error INVALID_AMOUNT_SENT();
    error SPLIT_LENGTH_MISMATCH();
    error INVALID_TOTAL_ALLOCATION();
    error ERC20_TRANSFER_FAILED();

    event ERC20Transferred(address indexed spender, address indexed recipient, uint256 amount, address indexed token);
    event ETHTransferred(address indexed spender, address indexed recipient, uint256 amount);

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
