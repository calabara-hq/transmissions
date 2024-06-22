// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// FOR TEST PURPOSES ONLY. NOT PRODUCTION SAFE

import { DeferredTokenAuthorization } from "../../src/utils/DeferredTokenAuthorization.sol";

contract SigUtils {
  bytes32 public constant EIP712_DOMAIN_TYPEHASH =
    keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

  bytes32 DEFERRED_TOKEN_TYPEHASH =
    keccak256("DeferredTokenPermission(string uri,uint256 maxSupply,uint256 deadline,bytes32 nonce)");

  bytes32 public DOMAIN_SEPARATOR;

  constructor(string memory _name, string memory _version, uint256 _chainId, address _verifyingContract) {
    DOMAIN_SEPARATOR = keccak256(
      abi.encode(
        EIP712_DOMAIN_TYPEHASH,
        keccak256(bytes(_name)),
        keccak256(bytes(_version)),
        _chainId,
        _verifyingContract
      )
    );
  }

  function getStructHash(
    DeferredTokenAuthorization.DeferredTokenPermission memory token
  ) public view returns (bytes32) {
    return
      keccak256(
        abi.encode(DEFERRED_TOKEN_TYPEHASH, keccak256(bytes(token.uri)), token.maxSupply, token.deadline, token.nonce)
      );
  }

  function getTypedDataHash(
    DeferredTokenAuthorization.DeferredTokenPermission memory token
  ) public view returns (bytes32) {
    return keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, getStructHash(token)));
  }
}
