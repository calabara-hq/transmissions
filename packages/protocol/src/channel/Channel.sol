// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { ChannelStorage } from "./ChannelStorage.sol";

import { IFees } from "../fees/CustomFees.sol";

import { ILogic } from "../logic/Logic.sol";

import { IRewards, Rewards } from "../rewards/Rewards.sol";
import { Multicall } from "../utils/Multicall.sol";
import { IUpgradePath, UpgradePath } from "../utils/UpgradePath.sol";
import { AccessControlUpgradeable } from "openzeppelin-contracts-upgradeable/access/AccessControlUpgradeable.sol";
import { Initializable } from "openzeppelin-contracts-upgradeable/proxy/utils/Initializable.sol";
import { UUPSUpgradeable } from "openzeppelin-contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import { ERC1155Upgradeable } from "openzeppelin-contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";
import { ReentrancyGuardUpgradeable } from "openzeppelin-contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import { ERC1967Utils } from "openzeppelin-contracts/proxy/ERC1967/ERC1967Utils.sol";

interface IChannel {
  function initialize(
    string calldata uri,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata timing
  ) external;

  function setFees(address fees, bytes calldata data) external;
  function setLogic(address logic, bytes calldata creatorLogic, bytes calldata minterLogic) external;
}

abstract contract Channel is
  IChannel,
  Initializable,
  Rewards,
  ChannelStorage,
  Multicall,
  ERC1155Upgradeable,
  UUPSUpgradeable,
  AccessControlUpgradeable,
  ReentrancyGuardUpgradeable
{
  error FalsyLogic();
  error Unauthorized();
  error NotMintable();
  error SoldOut();
  error InvalidAmount();
  error InvalidValueSent();
  error DepositMismatch();
  error AddressZero();
  error InvalidUpgrade();
  error TransferFailed();

  event TokenCreated(uint256 indexed tokenId, ChannelStorage.TokenConfig token);
  event TokenMinted(address indexed minter, address indexed mintReferral, uint256[] tokenIds, uint256[] amounts);
  event ERC20Transferred(address indexed spender, uint256 amount);
  event ETHTransferred(address indexed spender, uint256 amount);
  event TokenURIUpdated(uint256 indexed tokenId, string uri);

  bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
  IUpgradePath internal immutable upgradePath;

  /// @notice Modifier checking if the user is an admin or has a specific role
  /// @dev This reverts if the msg.sender is not an admin or role holder

  constructor(address _upgradePath, address weth) Rewards(weth) {
    upgradePath = IUpgradePath(_upgradePath);
  }

  modifier onlyAdminOrManager() {
    _requireAdminOrManager(msg.sender);
    _;
  }

  /* -------------------------------------------------------------------------- */
  /*                                INITIALIZER                                 */
  /* -------------------------------------------------------------------------- */
  function initialize(
    string calldata uri,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata timing
  ) external nonReentrant initializer {
    __ERC1155_init(uri);

    __UUPSUpgradeable_init();

    __AccessControl_init();

    /// temporarily set deployer as admin
    _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);

    /// grant the default admin role
    grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);

    /// set up the managers
    _setManagers(managers);

    /// set up the channel token
    _setupNewToken(uri, 0, _implementation());

    if (setupActions.length > 0) {
      multicall(setupActions);
    }

    setTiming(timing);

    /// revoke admin for deployer
    _revokeRole(DEFAULT_ADMIN_ROLE, msg.sender);
  }

  /* -------------------------------------------------------------------------- */
  /*                          PUBLIC/EXTERNAL FUNCTIONS                         */
  /* -------------------------------------------------------------------------- */

  function ethMintPrice() public view returns (uint256) {
    return feeContract.getEthMintPrice();
  }

  function erc20MintPrice() public view returns (uint256) {
    return feeContract.getErc20MintPrice();
  }

  function setLogic(
    address logic,
    bytes calldata creatorLogic,
    bytes calldata minterLogic
  ) external onlyAdminOrManager {
    if (logic == address(0)) {
      revert AddressZero();
    }

    logicContract = ILogic(logic);

    logicContract.setCreatorLogic(creatorLogic);
    logicContract.setMinterLogic(minterLogic);

    //todo
    // emit ConfigUpdated(
    //     ConfigUpdate.LOGIC_CONTRACT, address(feeContract), address(logicContract), address(timingContract)
    // );
  }

  function setFees(address fees, bytes calldata data) external onlyAdminOrManager {
    if (fees == address(0)) {
      revert AddressZero();
    }

    feeContract = IFees(fees);

    feeContract.setChannelFees(data);

    //todo
    //   emit ConfigUpdated(
    //       ConfigUpdate.FEE_CONTRACT, address(feeContract), address(logicContract), address(timingContract)
    //   );
  }

  /**
   * @notice Used to get the token details
   * @param tokenId Token id
   * @return TokenConfig Token details
   */
  function getToken(uint256 tokenId) public view returns (TokenConfig memory) {
    return tokens[tokenId];
  }

  function supportsInterface(
    bytes4 interfaceId
  ) public view virtual override(ERC1155Upgradeable, AccessControlUpgradeable) returns (bool) {
    return super.supportsInterface(interfaceId);
  }

  function setTiming(bytes calldata data) public virtual;

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
  ) external nonReentrant returns (uint256 tokenId) {
    tokenId = _setupNewToken(uri, maxSupply, author);

    _processNewToken(tokenId);

    _validateCreatorLogic(msg.sender);
  }

  function _processNewToken(uint256 tokenId) internal virtual;

  function _authorizeMint(uint256 tokenId) internal virtual;

  /*     function mint(
        address to,
        uint256 tokenId,
        uint256 amount,
        address mintReferral,
        bytes memory data
    )
        external
        payable
        virtual;
    */
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
    _mintBatchWithETH(to, ids, amounts, data, mintReferral);
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
  ) external payable nonReentrant {
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

  /**
   * @notice Used to update the default channel token uri
   * @param uri Token uri
   */
  function updateChannelTokenUri(string calldata uri) external onlyAdminOrManager {
    tokens[0].uri = uri;
    emit TokenURIUpdated(0, uri);
  }

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
      revert Unauthorized();
    }
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

  function _checkMintRequirements(TokenConfig memory token, uint256 tokenId, uint256 amount) internal view {
    require(token.maxSupply > 0, "Token is not mintable");
    require(token.totalMinted < token.maxSupply, "Token is sold out");
    require(amount > 0, "Amount must be greater than 0");
    require(amount <= token.maxSupply - token.totalMinted, "Amount exceeds max supply");
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

  function _mintBatchWithETH(
    address to,
    uint256[] memory ids,
    uint256[] memory amounts,
    bytes memory data,
    address mintReferral
  ) internal {
    for (uint256 i = 0; i < ids.length; i++) {
      TokenConfig memory token = tokens[ids[i]];
      _authorizeMint(ids[i]);
      _checkMintRequirements(token, ids[i], amounts[i]);
      _distributeIncomingSplit(feeContract.requestEthMint(token.author, mintReferral, token.sponsor, amounts[i]));
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
      _authorizeMint(ids[i]);
      _checkMintRequirements(token, ids[i], amounts[i]);
      _distributeIncomingSplit(feeContract.requestErc20Mint(token.author, mintReferral, token.sponsor, amounts[i]));
    }
    _mintBatch(msg.sender, ids, amounts, data);
    _validateMinterLogic(msg.sender);
    emit TokenMinted(to, mintReferral, ids, amounts);
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

  /* -------------------------------------------------------------------------- */
  /*                                 UPGRADES                                   */
  /* -------------------------------------------------------------------------- */

  function _authorizeUpgrade(address newImplementation) internal view override onlyAdminOrManager {
    if (!upgradePath.isRegisteredUpgradePath(_implementation(), newImplementation)) {
      revert InvalidUpgrade();
    }
  }

  function _implementation() internal view returns (address) {
    return ERC1967Utils.getImplementation();
  }
}
