// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ChannelStorageV1} from "./ChannelStorageV1.sol";

import {ERC1155Upgradeable} from "openzeppelin-contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import {ERC1155} from "openzeppelin-contracts/token/ERC1155/ERC1155.sol";
import {Multicall} from "../utils/Multicall.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {IFees} from "../fees/CustomFees.sol";
import {AccessControlUpgradeable} from "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {AccessControl} from "openzeppelin-contracts/access/AccessControl.sol";
import {ILogic} from "../logic/Logic.sol";
import {IUpgradePath, UpgradePath} from "../utils/UpgradePath.sol";
import {ERC1967Utils} from "openzeppelin-contracts/proxy/ERC1967/ERC1967Utils.sol";
import {ReentrancyGuardUpgradeable} from "openzeppelin-contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

contract ChannelV2 is ChannelStorageV1, Multicall, ERC1155Upgradeable, UUPSUpgradeable, AccessControlUpgradeable {
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bool private _initialized;

    /// @notice Modifier checking if the user is an admin or has a specific role
    /// @dev This reverts if the msg.sender is not an admin or role holder

    modifier onlyAdminOrManager() {
        _requireAdminOrManager(msg.sender);
        _;
    }

    /* -------------------------------------------------------------------------- */
    /*                                INITIALIZER                                 */
    /* -------------------------------------------------------------------------- */
    function _initializeChannel(
        string calldata _uri,
        address _defaultAdmin,
        address[] calldata _managers,
        bytes[] calldata _setupActions
    ) internal {
        require(!_initialized, "Channel: already initialized");

        __ERC1155_init(_uri);

        __UUPSUpgradeable_init();

        __AccessControl_init();

        /// temporarily set factory deployer as admin
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        /// grant the default admin role
        grantRole(DEFAULT_ADMIN_ROLE, _defaultAdmin);

        /// set up the managers
        _setManagers(_managers);

        /// set up the channel token
        _setupNewToken(_uri, 0, ERC1967Utils.getImplementation());

        if (_setupActions.length > 0) {
            multicall(_setupActions);
        }

        /// revoke admin for deployer
        _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);

        _initialized = true;
    }

    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function createToken(string memory newURI, uint256 maxSupply) external virtual returns (uint256) {}

    function mint(address to, uint256 tokenId, uint256 amount, address mintReferral, bytes memory data)
        external
        payable
        virtual
    {}

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _getAndUpdateNextTokenId() internal returns (uint256) {
        unchecked {
            return nextTokenId++;
        }
    }

    function _setManagers(address[] memory managers) public onlyAdminOrManager {
        for (uint256 i = 0; i < managers.length; i++) {
            grantRole(MANAGER_ROLE, managers[i]);
        }
    }

    function _requireAdminOrManager(address account) internal view {
        if (!hasRole(DEFAULT_ADMIN_ROLE, account) && !hasRole(MANAGER_ROLE, account)) {
            // todo revert Unauthorized();
        }
    }

    function _setupNewToken(string memory newURI, uint256 maxSupply, address author) internal returns (uint256) {
        uint256 tokenId = _getAndUpdateNextTokenId();

        TokenConfig memory tokenConfig =
            TokenConfig({uri: newURI, maxSupply: maxSupply, totalMinted: 0, author: author, sponsor: msg.sender});
        tokens[tokenId] = tokenConfig;

        //todo    emit TokenCreated(tokenId, tokenConfig);

        return tokenId;
    }

    function _authorizeUpgrade(address newImplementation) internal view override {
        /*       if (!upgradePath.isRegisteredUpgradePath(_implementation(), newImplementation)) {
                    revert InvalidUpgrade();
        } */
    }
}
