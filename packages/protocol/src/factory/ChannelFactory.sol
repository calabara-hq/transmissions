// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IChannel } from "../channel/Channel.sol";
import { IChannelFactory } from "../interfaces/IChannelFactory.sol";

import { FiniteChannel } from "../channel/transport/FiniteChannel.sol";

import { NativeTokenLib } from "../libraries/NativeTokenLib.sol";
import { FiniteUplink1155 } from "../proxies/FiniteUplink1155.sol";
import { InfiniteUplink1155 } from "../proxies/InfiniteUplink1155.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { OwnableUpgradeable } from "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";
import { Initializable } from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { IERC20 } from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import { SafeTransferLib } from "solady/utils/SafeTransferLib.sol";
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

/**
 * @title Channel Factory
 * @author nick
 * @notice Factory contract to deploy new channels
 */
contract ChannelFactory is IChannelFactory, Initializable, OwnableUpgradeable, UUPSUpgradeable {
  using SafeERC20 for IERC20;
  using NativeTokenLib for address;
  using SafeTransferLib for address;

  /* -------------------------------------------------------------------------- */
  /*                                   ERRORS                                   */
  /* -------------------------------------------------------------------------- */

  error AddressZero();
  error InvalidUpgrade();
  error ERC20TransferFailed();

  /* -------------------------------------------------------------------------- */
  /*                                   EVENTS                                   */
  /* -------------------------------------------------------------------------- */
  event FactoryInitialized();
  event SetupNewContract(
    address indexed contractAddress,
    string uri,
    string name,
    address defaultAdmin,
    address[] managers,
    bytes transportConfig
  );

  /* -------------------------------------------------------------------------- */
  /*                                   STORAGE                                  */
  /* -------------------------------------------------------------------------- */

  address public immutable infiniteChannelImpl;
  address public immutable finiteChannelImpl;

  /* -------------------------------------------------------------------------- */
  /*                          CONSTRUCTOR & INITIALIZER                         */
  /* -------------------------------------------------------------------------- */

  constructor(address _infiniteChannelImpl, address _finiteChannelImpl) initializer {
    if (_infiniteChannelImpl == address(0) || _finiteChannelImpl == address(0)) {
      revert AddressZero();
    }
    infiniteChannelImpl = _infiniteChannelImpl;
    finiteChannelImpl = _finiteChannelImpl;
  }

  /**
   * @notice Factory initializer
   * @param _initOwner address of the owner
   */
  function initialize(address _initOwner) public initializer {
    __Ownable_init(_initOwner);
    __UUPSUpgradeable_init();
    emit FactoryInitialized();
  }

  /* -------------------------------------------------------------------------- */
  /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
  /* -------------------------------------------------------------------------- */
  /**
   * @notice Create a new infinite channel
   * @param uri string URI for the channel
   * @param name string name for the channel
   * @param defaultAdmin address of default admin
   * @param managers address[] channel managers
   * @param setupActions bytes[] setup actions
   * @param transportConfig bytes transport config
   * @return address deployed contract address
   */
  function createInfiniteChannel(
    string calldata uri,
    string calldata name,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
  ) external returns (address) {
    address newContract = address(new InfiniteUplink1155(infiniteChannelImpl));
    _initializeContract(newContract, uri, name, defaultAdmin, managers, setupActions, transportConfig);
    return newContract;
  }

  /**
   * @notice Create a new finite channel
   * @param uri string URI for the channel
   * @param name string name for the channel
   * @param defaultAdmin address of default admin
   * @param managers address[] channel managers
   * @param setupActions bytes[] setup actions
   * @param transportConfig bytes transport config
   * @return address deployed contract address
   */
  function createFiniteChannel(
    string calldata uri,
    string calldata name,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
  ) external payable returns (address) {
    address newContract = address(new FiniteUplink1155(finiteChannelImpl));

    FiniteChannel.FiniteParams memory params = abi.decode(transportConfig, (FiniteChannel.FiniteParams));
    if (params.rewards.token.isNativeToken()) {
      if (!newContract.trySafeTransferETH(msg.value, SafeTransferLib.GAS_STIPEND_NO_STORAGE_WRITES)) {
        revert("ETH transfer failed");
      }
    } else {
      uint256 beforeBalance = IERC20(params.rewards.token).balanceOf(address(this));
      IERC20(params.rewards.token).safeTransferFrom(msg.sender, address(this), params.rewards.totalAllocation);
      uint256 afterBalance = IERC20(params.rewards.token).balanceOf(address(this));

      if (beforeBalance + params.rewards.totalAllocation != afterBalance) {
        revert ERC20TransferFailed();
      }

      IERC20(params.rewards.token).approve(newContract, params.rewards.totalAllocation);
    }

    _initializeContract(newContract, uri, name, defaultAdmin, managers, setupActions, transportConfig);

    return newContract;
  }

  /* -------------------------------------------------------------------------- */
  /*                             INTERNAL FUNCTIONS                             */
  /* -------------------------------------------------------------------------- */
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

  /* -------------------------------------------------------------------------- */
  /*                              PRIVATE FUNCTIONS                             */
  /* -------------------------------------------------------------------------- */
  /**
   * @notice Internal helper to deploy a new channel
   * @param newContract address of the new contract
   * @param uri string URI for the channel
   * @param name string name for the channel
   * @param defaultAdmin address default admin
   * @param managers address[] channel managers
   * @param setupActions bytes[] setup actions
   * @param transportConfig bytes transportConfig
   */
  function _initializeContract(
    address newContract,
    string calldata uri,
    string calldata name,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
  ) private {
    emit SetupNewContract(newContract, uri, name, defaultAdmin, managers, transportConfig);
    IChannel(newContract).initialize(uri, name, defaultAdmin, managers, setupActions, transportConfig);
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
   * @notice Returns the contract source code repository
   * @return string repository uri
   */
  function codeRepository() external pure returns (string memory) {
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
