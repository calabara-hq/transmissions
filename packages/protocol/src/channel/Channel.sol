// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IFees } from "../fees/CustomFees.sol";
import { IChannel } from "../interfaces/IChannel.sol";
import { ILogic } from "../interfaces/ILogic.sol";
import { Rewards } from "../rewards/Rewards.sol";
import { ManagedChannel } from "../utils/ManagedChannel.sol";

import { DeferredTokenAuthorization } from "../utils/DeferredTokenAuthorization.sol";
import { Multicall } from "../utils/Multicall.sol";
import { ChannelStorage } from "./ChannelStorage.sol";
import { Initializable } from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title Channel
 * @author nick
 * @notice Channel contract for managing tokens. This contract is the base for all transport channels.
 */
abstract contract Channel is
  IChannel,
  Initializable,
  Rewards,
  ChannelStorage,
  Multicall,
  ManagedChannel,
  DeferredTokenAuthorization
{
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
    address indexed minter,
    address indexed mintReferral,
    uint256[] tokenIds,
    uint256[] amounts,
    bytes data
  );

  event ChannelMetadataUpdated(address indexed updater, string channelName, string uri);
  event ConfigUpdated(
    address indexed updater,
    ConfigUpdate indexed updateType,
    address feeContract,
    address logicContract
  );

  /* -------------------------------------------------------------------------- */
  /*                          CONSTRUCTOR & INITIALIZER                         */
  /* -------------------------------------------------------------------------- */

  constructor(address _upgradePath, address weth) Rewards(weth) ManagedChannel(_upgradePath) {}

  function initialize(
    string calldata uri,
    string calldata name,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
  ) external nonReentrant initializer {
    __UUPSUpgradeable_init();

    __AccessControlEnumerable_init();

    __DeferredTokenAuthorization_init();

    /// @dev temporarily set deployer as admin
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

    /// @dev grant the default admin role
    _grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);

    /// @dev set the managers
    setManagers(managers);

    /// @dev set the transport configuration
    setTransportConfig(transportConfig);

    /// @dev set the channel name
    _setName(name);

    /// @dev set up the channel token
    _setupNewToken(uri, 0, address(this));

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

  function setTransportConfig(bytes calldata data) public virtual;

  /* -------------------------------------------------------------------------- */
  /*                                 OVERRIDES                                  */
  /* -------------------------------------------------------------------------- */

  /**
   * @notice Returns the URI for a token
   * @param tokenId The token ID to return the URI for
   */
  function uri(uint256 tokenId) public view override returns (string memory) {
    return tokens[tokenId].uri;
  }

  /* -------------------------------------------------------------------------- */
  /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
  /* -------------------------------------------------------------------------- */

  /**
   * @notice Get the contract URI
   * @return string URI
   */
  function contractURI() external view returns (string memory) {
    return uri(0);
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
   * @notice Used to update the channel metadata
   * @param channelName Channel name
   * @param uri Channel uri
   */
  function updateChannelMetadata(string calldata channelName, string calldata uri) external onlyAdminOrManager {
    _setName(channelName);
    tokens[0].uri = uri;
    emit ChannelMetadataUpdated(msg.sender, channelName, uri);
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
  ) external onlyAdminOrManager {
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
   * @param maxSupply Token supply
   * @return tokenId Id of newly created token
   */
  function createToken(string calldata uri, uint256 maxSupply) external nonReentrant returns (uint256 tokenId) {
    tokenId = _setupNewToken(uri, maxSupply, msg.sender);

    /// @dev increment the senders numCreations
    uint256 numUserCreations = _getAndUpdateUserCreations(msg.sender);

    _transportProcessNewToken(tokenId);

    _validateLogic(msg.sender, numUserCreations, 0);
  }

  /**
   * @notice create a token from signature and mint it to the to address with ERC20
   * @param tokenPermission Token permission
   * @param author Token author
   * @param v Signature v
   * @param r Signature r
   * @param s Signature s
   * @param to Address to mint to
   * @param amount Amount to mint
   * @param mintReferral Referral address for minting
   * @param data Mint data
   */
  function sponsorWithERC20(
    DeferredTokenAuthorization.DeferredTokenPermission memory tokenPermission,
    address author,
    uint8 v,
    bytes32 r,
    bytes32 s,
    address to,
    uint256 amount,
    address mintReferral,
    bytes memory data
  ) external nonReentrant {
    (uint256 tokenId, uint256 numUserCreations) = _processSponsoredToken(tokenPermission, author, v, r, s);

    /// @dev mint the token to the sponsor
    (uint256[] memory ids, uint256[] memory amounts) = _toSingletonArrays(tokenId, amount);
    _mintBatchWithERC20(to, ids, amounts, mintReferral, data);

    /// @dev validate the creator logic
    _validateLogic(msg.sender, numUserCreations, 0);
  }

  /**
   * @notice create a token from signature and mint it to the to address with ETH
   * @param tokenPermission Token permission
   * @param author Token author
   * @param v Signature v
   * @param r Signature r
   * @param s Signature s
   * @param to Address to mint to
   * @param amount Amount to mint
   * @param mintReferral Referral address for minting
   * @param data Mint data
   */
  function sponsorWithETH(
    DeferredTokenAuthorization.DeferredTokenPermission memory tokenPermission,
    address author,
    uint8 v,
    bytes32 r,
    bytes32 s,
    address to,
    uint256 amount,
    address mintReferral,
    bytes memory data
  ) external payable nonReentrant {
    (uint256 tokenId, uint256 numUserCreations) = _processSponsoredToken(tokenPermission, author, v, r, s);

    /// @dev mint the token to the sponsor
    (uint256[] memory ids, uint256[] memory amounts) = _toSingletonArrays(tokenId, amount);
    _mintBatchWithETH(to, ids, amounts, mintReferral, data);

    /// @dev validate the creator logic
    _validateLogic(msg.sender, numUserCreations, 0);
  }

  function _processSponsoredToken(
    DeferredTokenAuthorization.DeferredTokenPermission memory tokenPermission,
    address author,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) internal returns (uint256, uint256) {
    _validateDeferredTokenCreation(tokenPermission, author, v, r, s);

    /// @dev create the token
    uint256 tokenId = _setupNewToken(tokenPermission.uri, tokenPermission.maxSupply, author);

    /// @dev increment the authors numCreations
    uint256 numUserCreations = _getAndUpdateUserCreations(author);

    _transportProcessNewToken(tokenId);

    return (tokenId, numUserCreations);
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
  ) external payable nonReentrant {
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
  ) external nonReentrant {
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
  ) external payable nonReentrant {
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
  ) external nonReentrant {
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

  function _setName(string memory channelName) internal {
    name = channelName;
  }

  function _setupNewToken(string memory newURI, uint256 maxSupply, address author) internal returns (uint256) {
    uint256 tokenId = _getAndUpdateNextTokenId();

    TokenConfig memory tokenConfig = TokenConfig({
      uri: newURI,
      maxSupply: maxSupply,
      totalMinted: 0,
      author: author,
      sponsor: msg.sender
    });
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
   * @dev Validate the creator or minter logic.
   * @dev let execution continue or revert based on the logic contract.
   * @param user address of the interactor.
   * @param updatedInteractionCount updated number of interactions.
   * @param mode 0 for creator, 1 for minter.
   */
  function _validateLogic(address user, uint256 updatedInteractionCount, uint8 mode) internal {
    if (mode == 0) {
      /// @dev pass if no logic contract set
      if (address(logicContract) == address(0)) return;

      uint256 maxTheoreticalCreatorPower = logicContract.calculateCreatorInteractionPower(user);

      /// @dev pass if the maxTheoreticalCreatorPower is max uint256
      if (maxTheoreticalCreatorPower == type(uint256).max) return;

      /// @dev revert if the updatedNumUserCreations is greater than the maxTheoreticalCreatorPower
      if (updatedInteractionCount > maxTheoreticalCreatorPower) revert InsufficientInteractionPower();
    } else {
      /// @dev pass if no logic contract set
      if (address(logicContract) == address(0)) return;

      uint256 maxTheoreticalMinterPower = logicContract.calculateMinterInteractionPower(user);

      /// @dev pass if the maxTheoreticalMinterPower is max uint256
      if (maxTheoreticalMinterPower == type(uint256).max) return;

      /// @dev revert if the updateNumUserMints is greater than the maxTheoreticalMinterPower
      if (updatedInteractionCount > maxTheoreticalMinterPower) revert InsufficientInteractionPower();
    }
  }

  function _mintBatchWithETH(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    address mintReferral,
    bytes memory data
  ) internal {
    (address[] memory creators, address[] memory sponsors, uint256 totalAmount) = _processBatchMint(
      to,
      ids,
      amounts,
      data
    );

    uint256 updatedNumUserMints = _getAndUpdateUserMints(msg.sender, totalAmount);

    _handleETHSplit(creators, sponsors, amounts, mintReferral);

    _validateLogic(msg.sender, updatedNumUserMints, 1);
    emit TokenMinted(to, mintReferral, ids, amounts, data);
  }

  function _mintBatchWithERC20(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    address mintReferral,
    bytes memory data
  ) internal {
    (address[] memory creators, address[] memory sponsors, uint256 totalAmount) = _processBatchMint(
      to,
      ids,
      amounts,
      data
    );

    uint256 updatedNumUserMints = _getAndUpdateUserMints(msg.sender, totalAmount);

    _handleERC20Split(creators, sponsors, amounts, mintReferral);

    _validateLogic(msg.sender, updatedNumUserMints, 1);
    emit TokenMinted(to, mintReferral, ids, amounts, data);
  }

  function _processBatchMint(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data
  ) internal returns (address[] memory creators, address[] memory sponsors, uint256 totalAmount) {
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
  ) internal {
    if (address(feeContract) != address(0)) {
      _distributePassThroughSplit(feeContract.requestEthMint(creators, sponsors, amounts, mintReferral));
    }
  }

  function _handleERC20Split(
    address[] memory creators,
    address[] memory sponsors,
    uint256[] memory amounts,
    address mintReferral
  ) internal {
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
  ) private pure returns (uint256[] memory array1, uint256[] memory array2) {
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
