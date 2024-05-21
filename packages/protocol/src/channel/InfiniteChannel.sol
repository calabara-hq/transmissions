// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IVersionedContract } from "../interfaces/IVersionedContract.sol";
import { Channel } from "./Channel.sol";

/**
 * @title InfiniteChannel
 * @author nick
 *
 * Infinite channels run "forever". The channel will indefinitely accept new tokens.
 * A global saleDuration is set, which is used to calculate the sale end for each new token.
 */
contract InfiniteChannel is Channel, IVersionedContract {
    error SALE_OVER();
    error INVALID_DURATION();

    event TokenSaleSet(address indexed caller, uint256 indexed tokenId, uint40 saleEnd);

    /// @notice duration of the public sale for each new token
    uint40 public saleDuration;
    /// @notice individual token sale end times based on duration
    mapping(uint256 => uint40) public saleEnd;

    constructor(address _updgradePath, address _weth) initializer Channel(_updgradePath, _weth) { }

    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Set the sale duration for a channel
     * @param data encoded duration
     */
    function setTiming(bytes calldata data) public override onlyAdminOrManager {
        uint40 duration = abi.decode(data, (uint40));
        _setDuration(duration);
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _setDuration(uint40 _duration) internal {
        if (_duration == 0) revert INVALID_DURATION();
        saleDuration = _duration;
    }

    function _processNewToken(uint256 tokenId) internal override {
        _setTokenSale(tokenId);
    }

    function _processMint(uint256 tokenId) internal view override {
        if (block.timestamp > saleEnd[tokenId]) {
            revert SALE_OVER();
        }
    }

    /**
     * @notice Set the token sale end time based on the global duration
     * @param tokenId token id
     */
    function _setTokenSale(uint256 tokenId) internal {
        uint80 _saleDuration = uint80(saleDuration);
        uint80 _currentTime = uint80(block.timestamp);

        // Calculate potential end time using uint80 to prevent overflow during calculation
        uint80 _potentialSaleEnd = _currentTime + _saleDuration;

        // Check if the potential end time exceeds the uint40 maximum value
        if (_potentialSaleEnd >= type(uint40).max) {
            // If the calculated end time is greater than what uint40 can store, set it to the maximum uint40 value
            saleEnd[tokenId] = type(uint40).max;
        } else {
            // Otherwise, safely cast the end time back to uint40 and store it
            saleEnd[tokenId] = uint40(_potentialSaleEnd);
        }
        emit TokenSaleSet(msg.sender, tokenId, saleEnd[tokenId]);
    }

    /* -------------------------------------------------------------------------- */
    /*                                  VERSIONING                                */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Returns the contract version
     * @return string contract version
     */
    function contractVersion() external pure returns (string memory) {
        return "1.0.0";
    }

    /**
     * @notice Returns the contract uri
     * @return string contract uri
     */
    function contractURI() external pure returns (string memory) {
        return "https://github.com/calabara-hq/transmissions/packages/protocol";
    }

    /**
     * @notice Returns the contract name
     * @return string contract name
     */
    function contractName() external pure returns (string memory) {
        return "Infinite Channel";
    }
}
