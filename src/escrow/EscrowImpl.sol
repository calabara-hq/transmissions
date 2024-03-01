// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @notice Escrow
/// @author @nickddsn


contract Escrow {
    mapping(address => uint256) public ethBalances;

    function deposit(uint256 amount) external payable {
        ethBalances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(ethBalances[msg.sender] >= amount, "Insufficient balance");
        ethBalances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return ethBalances[account];
    }

}