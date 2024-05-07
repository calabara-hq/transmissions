// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC1155Upgradeable} from "openzeppelin-contracts-upgradeable/contracts/token/ERC1155/ERC1155Upgradeable.sol";
import {ChannelStorageV1} from "./ChannelStorageV1.sol";
import {Multicall} from "../utils/Multicall.sol";
import {Initializable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol";
import {IFees} from "../fees/CustomFees.sol";
import {AccessControlUpgradeable} from
    "openzeppelin-contracts-upgradeable/contracts/access/AccessControlUpgradeable.sol";
import {ILogic} from "../logic/Logic.sol";
import {IUpgradePath, UpgradePath} from "../utils/UpgradePath.sol";
import {ERC1967Utils} from "openzeppelin-contracts/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {ITiming} from "../timing/InfiniteRound.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {ReentrancyGuardUpgradeable} from
    "openzeppelin-contracts-upgradeable/contracts/utils/ReentrancyGuardUpgradeable.sol";

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
interface IChannel {
    function initialize(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions
    ) external;

    enum ConfigUpdate {
        FEE_CONTRACT,
        LOGIC_CONTRACT,
        TIMING_CONTRACT
    }

    event ConfigUpdated(
        ConfigUpdate indexed updateType, address feeContract, address logicContract, address timingContract
    );
    event TokenCreated(uint256 indexed tokenId, ChannelStorageV1.TokenConfig token);
    event TokenMinted(address indexed minter, address indexed mintReferral, uint256[] tokenIds, uint256[] amounts);
    event ERC20Transferred(address indexed spender, uint256 amount);
    event ETHTransferred(address indexed spender, uint256 amount);
    event TokenURIUpdated(uint256 indexed tokenId, string uri);

    function setChannelFeeConfig(address feeContract, bytes calldata data) external;
    function setLogic(address _logicContract, bytes calldata creatorLogic, bytes calldata minterLogic) external;
    function setTimingConfig(address saleContract, bytes calldata data) external;

    error FalsyLogic();
    error Unauthorized();
    error InvalidChannelState();
    error NotMintable();
    error SoldOut();
    error InvalidAmount();
    error InvalidValueSent();
    error DepositMismatch();
    error AddressZero();
    error InvalidUpgrade();
    error TransferFailed();
}

contract Channel is
    IChannel,
    ChannelStorageV1,
    Multicall,
    Initializable,
    ERC1155Upgradeable,
    UUPSUpgradeable,
    AccessControlUpgradeable,
    ReentrancyGuardUpgradeable
{
    using SafeERC20 for IERC20;

    IUpgradePath internal immutable upgradePath;

    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");

    constructor(address _upgradePath) initializer {
        upgradePath = UpgradePath(_upgradePath);
    }

    /**
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     *   INITIALIZER
     * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
     */

    /// @notice initializer
    /// @param uri the uri for the channel token
    /// @param defaultAdmin the default admin for the channel
    /// @param managers privelaged managers for the channel
    /// @param setupActions the setup actions for the channel

    function initialize(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions
    ) external nonReentrant initializer {
        __ERC1155_init(uri);

        __UUPSUpgradeable_init();

        __AccessControl_init();

        /// temporarily set factory deployer as admin
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        /// grant the default admin role
        grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);

        /// set up the managers
        _setManagers(managers);

        /// set up the channel token
        _setupNewToken(uri, 0, ERC1967Utils.getImplementation());

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

    // access management functions

    function isManager(address addr) external view returns (bool) {
        return hasRole(MANAGER_ROLE, addr) || hasRole(DEFAULT_ADMIN_ROLE, addr);
    }

    function isAdmin(address addr) external view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, addr);
    }

    function revokeManager(address addr) external onlyAdminOrManager {
        revokeRole(MANAGER_ROLE, addr);
    }

    // channel setters

    function setChannelFeeConfig(address _feeContract, bytes calldata data) external onlyAdminOrManager {
        if (_feeContract == address(0)) {
            revert AddressZero();
        }

        feeContract = IFees(_feeContract);
        feeContract.setChannelFeeConfig(data);

        emit ConfigUpdated(
            ConfigUpdate.FEE_CONTRACT, address(feeContract), address(logicContract), address(timingContract)
        );
    }

    function setLogic(address _logicContract, bytes calldata creatorLogic, bytes calldata minterLogic)
        external
        onlyAdminOrManager
    {
        if (_logicContract == address(0)) {
            revert AddressZero();
        }

        logicContract = ILogic(_logicContract);
        logicContract.setCreatorLogic(creatorLogic);
        logicContract.setMinterLogic(minterLogic);

        emit ConfigUpdated(
            ConfigUpdate.LOGIC_CONTRACT, address(feeContract), address(logicContract), address(timingContract)
        );
    }

    /**
     * @notice Used to set the timing parameters for the channel
     * @param _timingContract Timing contract address
     * @param data Timing contract config data
     */
    function setTimingConfig(address _timingContract, bytes calldata data) external onlyAdminOrManager {
        if (_timingContract == address(0)) {
            revert AddressZero();
        }

        timingContract = ITiming(_timingContract);
        timingContract.setTimingConfig(data);

        emit ConfigUpdated(
            ConfigUpdate.TIMING_CONTRACT, address(feeContract), address(logicContract), address(timingContract)
        );
    }

    function ethMintPrice() public view returns (uint256) {
        return feeContract.getEthMintPrice();
    }

    function erc20MintPrice() public view returns (uint256) {
        return feeContract.getErc20MintPrice();
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC1155Upgradeable, AccessControlUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function _setManagers(address[] memory managers) public onlyAdminOrManager {
        for (uint256 i = 0; i < managers.length; i++) {
            grantRole(MANAGER_ROLE, managers[i]);
        }
    }

    /**
     * @notice Used to get the token details
     * @param tokenId Token id
     * @return TokenConfig Token details
     */
    function getToken(uint256 tokenId) public view returns (TokenConfig memory) {
        return tokens[tokenId];
    }

    /**
     * @notice Used to create a new token in the channel
     * Call the logic contract to check if the msg.sender is approved to create a new token
     * @param uri Token uri
     * @param author Token author
     * @param maxSupply Token supply
     * @return uint256 Id of newly created token
     */
    function createToken(string calldata uri, address author, uint256 maxSupply)
        public
        nonReentrant
        returns (uint256)
    {
        if (timingContract.getChannelState() != 1) {
            revert InvalidChannelState();
        }

        uint256 tokenId = _setupNewToken(uri, maxSupply, author);
        timingContract.setTokenSale(tokenId);

        _validateCreatorLogic(msg.sender);

        return tokenId;
    }

    /**
     * @notice Used to update the default channel token uri
     * @param uri Token uri
     */
    function updateChannelTokenUri(string calldata uri) external onlyAdminOrManager {
        tokens[0].uri = uri;
        emit TokenURIUpdated(0, uri);
    }

    function _requireAdminOrManager(address account) internal view {
        if (!hasRole(DEFAULT_ADMIN_ROLE, account) && !hasRole(MANAGER_ROLE, account)) {
            revert Unauthorized();
        }
    }

    function _getAndUpdateNextTokenId() internal returns (uint256) {
        unchecked {
            return nextTokenId++;
        }
    }

    function _setupNewToken(string memory newURI, uint256 maxSupply, address author) internal returns (uint256) {
        uint256 tokenId = _getAndUpdateNextTokenId();

        TokenConfig memory tokenConfig =
            TokenConfig({uri: newURI, maxSupply: maxSupply, totalMinted: 0, author: author, sponsor: msg.sender});
        tokens[tokenId] = tokenConfig;

        emit TokenCreated(tokenId, tokenConfig);

        return tokenId;
    }

    function _checkMintRequirements(TokenConfig memory token, uint256 tokenId, uint256 amount) internal view {
        require(token.maxSupply > 0, "Token is not mintable");
        require(token.totalMinted < token.maxSupply, "Token is sold out");
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= token.maxSupply - token.totalMinted, "Amount exceeds max supply");
        require(timingContract.getTokenSaleState(tokenId) == 1, "Token sale not active");
    }

    function _validateCreatorLogic(address creator) internal view returns (bool) {
        bool isApproved = logicContract.isCreatorApproved(creator);
        if (!isApproved) {
            revert FalsyLogic();
        }
    }

    function _validateMinterLogic(address minter) internal view returns (bool) {
        bool isApproved = logicContract.isMinterApproved(minter);
        if (!isApproved) {
            revert FalsyLogic();
        }
    }

    /**
     * @notice mint a token in the channel
     * @param to address to mint to
     * @param tokenId token id to mint
     * @param amount amount to mint
     * @param mintReferral referral address for minting
     * @param data mint data
     */
    function mint(address to, uint256 tokenId, uint256 amount, address mintReferral, bytes memory data)
        external
        payable
        nonReentrant
    {
        (uint256[] memory ids, uint256[] memory amounts) = _toSingletonArrays(tokenId, amount);
        _mintBatchWithETH(to, ids, amounts, data, mintReferral);
    }

    /**
     * @notice mint a token in the channel
     * @param tokenId token id to mint
     * @param amount amount to mint
     * @param mintReferral referral address for minting
     * @param data mint data
     */
    function mintWithERC20(address to, uint256 tokenId, uint256 amount, address mintReferral, bytes memory data)
        external
        payable
        nonReentrant
    {
        (uint256[] memory ids, uint256[] memory amounts) = _toSingletonArrays(tokenId, amount);
        _mintBatchWithERC20(to, ids, amounts, data, mintReferral);
    }

    /**
     * @notice mint a batch of tokens in the channel with ETH
     * @param to address to mint to
     * @param ids token ids to mint
     * @param amounts amounts to mint
     * @param data mint data
     * @param mintReferral referral address for minting
     */
    function mintBatchWithETH(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data,
        address mintReferral
    ) external payable nonReentrant {
        _mintBatchWithETH(to, ids, amounts, data, mintReferral);
    }

    /**
     * @notice mint a batch of tokens in the channel with ERC20
     * @param to address to mint to
     * @param ids token ids to mint
     * @param amounts amounts to mint
     * @param data mint data
     * @param mintReferral referral address for minting
     */
    function mintBatchWithERC20(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data,
        address mintReferral
    ) external payable nonReentrant {
        _mintBatchWithERC20(to, ids, amounts, data, mintReferral);
    }

    function _mintBatchWithETH(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data,
        address mintReferral
    ) internal {
        for (uint256 i = 0; i < ids.length; i++) {
            TokenConfig memory token = tokens[ids[i]];
            _checkMintRequirements(token, ids[i], amounts[i]);
            _handleETHRewards(ids[i], amounts[i], mintReferral, data);
        }
        _mintBatch(msg.sender, ids, amounts, data);
        _validateMinterLogic(msg.sender);
        emit TokenMinted(to, mintReferral, ids, amounts);
    }

    function _mintBatchWithERC20(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data,
        address mintReferral
    ) internal {
        for (uint256 i = 0; i < ids.length; i++) {
            TokenConfig memory token = tokens[ids[i]];
            _checkMintRequirements(token, ids[i], amounts[i]);
            _handleERC20Rewards(ids[i], amounts[i], mintReferral, data);
        }
        _mintBatch(msg.sender, ids, amounts, data);
        _validateMinterLogic(msg.sender);
        emit TokenMinted(to, mintReferral, ids, amounts);
    }

    function _handleETHRewards(uint256 tokenId, uint256 amount, address mintReferral, bytes memory data) internal {
        TokenConfig memory token = tokens[tokenId];

        uint256 price = ethMintPrice() * amount;

        if (msg.value != price) {
            revert InvalidValueSent();
        }

        _depositETHRewards(feeContract.requestNativeMint(token.author, mintReferral, token.sponsor), amount);
        emit ETHTransferred(msg.sender, price);
    }

    function _handleERC20Rewards(uint256 tokenId, uint256 amount, address mintReferral, bytes memory data) internal {
        TokenConfig memory token = tokens[tokenId];

        uint256 price = erc20MintPrice() * amount;

        _depositERC20Rewards(feeContract.requestErc20Mint(token.author, mintReferral, token.sponsor), price, amount);
        emit ERC20Transferred(msg.sender, price);
    }

    function _depositETHRewards(IFees.NativeMintCommands[] memory commands, uint256 numMints) internal {
        uint256 totalDeposited = 0;
        for (uint256 i = 0; i < commands.length; i++) {
            if (commands[i].method == IFees.NativeFeeActions.SEND_ETH) {
                (bool success,) = commands[i].recipient.call{value: commands[i].amount * numMints}("");
                if (!success) {
                    revert TransferFailed();
                }
                totalDeposited += commands[i].amount * numMints;
            }
        }
        if (totalDeposited != msg.value) {
            revert DepositMismatch();
        }
    }

    function _depositERC20Rewards(IFees.Erc20MintCommands[] memory commands, uint256 totalValue, uint256 numMints)
        internal
    {
        uint256 totalDeposited = 0;
        for (uint256 i = 0; i < commands.length; i++) {
            if (commands[i].method == IFees.Erc20FeeActions.SEND_ERC20) {
                IERC20(commands[i].erc20Contract).safeTransferFrom(
                    msg.sender, commands[i].recipient, commands[i].amount * numMints
                );
                totalDeposited += commands[i].amount * numMints;
            }
        }
        if (totalDeposited != totalValue) {
            revert DepositMismatch();
        }
    }

    /// upgrades

    /**
     * @notice Authorizes upgrade to a new implementation if the upgrade path is registered and the caller is authorized
     * @dev This function is called in `upgradeTo` & `upgradeToAndCall`
     * @param newImplementation address of the new implementation
     */
    function _authorizeUpgrade(address newImplementation) internal view override onlyAdminOrManager {
        if (!upgradePath.isRegisteredUpgradePath(_implementation(), newImplementation)) {
            revert InvalidUpgrade();
        }
    }

    function _implementation() internal view returns (address) {
        return ERC1967Utils.getImplementation();
    }

    /**
     * @dev Creates an array in memory with only one value for each of the elements provided.
     */
    function _toSingletonArrays(uint256 element1, uint256 element2)
        private
        pure
        returns (uint256[] memory array1, uint256[] memory array2)
    {
        /// @solidity memory-safe-assembly
        assembly {
            // Load the free memory pointer
            array1 := mload(0x40)
            // Set array length to 1
            mstore(array1, 1)
            // Store the single element at the next word after the length (where content starts)
            mstore(add(array1, 0x20), element1)

            // Repeat for next array locating it right after the first array
            array2 := add(array1, 0x40)
            mstore(array2, 1)
            mstore(add(array2, 0x20), element2)

            // Update the free memory pointer by pointing after the second array
            mstore(0x40, add(array2, 0x40))
        }
    }
}
