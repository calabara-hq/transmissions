// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IWETH } from "../interfaces/IWETH.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { SafeTransferLib } from "solady/utils/SafeTransferLib.sol";

/**
 * @author nick
 * Inspired by SplitsV2 from 0xsplits
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

    function deposit(Split calldata split) external payable returns (bytes32);
    function distribute(bytes32 txHash) external;
}

contract Rewards is IRewards {
    using SafeERC20 for IERC20;
    using SafeTransferLib for address;

    /// @notice mapping to channel ETH balances
    mapping(address => uint256) internal ethBalances;
    /// @notice mapping to channel ERC20 balances
    mapping(address => mapping(address => uint256)) internal erc20Balances;
    /// @notice mapping to hashed(channnel,tokenId, mintId) splits
    mapping(bytes32 => SplitReceipt) internal splitReceipts;

    uint256 public TX_ID;

    address NATIVE_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Register an ETH or ERC20 split and generate a receipt for later use
     * @param split Split struct
     * @return receipt Hashed receipt
     */
    function deposit(Split calldata split) external payable returns (bytes32 receipt) {
        _validateSplit(split);

        if (_isNativeToken(split.token)) {
            require(msg.value == split.totalAllocation, "Rewards: invalid deposit");
            ethBalances[msg.sender] += split.totalAllocation;
        } else {
            erc20Balances[split.token][msg.sender] += split.totalAllocation;
        }

        uint256 nextTransactionId = _getAndIncrementTxId();

        receipt = keccak256(abi.encodePacked(msg.sender, nextTransactionId));
        splitReceipts[receipt] = SplitReceipt({ split: split, fulfilled: false });
    }

    function distribute(bytes32 txHash) external {
        SplitReceipt memory receipt = splitReceipts[txHash];
        uint256 balance = getBalance(msg.sender, receipt.split.token);
        require(balance >= receipt.split.totalAllocation, "Rewards: insufficient balance");
        require(!receipt.fulfilled, "Rewards: receipt already fulfilled");

        splitReceipts[txHash].fulfilled = true;

        if (_isNativeToken(receipt.split.token)) {
            ethBalances[msg.sender] -= receipt.split.totalAllocation;
        } else {
            erc20Balances[receipt.split.token][msg.sender] -= receipt.split.totalAllocation;
        }

        for (uint256 i = 0; i < receipt.split.recipients.length; i++) {
            if (_isNativeToken(receipt.split.token)) {
                _safeTransferETHWithFallback(receipt.split.recipients[i], receipt.split.allocations[i]);
            } else {
                SafeTransferLib.safeTransfer(
                    receipt.split.token, receipt.split.recipients[i], receipt.split.allocations[i]
                );
            }
        }
    }

    function getBalance(address channel, address token) public view returns (uint256) {
        if (_isNativeToken(token)) {
            return ethBalances[channel];
        } else {
            return erc20Balances[token][channel];
        }
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _isNativeToken(address token) internal view returns (bool) {
        return token == NATIVE_TOKEN;
    }

    function _validateDeposit(Split calldata split) internal view {
        if (split.token == NATIVE_TOKEN) {
            require(msg.value == split.totalAllocation, "Rewards: invalid deposit");
        } else {
            require(msg.value == 0, "Rewards: invalid deposit");
        }
    }

    function _validateSplit(Split calldata split) internal view {
        uint256 allocationSum;

        for (uint256 i = 0; i < split.allocations.length; i++) {
            allocationSum += split.allocations[i];
        }

        require(split.recipients.length == split.allocations.length, "Rewards: invalid split");
        require(split.totalAllocation > 0, "Rewards: invalid total allocation");
        require(allocationSum == split.totalAllocation, "Rewards: invalid total allocation");
    }

    function _getAndIncrementTxId() internal returns (uint256) {
        unchecked {
            return TX_ID++;
        }
    }

    /**
     * @notice Transfer ETH with gas cap. If it fails, wrap the ETH and try again as WETH
     * @dev Inspired by nouns auction house bid refunds
     */
    function _safeTransferETHWithFallback(address to, uint256 amount) internal {
        if (!to.trySafeTransferETH(amount, SafeTransferLib.GAS_STIPEND_NO_GRIEF)) {
            IWETH(WETH).deposit{ value: amount }();
            IERC20(WETH).safeTransfer(to, amount);
        }
    }
}
