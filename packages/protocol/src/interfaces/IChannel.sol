// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ChannelStorage } from "../channel/ChannelStorage.sol";

interface IChannel {
    error FALSY_LOGIC();
    error NotMintable();
    error SoldOut();
    error InvalidAmount();
    error InvalidValueSent();
    error DepositMismatch();
    error ADDRESS_ZERO();

    enum ConfigUpdate {
        FEE_CONTRACT,
        LOGIC_CONTRACT
    }

    event TokenCreated(uint256 indexed tokenId, ChannelStorage.TokenConfig token);
    event TokenMinted(
        address indexed minter, address indexed mintReferral, uint256[] tokenIds, uint256[] amounts, bytes data
    );

    event TokenURIUpdated(uint256 indexed tokenId, string uri);
    event ConfigUpdated(
        address indexed updater, ConfigUpdate indexed updateType, address feeContract, address logicContract
    );

    function getToken(uint256 tokenId) external view returns (ChannelStorage.TokenConfig memory);

    function initialize(
        string memory uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions,
        bytes calldata transportConfig
    )
        external
        payable;

    function setFees(address fees, bytes calldata data) external;
    function setLogic(address logic, bytes calldata creatorLogic, bytes calldata minterLogic) external;
    function updateChannelTokenUri(string calldata uri) external;
    function createToken(string calldata uri, address author, uint256 maxSupply) external returns (uint256 tokenId);
    function mint(
        address to,
        uint256 tokenId,
        uint256 amount,
        address mintReferral,
        bytes memory data
    )
        external
        payable;
    function mintWithERC20(
        address to,
        uint256 tokenId,
        uint256 amount,
        address mintReferral,
        bytes memory data
    )
        external
        payable;
    function mintBatchWithETH(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        address mintReferral,
        bytes memory data
    )
        external
        payable;
    function mintBatchWithERC20(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        address mintReferral,
        bytes memory data
    )
        external
        payable;
}
