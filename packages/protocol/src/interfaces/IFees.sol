// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { CustomFees } from "../fees/CustomFees.sol";
import { IRewards } from "./IRewards.sol";
import { IVersionedContract } from "./IVersionedContract.sol";

interface IFees is IVersionedContract {
    error INVAlID_BPS();
    error INVALID_SPLIT();
    error ADDRESS_ZERO();
    error ERC20_MINTING_DISABLED();
    error INVALID_ETH_MINT_PRICE();
    error TOTAL_VALUE_MISMATCH();

    event FeeConfigSet(address indexed channel, CustomFees.FeeConfig feeconfig);

    function setChannelFees(bytes calldata data) external;
    function getEthMintPrice() external view returns (uint256);
    function getErc20MintPrice() external view returns (uint256);
    function requestEthMint(
        address[] memory creators,
        address[] memory referrals,
        address[] memory sponsors,
        uint256[] memory amounts
    )
        external
        view
        returns (IRewards.Split memory);
    function requestErc20Mint(
        address[] memory creators,
        address[] memory referrals,
        address[] memory sponsors,
        uint256[] memory amounts
    )
        external
        view
        returns (IRewards.Split memory);
}
