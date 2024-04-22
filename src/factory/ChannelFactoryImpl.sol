// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC1155} from "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {IChannelFactory} from "./IChannelFactory.sol";
import {Channel} from "../channel/ChannelImpl.sol";
import {IChannel} from "../interfaces/IChannel.sol";
import {IChannelTypesV1} from "../interfaces/IChannelTypesV1.sol";
import {ChannelFactoryStorageV1} from "./ChannelFactoryStorageV1.sol";
import {Uplink1155} from "../proxies/Uplink1155.sol";
import {IChannelInitializer} from "../channel/IChannelInitializer.sol";
import {ContractVersion} from "../version/ContractVersion.sol";
import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";

contract ChannelFactory is
    IChannelFactory,
    ChannelFactoryStorageV1,
    Initializable,
    OwnableUpgradeable,
    UUPSUpgradeable,
    ContractVersion
{
    IChannel public immutable channelImpl;

    constructor(IChannel _channelImpl) initializer {
        if (address(_channelImpl) == address(0)) {
            revert("ChannelFactory: Invalid Channel Implementation");
        }
        channelImpl = _channelImpl;
    }

    function initialize(address _initOwner) public initializer {
        __Ownable_init(_initOwner);
        __UUPSUpgradeable_init();
    }

    /// External Functions ///

    function contractURI() external pure returns (string memory) {
        return "https://github.com/calabara-hq/transmissions/";
    }

    function contractName() external pure returns (string memory) {
        return "Uplink Channel Factory";
    }

    /// Public Functions ///

    function createChannel(
        string calldata uri,
        bytes[] calldata setupActions
    ) public returns (address) {
        Uplink1155 newContract = new Uplink1155(address(channelImpl));
        _initializeContract(Uplink1155(newContract), uri, setupActions);
        return address(newContract);
    }

    /// Internal Functions ///

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    /// Private Functions ///

    function _initializeContract(
        Uplink1155 newContract,
        string calldata uri,
        bytes[] calldata setupActions
    ) private {
        IChannelInitializer(address(newContract)).initialize(uri, setupActions);
        deployedChannels.push(address(newContract));
    }

}
