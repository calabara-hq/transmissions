// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {Script} from "forge-std/Script.sol";
/// @author nick
/// adapted from zora-protocol/protocol-deployments

struct ChainConfig {
    address owner;
    address platformRecipient;
}

struct Deployment {
    address customFees;
    address baseLogic;
    address infiniteTiming;
    address channelImpl;
    address factoryImpl;
    address factoryProxy;
    address upgradePath;
}

abstract contract DeployConfig is Script {
    using stdJson for string;

    /// @notice ChainID convenience getter
    /// @return id chainId
    function chainId() internal view virtual returns (uint256 id);

    string constant OWNER = "OWNER";
    string constant PLATFORM_RECIPIENT = "PLATFORM_RECIPIENT";

    string constant CUSTOM_FEES = "CUSTOM_FEES";
    string constant BASE_LOGIC = "BASE_LOGIC";
    string constant INFINITE_TIMING = "INFINITE_TIMING";
    string constant CHANNEL_IMPL = "CHANNEL_IMPL";
    string constant FACTORY_IMPL = "FACTORY_IMPL";
    string constant FACTORY_PROXY = "FACTORY_PROXY";
    string constant UPGRADE_PATH = "UPGRADE_PATH";

    /// @notice Return a prefixed key for reading with a ".".
    /// @param key key to prefix
    /// @return prefixed key
    function getKeyPrefix(string memory key) internal pure returns (string memory) {
        return string.concat(".", key);
    }

    function readAddressOrDefaultToZero(string memory json, string memory key) internal view returns (address addr) {
        string memory keyPrefix = getKeyPrefix(key);

        if (vm.keyExists(json, keyPrefix)) {
            addr = json.readAddress(keyPrefix);
        } else {
            addr = address(0);
        }
    }

    /// @notice Returns the chain configuration struct from the JSON configuration file
    /// @return chainConfig structure
    function getChainConfig() internal view returns (ChainConfig memory chainConfig) {
        string memory json = vm.readFile(string.concat("deploy/chainConfigs/", Strings.toString(chainId()), ".json"));
        chainConfig.owner = json.readAddress(getKeyPrefix(OWNER));
        chainConfig.platformRecipient = json.readAddress(getKeyPrefix(PLATFORM_RECIPIENT));
    }

    /// @notice Get the deployment configuration struct from the JSON configuration file
    /// @return deployment deployment configuration structure
    function getDeployment() internal view returns (Deployment memory deployment) {
        string memory json = vm.readFile(string.concat("deploy/addresses/", Strings.toString(chainId()), ".json"));
        deployment.customFees = readAddressOrDefaultToZero(json, CUSTOM_FEES);
        deployment.baseLogic = readAddressOrDefaultToZero(json, BASE_LOGIC);
        deployment.infiniteTiming = readAddressOrDefaultToZero(json, INFINITE_TIMING);
        deployment.channelImpl = readAddressOrDefaultToZero(json, CHANNEL_IMPL);
        deployment.factoryImpl = readAddressOrDefaultToZero(json, FACTORY_IMPL);
        deployment.factoryProxy = readAddressOrDefaultToZero(json, FACTORY_PROXY);
        deployment.upgradePath = readAddressOrDefaultToZero(json, UPGRADE_PATH);
    }
}

contract ForkDeploymentConfig is DeployConfig {
    function chainId() internal view override returns (uint256 id) {
        return block.chainid;
    }
}

contract ScriptDeploymentConfig is DeployConfig {
    function chainId() internal view override returns (uint256 id) {
        assembly {
            id := chainid()
        }
    }
}
