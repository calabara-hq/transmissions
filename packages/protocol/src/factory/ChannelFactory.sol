// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IChannel } from "../channel/Channel.sol";
import { IChannelFactory } from "../interfaces/IChannelFactory.sol";
import { IVersionedContract } from "../interfaces/IVersionedContract.sol";

import { InfiniteUplink1155 } from "../proxies/InfiniteUplink1155.sol";
import { OwnableUpgradeable } from "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";
import { Initializable } from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░))░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░)))))))░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░))))))))))░░░░ *
 * ░░░░░░░░░░░░░░)))))░░░░░░░)))))))))))░░░ *
 * ░░░░░░░░░░░░)))))))))░░░░░░)))))))))))░░ *
 * ░░░░░░░░░░░░))))))))))░░░░░░))))))))))░░ *
 * ░░░░░░░░░░░░░)))))))))))░░░░░))))))))))░ *
 * ░))))))░░░░░░░░))))))))))░░░░░)))))))))░ *
 * ░))))))))░░░░░░░)))))))))░░░░░░))))))))) *
 * ░░)))))))))░░░░░░)))))))))░░░░░))))))))) *
 * ░░░))))))))░░░░░░)))))))))░░░░░))))))))) *
 * ░)))))))))░░░░░░)))))))))░░░░░░))))))))) *
 * ))))))))░░░░░░░))))))))))░░░░░)))))))))) *
 * ░░░░░░░░░░░░░░))))))))))░░░░░░)))))))))░ *
 * ░░░░░░░░░░░░)))))))))))░░░░░░))))))))))░ *
 * ░░░░░░░░░░░░))))))))))░░░░░░))))))))))░░ *
 * ░░░░░░░░░░░░░)))))))░░░░░░░))))))))))░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░))))))))))░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░))))))))░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░)))))░░░░░░░ *
 *
 */
contract ChannelFactory is IChannelFactory, Initializable, OwnableUpgradeable, UUPSUpgradeable {
    address public immutable infiniteChannelImpl;

    constructor(address _infiniteChannelImpl) initializer {
        if (_infiniteChannelImpl == address(0)) {
            revert AddressZero();
        }
        infiniteChannelImpl = _infiniteChannelImpl;
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   EXTERNAL FUNCTIONS
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   PUBLIC FUNCTIONS
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    /**
     * @notice Factory initializer
     * @param _initOwner address of the owner
     */
    function initialize(address _initOwner) public initializer {
        __Ownable_init(_initOwner);
        __UUPSUpgradeable_init();
        emit FactoryInitialized();
    }

    /**
     * @notice Create a new infinite channel
     * @param uri string URI for the channel
     * @param defaultAdmin address default admin
     * @param managers address[] channel managers
     * @param setupActions bytes[] setup actions
     * @param timing bytes timing data
     * @return address deployed contract address
     */
    function createInfiniteChannel(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions,
        bytes calldata timing
    )
        external
        returns (address)
    {
        InfiniteUplink1155 newContract = new InfiniteUplink1155(infiniteChannelImpl);
        _initializeContract(address(newContract), uri, defaultAdmin, managers, setupActions, timing);
        return address(newContract);
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   INTERNAL FUNCTIONS
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    /**
     * @notice Authorize factory upgrade
     * @param newImplementation address of the new implementation
     */
    function _authorizeUpgrade(address newImplementation) internal view override onlyOwner {
        string memory newName = IChannelFactory(newImplementation).contractName();
        string memory oldName = IChannelFactory(address(this)).contractName();
        if (keccak256(abi.encodePacked(newName)) != keccak256(abi.encodePacked(oldName))) {
            revert InvalidUpgrade();
        }
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   PRIVATE FUNCTIONS
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    /**
     * @notice Internal helper to deploy a new channel
     * @param newContract address of the new contract
     * @param uri string URI for the channel
     * @param defaultAdmin address default admin
     * @param managers address[] channel managers
     * @param setupActions bytes[] setup actions
     * @param timing bytes timing data
     */
    function _initializeContract(
        address newContract,
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions,
        bytes calldata timing
    )
        private
    {
        emit SetupNewContract(newContract, uri, defaultAdmin, managers, timing);
        IChannel(newContract).initialize(uri, defaultAdmin, managers, setupActions, timing);
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
        return "Uplink Channel Factory";
    }
}