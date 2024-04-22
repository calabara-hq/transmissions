// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {console} from "forge-std/Test.sol";
import {ERC1155Upgradeable} from "openzeppelin-contracts-upgradeable/contracts/token/ERC1155/ERC1155Upgradeable.sol";
import {IChannel} from "../interfaces/IChannel.sol";
import {IChannelTypesV1} from "../interfaces/IChannelTypesV1.sol";
import {ChannelStorageV1} from "../storage/ChannelStorageV1.sol";
import {Escrow} from "../escrow/EscrowImpl.sol";
import {Multicall} from "../utils/Multicall.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {SharedBaseConstants} from "../shared/SharedBaseConstants.sol";
import {IFees} from "../fees/IFees.sol";
import {AccessControlUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import {ILogic, Logic} from "../logic/Logic.sol";

error CallFailed(bytes reason);



/// per token
contract TokenSale {
    struct SaleConfig {
        uint256 saleStart;
        uint256 saleEnd;
        address creator;
    }

    SaleConfig saleConfig;

    function setSaleConfig(bytes calldata saleArgs) internal {
        (address creator, uint256 saleStart, uint256 saleEnd) = abi.decode(
            saleArgs,
            (address, uint256, uint256)
        );

        saleConfig = SaleConfig({
            creator: creator,
            saleStart: saleStart,
            saleEnd: saleEnd
        });
    }
}

/// to make a sale, we check sale authorization, then create the token
/// to mint a sale, we check timing, mint authorization, then mint the token

// ERC1155Upgradeable,
contract Channel is
    IChannel,
    IChannelTypesV1,
    ChannelStorageV1,
    Escrow,
    Multicall,
    Initializable,
    ERC1155Upgradeable,
    UUPSUpgradeable,
    SharedBaseConstants,
    AccessControlUpgradeable
{
    IFees feeContract;
    ILogic logicContract;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor(address _platformRecipient) initializer {
        uplinkFeeAddress = _platformRecipient;
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   INITIALIZER
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    /// @notice initializer
    /// @param uri the uri for the token
    /// @param defaultAdmin the default admin for the channel
    /// @param managers privelaged managers for the channel
    /// @param setupActions the setup actions for the channel

    function initialize(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions
    ) external initializer {
        __ERC1155_init(uri);

        __UUPSUpgradeable_init();

        __AccessControl_init();

        /// temporarily set deployer as admin
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        /// grant the default admin role
        grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);

        /// set up the managers
        _setManagers(managers);

        /// set up the channel token with 0 supply
        _setupNewToken(uri, 0);

        if (setupActions.length > 0) {
            multicall(setupActions);
        }

        /// revoke admin for deployer
        _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /// @notice Modifier checking if the user is an admin or has a specific role
    /// @dev This reverts if the msg.sender is not an admin or role holder
    modifier onlyAdminOrManager() {
        _requireAdminOrManager(msg.sender);
        _;
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   EXTERNAL FUNCTIONS
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    
    function mintPrice() external view returns (uint256) {
        return feeContract.getMintPrice();
    }

    function channelFees() external view returns (uint256, uint256, uint256, uint256, uint256) {
        return feeContract.getChannelFeeConfig();
    }

    // access management functions

    function isManager(address addr) external returns (bool) {
        return hasRole(MANAGER_ROLE, addr) || hasRole(DEFAULT_ADMIN_ROLE, addr);
    }

    function isAdmin(address addr) external returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, addr);
    }

    function revokeManager(address addr) external onlyAdminOrManager {
        revokeRole(MANAGER_ROLE, addr);
    }

    // channel setters

    function setChannelFeeConfig(
        IFees _feeContract,
        bytes calldata data
    ) external onlyAdminOrManager {
        feeContract = _feeContract;
        feeContract.setChannelFeeConfig(data);
    }

    function setCreatorLogic(
        ILogic _logicContract,
        bytes calldata data
    ) external {
        logicContract = _logicContract;
        logicContract.setCreatorLogic(address(this), data);
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   PUBLIC FUNCTIONS
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */
    
    function _setManagers(address[] memory managers) public onlyAdminOrManager {
        for (uint256 i = 0; i < managers.length; i++) {
            grantRole(MANAGER_ROLE, managers[i]);
        }
    }

    /**
     * @notice Used to create a new token in the channel
     * Call the logic contract to check if the msg.sender is approved to create a new token
     * @param uri Token uri
     * @param author Token author
     * @param maxSupply Token supply
     * @return uint256 Id of newly created token
     */
    function createToken(
        string calldata uri,
        address author,
        uint256 maxSupply,
        bytes calldata saleArgs
    ) public returns (uint256) {
        bool isApproved = logicContract.isCreatorApproved(address(this), msg.sender);
        require(isApproved, "msg.sender not approved to create in this collection");
        return _setupNewToken(uri, maxSupply);
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   INTERNAL FUNCTIONS
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    function _requireAdminOrManager(address account) internal view {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, account) ||
                hasRole(MANAGER_ROLE, account),
            "Channel: must have admin or manager role"
        );
    }

    function _getAndUpdateNextTokenId() internal returns (uint256) {
        unchecked {
            return nextTokenId++;
        }
    }

    function _setupNewToken(
        string memory newURI,
        uint256 maxSupply
    ) internal returns (uint256 tokenId) {
        tokenId = _getAndUpdateNextTokenId();
        TokenConfig memory tokenConfig = TokenConfig({
            uri: newURI,
            maxSupply: maxSupply,
            totalMinted: 0
        });
        tokens[tokenId] = tokenConfig;
        return tokenId;
        //emit UpdatedToken(msg.sender, tokenId, tokenConfig);
    }


    // function mint(address minter, uint256 tokenId, uint256 amount, address mintReferral) external payable {
    //     // todo: checks for minting rules

    //     // deposit eth for create referral
    //     // deposit eth for creator
    //     // deposit eth for mint referral
    //     // deposit eth for uplink

    //     uint256 price = getTokenMintPrice(tokenId, mintReferral != address(0));
    //     require(msg.value == price, "Invalid eth amount for minting");

    //     // deposit constant fees
    //     for (uint256 i = 0; i < constantChannelFees.length; i++) {
    //         deposit(constantChannelFees[i].addr, constantChannelFees[i].amount);
    //     }

    //     // deposit runtime fees
    //     deposit(tokens[tokenId].author, runtimeChannelFees[0]);
    //     deposit(tokens[tokenId].createReferral, runtimeChannelFees[1]);
    //     deposit(mintReferral, runtimeChannelFees[2]);

    //     tokens[tokenId].totalMinted += amount;
    //     _mint(minter, tokenId, amount, "");
    // }

    // function getTokenMintPrice(uint256 tokenId, bool withMintReferral) public view returns (uint256) {
    //     uint256 price = 0;
    //     if (tokens[tokenId].createReferral != address(0) && runtimeChannelFees[0] > 0) {
    //         price += runtimeChannelFees[0];
    //     }

    //     if (withMintReferral && runtimeChannelFees[1] > 0) {
    //         price += runtimeChannelFees[1];
    //     }

    //     for (uint256 i = 0; i < constantChannelFees.length; i++) {
    //         price += constantChannelFees[i].amount;
    //     }

    //     return price;
    // }

    function getTokens(
        uint256 tokenId
    ) public view returns (TokenConfig memory) {
        return tokens[tokenId];
    }

    /// @notice Token info getter
    /// @param tokenId token id to get info for
    /// @return TokenConfig struct returned
    function getTokenInfo(
        uint256 tokenId
    ) external view returns (TokenConfig memory) {
        return tokens[tokenId];
    }

    // function getConstantFees() public view returns (FeePair[] memory) {
    //     return constantChannelFees;
    // }

    // function getRuntimeFees() public view returns (uint256[] memory) {
    //     return runtimeChannelFees;
    // }

    // function getChannelMintPrice() public view returns (uint256) {
    //     return channelMintFee;
    // }

    // modifier onlyAdmin(uint256 tokenId) {
    //     _requireAdmin(msg.sender, tokenId);
    //     _;
    // }
    // /// @notice Ensures the caller is authorized to upgrade the contract
    // /// @dev This function is called in `upgradeTo` & `upgradeToAndCall`
    // /// @param _newImpl The new implementation address

    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        virtual
        override(ERC1155Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _authorizeUpgrade(address newImplementation) internal override {}

    // /// @notice Returns the current implementation address
    // function implementation() external view returns (address) {
    //     return _getImplementation();
    // }
}
