// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ERC1155 } from "openzeppelin-contracts/token/ERC1155/ERC1155.sol";
import { ERC20 } from "openzeppelin-contracts/token/ERC20/ERC20.sol";
import { ERC721 } from "openzeppelin-contracts/token/ERC721/ERC721.sol";

// Simple ERC20 token with minting capability for testing
contract MockERC20 is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) { }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

// Simple ERC721 token with minting capability for testing
contract MockERC721 is ERC721 {
    constructor(string memory name, string memory symbol) ERC721(name, symbol) { }

    function mint(address to, uint256 tokenId) public {
        _mint(to, tokenId);
    }
}

// Simple ERC1155 token with minting capability for testing
contract MockERC1155 is ERC1155 {
    constructor(string memory uri) ERC1155(uri) { }

    function mint(address to, uint256 id, uint256 amount, bytes memory data) public {
        _mint(to, id, amount, data);
    }
}
