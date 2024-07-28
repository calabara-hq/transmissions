// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { SignatureVerification } from "../libraries/SignatureVerification.sol";
import { console } from "forge-std/Test.sol";
import { SignatureCheckerLib } from "solady/utils/SignatureCheckerLib.sol";
/**
 * @title DeferredTokenAuthorization
 * @author nick
 * @notice EIP712 compliant signature verification for deferred token creation
 */

contract DeferredTokenAuthorization {
    /* -------------------------------------------------------------------------- */
    /*                                   ERRORS                                   */
    /* -------------------------------------------------------------------------- */
    error InvalidSignature();
    error SignatureExpired();

    /* -------------------------------------------------------------------------- */
    /*                                   CONSTANTS                                */
    /* -------------------------------------------------------------------------- */
    bytes32 public constant EIP712_DOMAIN_TYPEHASH =
        keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
    bytes32 public constant DEFERRED_TOKEN_TYPEHASH =
        keccak256("DeferredTokenPermission(string uri,uint256 maxSupply,uint256 deadline,bytes32 nonce)");

    /* -------------------------------------------------------------------------- */
    /*                                   STRUCTS                                  */
    /* -------------------------------------------------------------------------- */

    struct DeferredTokenPermission {
        string uri;
        uint256 maxSupply;
        uint256 deadline;
        bytes32 nonce;
    }

    /* -------------------------------------------------------------------------- */
    /*                                   STORAGE                                  */
    /* -------------------------------------------------------------------------- */

    bytes32 public DOMAIN_SEPARATOR;
    mapping(address => mapping(bytes32 => bool)) internal deferredTokenAuthorizations;

    /* -------------------------------------------------------------------------- */
    /*                          CONSTRUCTOR & INITIALIZER                         */
    /* -------------------------------------------------------------------------- */

    function __DeferredTokenAuthorization_init() internal {
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(EIP712_DOMAIN_TYPEHASH, keccak256("Transmissions"), keccak256("1"), block.chainid, address(this))
        );
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _validateDeferredTokenCreation(
        DeferredTokenPermission memory _token,
        address _author,
        bytes memory _signature
    )
        internal
        returns (bool)
    {
        if (block.timestamp >= _token.deadline) {
            revert SignatureExpired();
        }

        if (deferredTokenAuthorizations[_author][_token.nonce]) {
            revert InvalidSignature();
        } else {
            deferredTokenAuthorizations[_author][_token.nonce] = true;
        }

        bytes32 structHash = keccak256(
            abi.encode(
                DEFERRED_TOKEN_TYPEHASH, keccak256(bytes(_token.uri)), _token.maxSupply, _token.deadline, _token.nonce
            )
        );

        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR, structHash));

        //UniversalSigValidator.isValidSig(_author, digest, _signature);

        // if (_author != ecrecover(digest, _v, _r, _s)) {
        //   revert InvalidSignature();
        // }

        // verifiy the signature

        console.log("in here!");
        console.log("is contract", _author.code.length > 0);
        // if (!SignatureCheckerLib.isValidSignatureNow(_author, digest, _signature)) {
        //     revert InvalidSignature();
        // }

        SignatureVerification.verify(_signature, digest, _author);

        return true;
    }
}
