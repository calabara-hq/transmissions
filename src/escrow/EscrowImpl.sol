// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @notice Escrow
/// @author @nickddsn

contract Escrow {
    mapping(address => uint256) public ethBalances;

    function deposit(address rx, uint256 amount) external payable {
        ethBalances[rx] += amount;
    }

    function withdraw(uint256 _amount) external {
        uint256 amount = _amount;
        if (_amount == 0) {
            amount = ethBalances[msg.sender];
        }

        require(ethBalances[msg.sender] >= amount, "Insufficient balance");
        ethBalances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function balanceOf(address account) external view returns (uint256) {
        return ethBalances[account];
    }
}
