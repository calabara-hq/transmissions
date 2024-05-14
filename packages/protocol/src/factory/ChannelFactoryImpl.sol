// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IChannel} from "../channel/Channel.sol";
import {ChannelFactoryStorageV1} from "./ChannelFactoryStorageV1.sol";
import {Uplink1155} from "../proxies/Uplink1155.sol";
import {IChannelInitializer} from "../channel/IChannelInitializer.sol";
import {ContractVersion} from "../version/ContractVersion.sol";
import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

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
interface IChannelFactory {
    event SetupNewContract(address indexed contractAddress, string uri, address defaultAdmin, address[] managers);
    event FactoryInitialized();

    function contractURI() external pure returns (string memory);
    function contractName() external pure returns (string memory);

    error AddressZero();
    error InvalidUpgrade();
}

contract ChannelFactory is
    IChannelFactory,
    ChannelFactoryStorageV1,
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    ContractVersion
{
    constructor(IChannel _channelImpl) initializer {
        if (address(_channelImpl) == address(0)) {
            revert AddressZero();
        }
        channelImpl = _channelImpl;
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   EXTERNAL FUNCTIONS
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    /**
     * @notice Returns the contract uri
     * @return string contract uri
     */
    function contractURI() external pure returns (string memory) {
        return "https://github.com/calabara-hq/transmissions/";
    }

    /**
     * @notice Returns the contract name
     * @return string contract name
     */
    function contractName() external pure returns (string memory) {
        return "Uplink Channel Factory";
    }

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
     * @notice Create a new channel
     * @param uri string URI for the channel
     * @param defaultAdmin address default admin
     * @param managers address[] channel managers
     * @param setupActions bytes[] setup actions
     * @return address deployed contract address
     */
    function createChannel(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions
    ) public returns (address) {
        Uplink1155 newContract = new Uplink1155(address(channelImpl));
        _initializeContract(newContract, uri, defaultAdmin, managers, setupActions);
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
     */
    function _initializeContract(
        Uplink1155 newContract,
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions
    ) private {
        emit SetupNewContract(address(newContract), uri, defaultAdmin, managers);
        IChannelInitializer(address(newContract)).initialize(uri, defaultAdmin, managers, setupActions);
    }
}
