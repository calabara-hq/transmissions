// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IFees } from "../fees/CustomFees.sol";
import { IChannel } from "../interfaces/IChannel.sol";
import { ILogic } from "../interfaces/ILogic.sol";
import { Rewards } from "../rewards/Rewards.sol";
import { ManagedChannel } from "../utils/ManagedChannel.sol";

import { Multicall } from "../utils/Multicall.sol";
import { ChannelStorage } from "./ChannelStorage.sol";
import { Initializable } from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title Channel
 * @author nick
 * @notice Channel contract for managing tokens. This contract is the base for all transport channels.
 */
abstract contract Channel is IChannel, Initializable, Rewards, ChannelStorage, Multicall, ManagedChannel {
    /* -------------------------------------------------------------------------- */
    /*                                   ERRORS                                   */
    /* -------------------------------------------------------------------------- */

    error InsufficientInteractionPower();
    error NotMintable();
    error SoldOut();
    error AmountZero();
    error AmountExceedsMaxSupply();

    /* -------------------------------------------------------------------------- */
    /*                                   EVENTS                                   */
    /* -------------------------------------------------------------------------- */

    enum ConfigUpdate {
        FEE_CONTRACT,
        LOGIC_CONTRACT
    }

    event TokenCreated(uint256 indexed tokenId, ChannelStorage.TokenConfig token);
    event TokenMinted(
        address indexed minter, address indexed mintReferral, uint256[] tokenIds, uint256[] amounts, bytes data
    );

    event TokenURIUpdated(uint256 indexed tokenId, string uri);
    event ConfigUpdated(
        address indexed updater, ConfigUpdate indexed updateType, address feeContract, address logicContract
    );

    event LogicUpdated(address indexed updater, address logicContract, bytes data);
    event FeesUpdated(address indexed updater, address feeContract, bytes data);

    /* -------------------------------------------------------------------------- */
    /*                          CONSTRUCTOR & INITIALIZER                         */
    /* -------------------------------------------------------------------------- */

    constructor(address _upgradePath, address weth) Rewards(weth) ManagedChannel(_upgradePath) { }

    function initialize(
        string calldata uri,
        address defaultAdmin,
        address[] calldata managers,
        bytes[] calldata setupActions,
        bytes calldata transportConfig
    )
        external
        payable
        nonReentrant
        initializer
    {
        __UUPSUpgradeable_init();

        __AccessControlEnumerable_init();

        /// @dev temporarily set deployer as admin
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

        /// @dev grant the default admin role
        _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);

        /// @dev set the managers
        setManagers(managers);

        /// @dev set the transport configuration
        setTransportConfig(transportConfig);

        /// @dev set up the channel token
        _setupNewToken(uri, 0, _implementation());

        if (setupActions.length > 0) {
            multicall(setupActions);
        }

        /// @dev revoke admin for deployer
        _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    /* -------------------------------------------------------------------------- */
    /*                              VIRTUAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _transportProcessNewToken(uint256 tokenId) internal virtual;

    function _transportProcessMint(uint256 tokenId) internal virtual;

    function setTransportConfig(bytes calldata data) public payable virtual;

    /* -------------------------------------------------------------------------- */
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Get the ETH mint price for tokens in the channel
     * @return uint256 ETH price
     */
    function ethMintPrice() public view returns (uint256) {
        return feeContract.getEthMintPrice();
    }

    /**
     * @notice Get the ERC20 mint price for tokens in the channel
     * @return uint256 ERC20 price
     */
    function erc20MintPrice() public view returns (uint256) {
        return feeContract.getErc20MintPrice();
    }

    /**
     * @notice Used to get the token details
     * @param tokenId Token id
     * @return TokenConfig Token details
     */
    function getToken(uint256 tokenId) external view returns (TokenConfig memory) {
        return tokens[tokenId];
    }

    /**
     * @notice Used to update the default channel token uri
     * @param uri Token uri
     */
    function updateChannelTokenUri(string calldata uri) external onlyAdminOrManager {
        tokens[0].uri = uri;
        emit TokenURIUpdated(0, uri);
    }

    function getUserStats(address user) public view returns (UserStats memory) {
        return userStats[user];
    }

    /**
     * @notice Set the logic structure for the channel
     * @dev Address 0 is acceptable, and is treated as a no-op on logic validation
     * @dev Only call into the logic contract if the address is not 0
     * @param logic Address of the logic contract
     * @param creatorLogic Creator logic initialization data
     * @param minterLogic Minter logic initialization data
     */
    function setLogic(
        address logic,
        bytes calldata creatorLogic,
        bytes calldata minterLogic
    )
        external
        onlyAdminOrManager
    {
        logicContract = ILogic(logic);

        if (logic != address(0)) {
            logicContract.setCreatorLogic(creatorLogic);
            logicContract.setMinterLogic(minterLogic);
        }

        emit ConfigUpdated(msg.sender, ConfigUpdate.LOGIC_CONTRACT, address(feeContract), address(logicContract));
    }

    /**
     * @notice Set the fee structure for the channel
     * @dev Address 0 is acceptable, and is treated as a no-op on fee computation
     * @dev Only call into the fee contract if the address is not 0
     * @param fees Address of the fee contract
     * @param data Fee contract initialization data
     */
    function setFees(address fees, bytes calldata data) external onlyAdminOrManager {
        feeContract = IFees(fees);

        if (fees != address(0)) {
            feeContract.setChannelFees(data);
        }

        emit ConfigUpdated(msg.sender, ConfigUpdate.FEE_CONTRACT, address(feeContract), address(logicContract));
    }

    /**
     * @notice Used to create a new token in the channel
     * Call the logic contract to check if the msg.sender is approved to create a new token
     * @param uri Token uri
     * @param author Token author
     * @param maxSupply Token supply
     * @return tokenId Id of newly created token
     */
    function createToken(
        string calldata uri,
        address author,
        uint256 maxSupply
    )
        external
        nonReentrant
        returns (uint256 tokenId)
    {
        tokenId = _setupNewToken(uri, maxSupply, author);

        /// @dev increment the sponsor's numCreations
        uint256 numUserCreations = _getAndUpdateUserCreations(msg.sender);

        _transportProcessNewToken(tokenId);

        /// @dev msg.sender used instead of author to allow for onchain sponsorships
        _validateCreatorLogic(msg.sender, numUserCreations);
    }

    /**
     * @notice mint a token in the channel
     * @param to address to mint to
     * @param tokenId token id to mint
     * @param amount amount to mint
     * @param mintReferral referral address for minting
     * @param data mint data
     */
    function mint(
        address to,
        uint256 tokenId,
        uint256 amount,
        address mintReferral,
        bytes memory data
    )
        external
        payable
        nonReentrant
    {
        (uint256[] memory ids, uint256[] memory amounts) = _toSingletonArrays(tokenId, amount);
        _mintBatchWithETH(to, ids, amounts, mintReferral, data);
    }

    /**
     * @notice mint a token in the channel
     * @param tokenId token id to mint
     * @param amount amount to mint
     * @param mintReferral referral address for minting
     * @param data mint data
     */
    function mintWithERC20(
        address to,
        uint256 tokenId,
        uint256 amount,
        address mintReferral,
        bytes memory data
    )
        external
        payable
        nonReentrant
    {
        (uint256[] memory ids, uint256[] memory amounts) = _toSingletonArrays(tokenId, amount);
        _mintBatchWithERC20(to, ids, amounts, mintReferral, data);
    }

    /**
     * @notice mint a batch of tokens in the channel with ETH
     * @param to address to mint to
     * @param ids token ids to mint
     * @param amounts amounts to mint
     * @param mintReferral referral address for minting
     * @param data mint data
     */
    function mintBatchWithETH(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        address mintReferral,
        bytes memory data
    )
        external
        payable
        nonReentrant
    {
        _mintBatchWithETH(to, ids, amounts, mintReferral, data);
    }

    /**
     * @notice mint a batch of tokens in the channel with ERC20
     * @param to address to mint to
     * @param ids token ids to mint
     * @param amounts amounts to mint
     * @param mintReferral referral address for minting
     * @param data mint data
     */
    function mintBatchWithERC20(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        address mintReferral,
        bytes memory data
    )
        external
        payable
        nonReentrant
    {
        _mintBatchWithERC20(to, ids, amounts, mintReferral, data);
    }

    /* -------------------------------------------------------------------------- */
    /*                             INTERNAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _getAndUpdateUserCreations(address user) internal returns (uint256) {
        uint256 currentNumCreations = userStats[user].numCreations;
        userStats[user].numCreations = currentNumCreations + 1;
        return currentNumCreations + 1;
    }

    function _getAndUpdateUserMints(address user, uint256 amount) internal returns (uint256) {
        uint256 currentNumMints = userStats[user].numMints;
        userStats[user].numMints = currentNumMints + amount;
        return currentNumMints + amount;
    }

    function _getAndUpdateNextTokenId() internal returns (uint256) {
        unchecked {
            return nextTokenId++;
        }
    }

    function _setupNewToken(string memory newURI, uint256 maxSupply, address author) internal returns (uint256) {
        uint256 tokenId = _getAndUpdateNextTokenId();

        TokenConfig memory tokenConfig =
            TokenConfig({ uri: newURI, maxSupply: maxSupply, totalMinted: 0, author: author, sponsor: msg.sender });
        tokens[tokenId] = tokenConfig;

        emit TokenCreated(tokenId, tokenConfig);

        return tokenId;
    }

    function _checkMintRequirements(TokenConfig memory token, uint256 amount) internal pure {
        if (token.maxSupply == 0) revert NotMintable();
        if (token.totalMinted >= token.maxSupply) revert SoldOut();
        if (amount == 0) revert AmountZero();
        if (amount > token.maxSupply - token.totalMinted) revert AmountExceedsMaxSupply();
    }

    /**
     * @dev Validate the creator logic.
     * @dev let execution continue or revert based on the logic contract.
     * @param creator address of the creator.
     */
    function _validateCreatorLogic(address creator, uint256 updatedNumUserCreations) internal view {
        /// @dev pass if no logic contract set
        if (address(logicContract) == address(0)) return;

        uint256 maxTheoreticalCreatorPower = logicContract.calculateCreatorInteractionPower(creator);

        /// @dev pass if the maxTheoreticalCreatorPower is max uint256
        if (maxTheoreticalCreatorPower == type(uint256).max) return;

        /// @dev revert if the updatedNumUserCreations is greater than the maxTheoreticalCreatorPower
        if (updatedNumUserCreations > maxTheoreticalCreatorPower) revert InsufficientInteractionPower();
    }

    /**
     * @dev Validate the minter logic.
     * @dev let execution continue or revert based on the logic contract.
     * @param minter address of the minter.
     */
    function _validateMinterLogic(address minter, uint256 updateNumUserMints) internal view {
        /// @dev pass if no logic contract set
        if (address(logicContract) == address(0)) return;

        uint256 maxTheoreticalMinterPower = logicContract.calculateMinterInteractionPower(minter);

        /// @dev pass if the maxTheoreticalMinterPower is max uint256
        if (maxTheoreticalMinterPower == type(uint256).max) return;

        /// @dev revert if the updateNumUserMints is greater than the maxTheoreticalMinterPower
        if (updateNumUserMints > maxTheoreticalMinterPower) revert InsufficientInteractionPower();
    }

    function _mintBatchWithETH(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        address mintReferral,
        bytes memory data
    )
        internal
    {
        (address[] memory creators, address[] memory sponsors, uint256 totalAmount) =
            _processBatchMint(to, ids, amounts, data);

        uint256 updatedNumUserMints = _getAndUpdateUserMints(msg.sender, totalAmount);

        _handleETHSplit(creators, sponsors, amounts, mintReferral);

        _validateMinterLogic(msg.sender, updatedNumUserMints);
        emit TokenMinted(to, mintReferral, ids, amounts, data);
    }

    function _mintBatchWithERC20(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        address mintReferral,
        bytes memory data
    )
        internal
    {
        (address[] memory creators, address[] memory sponsors, uint256 totalAmount) =
            _processBatchMint(to, ids, amounts, data);

        uint256 updatedNumUserMints = _getAndUpdateUserMints(msg.sender, totalAmount);

        _handleERC20Split(creators, sponsors, amounts, mintReferral);

        _validateMinterLogic(msg.sender, updatedNumUserMints);
        emit TokenMinted(to, mintReferral, ids, amounts, data);
    }

    function _processBatchMint(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        internal
        returns (address[] memory creators, address[] memory sponsors, uint256 totalAmount)
    {
        creators = new address[](ids.length);
        sponsors = new address[](ids.length);
        totalAmount = 0;

        for (uint256 i = 0; i < ids.length; i++) {
            TokenConfig memory token = tokens[ids[i]];
            _checkMintRequirements(token, amounts[i]);

            tokens[ids[i]].totalMinted += amounts[i];

            totalAmount += amounts[i];

            _transportProcessMint(ids[i]);

            creators[i] = token.author;
            sponsors[i] = token.sponsor;
        }

        _mintBatch(to, ids, amounts, data);
    }

    function _handleETHSplit(
        address[] memory creators,
        address[] memory sponsors,
        uint256[] memory amounts,
        address mintReferral
    )
        internal
    {
        if (address(feeContract) != address(0)) {
            _distributePassThroughSplit(feeContract.requestEthMint(creators, sponsors, amounts, mintReferral));
        }
    }

    function _handleERC20Split(
        address[] memory creators,
        address[] memory sponsors,
        uint256[] memory amounts,
        address mintReferral
    )
        internal
    {
        if (address(feeContract) != address(0)) {
            _distributePassThroughSplit(feeContract.requestErc20Mint(creators, sponsors, amounts, mintReferral));
        }
    }

    /**
     * @dev Creates an array in memory with only one value for each of the elements provided.
     */
    function _toSingletonArrays(
        uint256 element1,
        uint256 element2
    )
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
