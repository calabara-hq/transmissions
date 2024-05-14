// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITiming {
    event TimingConfigSet(address indexed channel, uint40 duration);
    event TokenSaleSet(address indexed channel, uint256 indexed tokenId, uint40 endTime);

    function setTimingConfig(bytes calldata data) external;
    function setTokenSale(uint256 tokenId) external;
    function getChannelState() external view returns (uint8);
    function getTokenSaleState(uint256 tokenId) external view returns (uint8);
}

/**
 * @notice InfiniteRound
 * Channel always accepts new creations, and each token sale lasts for a fixed duration.
 * @author @nickddsn
 */
contract InfiniteRound is ITiming {
    /// @notice Mapping of channel address to sale duration
    mapping(address => uint40) public saleDuration;
    /// @notice individual token sale end times based on duration
    mapping(address => mapping(uint256 => uint40)) public saleEnd;

    /**
     * @notice Set the sale duration for a channel
     * @param data abi encoded duration
     */
    function setTimingConfig(bytes calldata data) external {
        uint40 duration = abi.decode(data, (uint40));
        require(duration > 0, "Invalid duration");
        saleDuration[msg.sender] = duration;
        emit TimingConfigSet(msg.sender, duration);
    }

    /**
     * @notice Set the token sale end time based on the global duration
     * @param tokenId token id
     */
    function setTokenSale(uint256 tokenId) external {
        uint80 _saleDuration = uint80(saleDuration[msg.sender]);
        uint80 _currentTime = uint80(block.timestamp);

        // Calculate potential end time using uint80 to prevent overflow during calculation
        uint80 _potentialSaleEnd = _currentTime + _saleDuration;

        // Check if the potential end time exceeds the uint40 maximum value
        if (_potentialSaleEnd >= type(uint40).max) {
            // If the calculated end time is greater than what uint40 can store, set it to the maximum uint40 value
            saleEnd[msg.sender][tokenId] = type(uint40).max;
        } else {
            // Otherwise, safely cast the end time back to uint40 and store it
            saleEnd[msg.sender][tokenId] = uint40(_potentialSaleEnd);
        }
        emit TokenSaleSet(msg.sender, tokenId, saleEnd[msg.sender][tokenId]);
    }

    /**
     * @notice Get the timing state for a channel
     * @dev 1 = active
     * @dev Future updates may include additional states
     * @dev Inifinite rounds are always active
     * @return uint8 state
     */
    function getChannelState() external pure returns (uint8) {
        return 1;
    }

    /**
     * @notice Get the sale state for a token
     * @dev 1 = active, 0 = inactive
     * @dev Future updates may include additional states
     * @return uint8 state
     */
    function getTokenSaleState(uint256 tokenId) external view returns (uint8) {
        return _isSaleActive(tokenId) ? 1 : 0;
    }

    /**
     * @notice Check if the sale is active
     * @param tokenId token id
     * @return bool true if the sale is active
     */
    function _isSaleActive(uint256 tokenId) internal view returns (bool) {
        return saleEnd[msg.sender][tokenId] > block.timestamp;
    }
}
