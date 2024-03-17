// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {IChannel} from "../interfaces/IChannel.sol";
import {IChannelTypesV1} from "../interfaces/IChannelTypesV1.sol";
import {ChannelStorageV1} from "../storage/ChannelStorageV1.sol";
import {ChannelFeeStorageV1} from "../storage/ChannelFeeStorageV1.sol";
import {Escrow} from "../escrow/EscrowImpl.sol";
import {Multicall} from "../utils/Multicall.sol";
import {PaidSaleStrategy} from "../sales/PaidSalesStrategy.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {SharedBaseConstants} from "../shared/SharedBaseConstants.sol";

contract Channel is
    IChannel,
    IChannelTypesV1,
    ChannelStorageV1,
    ChannelFeeStorageV1,
    Escrow,
    Multicall,
    PaidSaleStrategy,
    Initializable,
    UUPSUpgradeable,
    SharedBaseConstants
{
    //FeePair[] public channelFees;

    constructor(address _platformRecipient) initializer {
        // nextTokenId = 1;
    }

    /// @notice initializer
    /// @param uri the uri for the token
    /// @param setupActions the setup actions for the channel

    function initialize(string calldata uri, bytes[] calldata setupActions) external initializer {
        __UUPSUpgradeable_init();

        if (setupActions.length > 0) {
            multicall(setupActions);
        }
    }

    // function setSaleConfig(uint8 salesBit) internal {
    //     salesBit = salesBit;
    // }

    // function getSaleConfig() public view returns (FeePair[] memory) {
    //     return contractFees;
    // }

    // function getAndSetNextTokenId() public view returns (uint256) {
    //     return nextTokenId++;
    // }

    // function createToken(string calldata uri, address author, uint256 maxSupply, address createReferral)
    //     public
    //     returns (uint256)
    // {
    //     // todo: implement incrementing tokenId
    //     uint256 tokenId = getNextTokenId();

    //     // need to store the create referral address somewhere (maybe not here in the token config)
    //     // do we need to store the author address somewhere?

    //     TokenConfig memory tokenConfig = TokenConfig({
    //         uri: uri,
    //         maxSupply: maxSupply,
    //         totalMinted: 0,
    //         author: author,
    //         createReferral: createReferral
    //     });

    //     tokens[tokenId] = tokenConfig;

    //     return tokenId;
    // }

    // function mint(address minter, uint256 tokenId, uint256 amount, address mintReferral) external payable {
    //     // todo: checks for minting rules

    //     // deposit eth for create referral
    //     // deposit eth for creator
    //     // deposit eth for mint referral
    //     // deposit eth for uplink

    //     uint256 price = getTokenMintPrice(tokenId, mintReferral != address(0));
    //     require(msg.value == price, "Invalid eth amount for minting");

    //     // deposit constant fees
    //     for (uint256 i = 0; i < constantChannelFees.length; i++) {
    //         deposit(constantChannelFees[i].addr, constantChannelFees[i].amount);
    //     }

    //     // deposit runtime fees
    //     deposit(tokens[tokenId].author, runtimeChannelFees[0]);
    //     deposit(tokens[tokenId].createReferral, runtimeChannelFees[1]);
    //     deposit(mintReferral, runtimeChannelFees[2]);

    //     tokens[tokenId].totalMinted += amount;
    //     _mint(minter, tokenId, amount, "");
    // }

    // function getTokenMintPrice(uint256 tokenId, bool withMintReferral) public view returns (uint256) {
    //     uint256 price = 0;
    //     if (tokens[tokenId].createReferral != address(0) && runtimeChannelFees[0] > 0) {
    //         price += runtimeChannelFees[0];
    //     }

    //     if (withMintReferral && runtimeChannelFees[1] > 0) {
    //         price += runtimeChannelFees[1];
    //     }

    //     for (uint256 i = 0; i < constantChannelFees.length; i++) {
    //         price += constantChannelFees[i].amount;
    //     }

    //     return price;
    // }

    function getTokens(uint256 tokenId) public view returns (TokenConfig memory) {
        return tokens[tokenId];
    }

    // function getConstantFees() public view returns (FeePair[] memory) {
    //     return constantChannelFees;
    // }

    // function getRuntimeFees() public view returns (uint256[] memory) {
    //     return runtimeChannelFees;
    // }

    // function getChannelMintPrice() public view returns (uint256) {
    //     return channelMintFee;
    // }

    // modifier onlyAdmin(uint256 tokenId) {
    //     _requireAdmin(msg.sender, tokenId);
    //     _;
    // }
    // /// @notice Ensures the caller is authorized to upgrade the contract
    // /// @dev This function is called in `upgradeTo` & `upgradeToAndCall`
    // /// @param _newImpl The new implementation address

    function _authorizeUpgrade(address newImplementation) internal override {}

    // /// @notice Returns the current implementation address
    // function implementation() external view returns (address) {
    //     return _getImplementation();
    // }
}
