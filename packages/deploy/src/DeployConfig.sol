// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { Script } from "forge-std/Script.sol";
import "forge-std/Test.sol";
/// @author nick
/// adapted from zora-protocol/protocol-deployments

struct ChainConfig {
    address owner;
    address uplinkRewardsAddress;
    address weth;
}

struct Deployment {
    address customFees;
    address dynamicLogic;
    address infiniteChannelImpl;
    address finiteChannelImpl;
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
    string constant UPLINK_REWARDS_ADDRESS = "UPLINK_REWARDS_ADDRESS";
    string constant WETH = "WETH";

    string constant CUSTOM_FEES = "CUSTOM_FEES";
    string constant DYNAMIC_LOGIC = "DYNAMIC_LOGIC";

    string constant INFINITE_CHANNEL_IMPL = "INFINITE_CHANNEL_IMPL";
    string constant FINITE_CHANNEL_IMPL = "FINITE_CHANNEL_IMPL";

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
        string memory json = vm.readFile(string.concat("chainConfigs/", Strings.toString(chainId()), ".json"));
        chainConfig.owner = json.readAddress(getKeyPrefix(OWNER));
        chainConfig.uplinkRewardsAddress = json.readAddress(getKeyPrefix(UPLINK_REWARDS_ADDRESS));
        chainConfig.weth = json.readAddress(getKeyPrefix(WETH));
    }

    /// @notice Get the deployment configuration struct from the JSON configuration file
    /// @return deployment deployment configuration structure
    function getDeployment() internal view returns (Deployment memory deployment) {
        string memory json = vm.readFile(string.concat("addresses/", Strings.toString(chainId()), ".json"));

        deployment.customFees = readAddressOrDefaultToZero(json, CUSTOM_FEES);
        deployment.dynamicLogic = readAddressOrDefaultToZero(json, DYNAMIC_LOGIC);

        deployment.infiniteChannelImpl = readAddressOrDefaultToZero(json, INFINITE_CHANNEL_IMPL);
        deployment.finiteChannelImpl = readAddressOrDefaultToZero(json, FINITE_CHANNEL_IMPL);

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
