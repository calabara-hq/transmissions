// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IFees {

    enum FeeActions {
        NO_OP,
        SEND_ETH
    }

    struct FeeCommands {
        // Method for operation
        FeeActions method;
        // Arguments used for this operation
        address recipient;
        uint256 amount;

    }

    function setChannelFeeConfig(bytes calldata data) external;

    function getMintPrice() external view returns (uint256);

    function getChannelFeeConfig() external view returns (uint256, uint256, uint256, uint256, uint256);
}
