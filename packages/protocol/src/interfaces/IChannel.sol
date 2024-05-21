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
    event TokenMinted(address indexed minter, address indexed mintReferral, uint256[] tokenIds, uint256[] amounts);

    event TokenURIUpdated(uint256 indexed tokenId, string uri);
    event ConfigUpdated(
        address indexed updater, ConfigUpdate indexed updateType, address feeContract, address logicContract
    );

    function initialize(
        string memory newContractURI,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions,
        bytes calldata timing
    )
        external;

    function setFees(address fees, bytes calldata data) external;
    function setLogic(address logic, bytes calldata creatorLogic, bytes calldata minterLogic) external;
    function setTiming(bytes calldata data) external;
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
        bytes memory data,
        address mintReferral
    )
        external
        payable;
    function mintBatchWithERC20(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data,
        address mintReferral
    )
        external
        payable;
}
