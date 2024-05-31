// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IFees } from "../fees/CustomFees.sol";
import { IChannel } from "../interfaces/IChannel.sol";
import { ILogic } from "../logic/Logic.sol";
import { Rewards } from "../rewards/Rewards.sol";
import { ManagedChannel } from "../utils/ManagedChannel.sol";

import { Multicall } from "../utils/Multicall.sol";
import { ChannelStorage } from "./ChannelStorage.sol";
import { Initializable } from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";

abstract contract Channel is IChannel, Initializable, Rewards, ChannelStorage, Multicall, ManagedChannel {
    /* -------------------------------------------------------------------------- */
    /*                                CONSTRUCTOR                                 */
    /* -------------------------------------------------------------------------- */

    constructor(address _upgradePath, address weth) Rewards(weth) ManagedChannel(_upgradePath) { }

    /* -------------------------------------------------------------------------- */
    /*                              VIRTUAL FUNCTIONS                             */
    /* -------------------------------------------------------------------------- */

    function _transportProcessNewToken(uint256 tokenId) internal virtual;

    function _transportProcessMint(uint256 tokenId) internal virtual;

    function setTransportConfig(bytes calldata data) public payable virtual;

    /* -------------------------------------------------------------------------- */
    /*                                INITIALIZER                                 */
    /* -------------------------------------------------------------------------- */

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
    /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Get the ETH mint price for tokens in the channel
     * @return uint256 ETH price in wei
     */
    function ethMintPrice() public view returns (uint256) {
        return feeContract.getEthMintPrice();
    }

    /**
     * @notice Get the ERC20 mint price for tokens in the channel
     * @return uint256 ERC20 price in wei
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
     * @dev Address 0 is acceptable, and is treated as a no-op on logic validation todo
     * @dev Only call into the logic contract if the address is not 0
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
        userStats[msg.sender].numCreations += 1;

        _transportProcessNewToken(tokenId);

        /// @dev msg.sender used instead of author to allow for onchain sponsorships
        _validateCreatorLogic(msg.sender);
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
        require(token.maxSupply > 0, "Token is not mintable");
        require(token.totalMinted < token.maxSupply, "Token is sold out");
        require(amount > 0, "Amount must be greater than 0");
        require(amount <= token.maxSupply - token.totalMinted, "Amount exceeds max supply");
    }

    /**
     * @dev Validate the creator logic.
     * @dev let execution continue or revert based on the logic contract.
     * @param creator address of the creator.
     */
    function _validateCreatorLogic(address creator) internal view {
        // return true if no logic contract set
        if (address(logicContract) == address(0)) return;
        if (logicContract.isCreatorApproved(creator)) return;
        revert FALSY_LOGIC();
    }

    /**
     * @dev Validate the minter logic.
     * @dev let execution continue or revert based on the logic contract.
     * @param minter address of the minter.
     */
    function _validateMinterLogic(address minter) internal view {
        // return true if no logic contract set
        if (address(logicContract) == address(0)) return;
        if (logicContract.isMinterApproved(minter)) return;
        revert FALSY_LOGIC();
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
        address[] memory creators = new address[](ids.length);
        address[] memory referrals = new address[](ids.length);
        address[] memory sponsors = new address[](ids.length);
        uint256 totalMints = 0;

        for (uint256 i = 0; i < ids.length; i++) {
            TokenConfig memory token = tokens[ids[i]];
            _checkMintRequirements(token, amounts[i]);

            tokens[ids[i]].totalMinted += amounts[i];

            /// @dev increment the minter's numMints
            userStats[msg.sender].numMints += amounts[i];

            _transportProcessMint(ids[i]);

            creators[i] = token.author;
            referrals[i] = mintReferral;
            sponsors[i] = token.sponsor;
        }

        // /// @dev increment the minter's numMints
        // userStats[msg.sender].numMints += totalMints;

        _handleETHSplit(creators, referrals, sponsors, amounts, mintReferral);

        _mintBatch(to, ids, amounts, data);
        _validateMinterLogic(msg.sender);
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
        address[] memory creators = new address[](ids.length);
        address[] memory referrals = new address[](ids.length);
        address[] memory sponsors = new address[](ids.length);

        for (uint256 i = 0; i < ids.length; i++) {
            TokenConfig memory token = tokens[ids[i]];
            _checkMintRequirements(token, amounts[i]);

            tokens[ids[i]].totalMinted += amounts[i];
            userStats[msg.sender].numMints += amounts[i];

            _transportProcessMint(ids[i]);

            creators[i] = token.author;
            referrals[i] = mintReferral;
            sponsors[i] = token.sponsor;
        }

        // generate fee commands with batched data and get one large split
        _handleERC20Split(creators, referrals, sponsors, amounts, mintReferral);

        _mintBatch(to, ids, amounts, data);
        _validateMinterLogic(msg.sender);
        emit TokenMinted(to, mintReferral, ids, amounts, data);
    }

    function _handleETHSplit(
        address[] memory creators,
        address[] memory referrals,
        address[] memory sponsors,
        uint256[] memory amounts,
        address mintReferral
    )
        internal
    {
        if (address(feeContract) != address(0)) {
            _distributePassThroughSplit(feeContract.requestEthMint(creators, referrals, sponsors, amounts));
        }
    }

    function _handleERC20Split(
        address[] memory creators,
        address[] memory referrals,
        address[] memory sponsors,
        uint256[] memory amounts,
        address mintReferral
    )
        internal
    {
        if (address(feeContract) != address(0)) {
            _distributePassThroughSplit(feeContract.requestErc20Mint(creators, referrals, sponsors, amounts));
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
