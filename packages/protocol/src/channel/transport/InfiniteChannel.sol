// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IVersionedContract } from "../../interfaces/IVersionedContract.sol";
import { Channel } from "../Channel.sol";
/**
 * @title Infinite Channel
 * @author nick
 * @dev Infinite channels indefinitely accept new tokens.
 * @dev A global saleDuration is set, which is used to calculate the sale end for each new token.
 */

contract InfiniteChannel is Channel, IVersionedContract {
    /* -------------------------------------------------------------------------- */
    /*                                   ERRORS                                   */
    /* -------------------------------------------------------------------------- */

    error SaleOver();
    error InvalidTiming();

    /* -------------------------------------------------------------------------- */
    /*                                   EVENTS                                   */
    /* -------------------------------------------------------------------------- */

    event TokenSaleSet(address indexed caller, uint256 indexed tokenId, uint40 saleEnd);

    /* -------------------------------------------------------------------------- */
    /*                                   STORAGE                                  */
    /* -------------------------------------------------------------------------- */

    /// @notice duration of the public sale for each new token
    uint40 public saleDuration;
    /// @notice individual token sale end times based on duration
    mapping(uint256 => uint40) public saleEnd;

    /* -------------------------------------------------------------------------- */
    /*                          CONSTRUCTOR & INITIALIZER                         */
    /* -------------------------------------------------------------------------- */

    constructor(address _updgradePath, address _weth) initializer Channel(_updgradePath, _weth) { }

    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Set the sale duration for a channel
     * @param data encoded duration
     */
    function setTransportConfig(bytes calldata data) public payable override onlyAdminOrManager {
        if (msg.value > 0) revert("This function does not accept ether");
        uint40 duration = abi.decode(data, (uint40));
        _setDuration(duration);
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _setDuration(uint40 _duration) internal {
        if (_duration == 0) revert InvalidTiming();
        saleDuration = _duration;
    }

    function _transportProcessNewToken(uint256 tokenId) internal override {
        _setTokenSale(tokenId);
    }

    function _transportProcessMint(uint256 tokenId) internal override {
        if (block.timestamp > saleEnd[tokenId]) {
            revert SaleOver();
        }
    }

    /**
     * @notice Set the token sale end time based on the global duration
     * @param tokenId token id
     */
    function _setTokenSale(uint256 tokenId) internal {
        uint80 _saleDuration = uint80(saleDuration);
        uint80 _currentTime = uint80(block.timestamp);

        /// @dev Calculate potential end time using uint80 to prevent overflow during calculation
        uint80 _potentialSaleEnd = _currentTime + _saleDuration;

        /// @dev Check if the potential end time exceeds the uint40 maximum value
        if (_potentialSaleEnd >= type(uint40).max) {
            // If the calculated end time is greater than what uint40 can store, set it to the maximum uint40 value
            saleEnd[tokenId] = type(uint40).max;
        } else {
            /// @dev Otherwise, safely cast the end time back to uint40 and store it
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
