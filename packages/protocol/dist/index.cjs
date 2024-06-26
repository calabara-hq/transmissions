var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);

// package/index.ts
var package_exports = {};
__export(package_exports, {
  channelAbi: () => channelAbi,
  channelFactoryAbi: () => channelFactoryAbi,
  customFeesAbi: () => customFeesAbi,
  dynamicLogicAbi: () => dynamicLogicAbi,
  finiteChannelAbi: () => finiteChannelAbi,
  infiniteChannelAbi: () => infiniteChannelAbi,
  rewardsAbi: () => rewardsAbi,
  upgradePathAbi: () => upgradePathAbi
});
module.exports = __toCommonJS(package_exports);
var channelAbi = [
  {
    type: "function",
    inputs: [],
    name: "DEFAULT_ADMIN_ROLE",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "DEFERRED_TOKEN_TYPEHASH",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "DOMAIN_SEPARATOR",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "EIP712_DOMAIN_TYPEHASH",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "MANAGER_ROLE",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "UPGRADE_INTERFACE_VERSION",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "id", internalType: "uint256", type: "uint256" }
    ],
    name: "balanceOf",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "accounts", internalType: "address[]", type: "address[]" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" }
    ],
    name: "balanceOfBatch",
    outputs: [{ name: "", internalType: "uint256[]", type: "uint256[]" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "contractURI",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "uri", internalType: "string", type: "string" },
      { name: "maxSupply", internalType: "uint256", type: "uint256" }
    ],
    name: "createToken",
    outputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "", internalType: "address", type: "address" }],
    name: "erc20Balances",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "feeContract",
    outputs: [{ name: "", internalType: "contract IFees", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "role", internalType: "bytes32", type: "bytes32" }],
    name: "getRoleAdmin",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "index", internalType: "uint256", type: "uint256" }
    ],
    name: "getRoleMember",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "role", internalType: "bytes32", type: "bytes32" }],
    name: "getRoleMemberCount",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    name: "getToken",
    outputs: [
      {
        name: "",
        internalType: "struct ChannelStorage.TokenConfig",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "author", internalType: "address", type: "address" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "totalMinted", internalType: "uint256", type: "uint256" },
          { name: "sponsor", internalType: "address", type: "address" }
        ]
      }
    ],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "grantRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "hasRole",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "uri", internalType: "string", type: "string" },
      { name: "name", internalType: "string", type: "string" },
      { name: "defaultAdmin", internalType: "address", type: "address" },
      { name: "managers", internalType: "address[]", type: "address[]" },
      { name: "setupActions", internalType: "bytes[]", type: "bytes[]" },
      { name: "transportConfig", internalType: "bytes", type: "bytes" }
    ],
    name: "initialize",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "addr", internalType: "address", type: "address" }],
    name: "isAdmin",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "operator", internalType: "address", type: "address" }
    ],
    name: "isApprovedForAll",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "addr", internalType: "address", type: "address" }],
    name: "isManager",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "logicContract",
    outputs: [{ name: "", internalType: "contract ILogic", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "tokenId", internalType: "uint256", type: "uint256" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mint",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "amounts", internalType: "uint256[]", type: "uint256[]" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintBatchWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "amounts", internalType: "uint256[]", type: "uint256[]" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintBatchWithETH",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "tokenId", internalType: "uint256", type: "uint256" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes[]", type: "bytes[]" }],
    name: "multicall",
    outputs: [{ name: "results", internalType: "bytes[]", type: "bytes[]" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "name",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "proxiableUUID",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "callerConfirmation", internalType: "address", type: "address" }
    ],
    name: "renounceRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "revokeRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "from", internalType: "address", type: "address" },
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "values", internalType: "uint256[]", type: "uint256[]" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "safeBatchTransferFrom",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "from", internalType: "address", type: "address" },
      { name: "to", internalType: "address", type: "address" },
      { name: "id", internalType: "uint256", type: "uint256" },
      { name: "value", internalType: "uint256", type: "uint256" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "operator", internalType: "address", type: "address" },
      { name: "approved", internalType: "bool", type: "bool" }
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "fees", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "setFees",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "logic", internalType: "address", type: "address" },
      { name: "creatorLogic", internalType: "bytes", type: "bytes" },
      { name: "minterLogic", internalType: "bytes", type: "bytes" }
    ],
    name: "setLogic",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "managers", internalType: "address[]", type: "address[]" }],
    name: "setManagers",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes", type: "bytes" }],
    name: "setTransportConfig",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      {
        name: "tokenPermission",
        internalType: "struct DeferredTokenAuthorization.DeferredTokenPermission",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "deadline", internalType: "uint256", type: "uint256" },
          { name: "nonce", internalType: "bytes32", type: "bytes32" }
        ]
      },
      { name: "author", internalType: "address", type: "address" },
      { name: "v", internalType: "uint8", type: "uint8" },
      { name: "r", internalType: "bytes32", type: "bytes32" },
      { name: "s", internalType: "bytes32", type: "bytes32" },
      { name: "to", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "sponsorWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      {
        name: "tokenPermission",
        internalType: "struct DeferredTokenAuthorization.DeferredTokenPermission",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "deadline", internalType: "uint256", type: "uint256" },
          { name: "nonce", internalType: "bytes32", type: "bytes32" }
        ]
      },
      { name: "author", internalType: "address", type: "address" },
      { name: "v", internalType: "uint8", type: "uint8" },
      { name: "r", internalType: "bytes32", type: "bytes32" },
      { name: "s", internalType: "bytes32", type: "bytes32" },
      { name: "to", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "sponsorWithETH",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [{ name: "interfaceId", internalType: "bytes4", type: "bytes4" }],
    name: "supportsInterface",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "newAdmin", internalType: "address", type: "address" }],
    name: "transferAdmin",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "channelName", internalType: "string", type: "string" },
      { name: "uri", internalType: "string", type: "string" }
    ],
    name: "updateChannelMetadata",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "newImplementation", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "upgradeToAndCall",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    name: "uri",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "previousAdmin",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "newAdmin",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "AdminTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "approved", internalType: "bool", type: "bool", indexed: false }
    ],
    name: "ApprovalForAll"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "updater",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "channelName",
        internalType: "string",
        type: "string",
        indexed: false
      },
      { name: "uri", internalType: "string", type: "string", indexed: false }
    ],
    name: "ChannelMetadataUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "updater",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "updateType",
        internalType: "enum Channel.ConfigUpdate",
        type: "uint8",
        indexed: true
      },
      {
        name: "feeContract",
        internalType: "address",
        type: "address",
        indexed: false
      },
      {
        name: "logicContract",
        internalType: "address",
        type: "address",
        indexed: false
      }
    ],
    name: "ConfigUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "spender",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      },
      {
        name: "token",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "ERC20Transferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "spender",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      }
    ],
    name: "ETHTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "version",
        internalType: "uint64",
        type: "uint64",
        indexed: false
      }
    ],
    name: "Initialized"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "manager",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "ManagerRenounced"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "managers",
        internalType: "address[]",
        type: "address[]",
        indexed: false
      }
    ],
    name: "ManagersUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "previousAdminRole",
        internalType: "bytes32",
        type: "bytes32",
        indexed: true
      },
      {
        name: "newAdminRole",
        internalType: "bytes32",
        type: "bytes32",
        indexed: true
      }
    ],
    name: "RoleAdminChanged"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "sender",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "RoleGranted"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "sender",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "RoleRevoked"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "tokenId",
        internalType: "uint256",
        type: "uint256",
        indexed: true
      },
      {
        name: "token",
        internalType: "struct ChannelStorage.TokenConfig",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "author", internalType: "address", type: "address" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "totalMinted", internalType: "uint256", type: "uint256" },
          { name: "sponsor", internalType: "address", type: "address" }
        ],
        indexed: false
      }
    ],
    name: "TokenCreated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "minter",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "mintReferral",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "tokenIds",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      {
        name: "amounts",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      { name: "data", internalType: "bytes", type: "bytes", indexed: false }
    ],
    name: "TokenMinted"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "from", internalType: "address", type: "address", indexed: true },
      { name: "to", internalType: "address", type: "address", indexed: true },
      {
        name: "ids",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      {
        name: "values",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      }
    ],
    name: "TransferBatch"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "from", internalType: "address", type: "address", indexed: true },
      { name: "to", internalType: "address", type: "address", indexed: true },
      { name: "id", internalType: "uint256", type: "uint256", indexed: false },
      {
        name: "value",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      }
    ],
    name: "TransferSingle"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "value", internalType: "string", type: "string", indexed: false },
      { name: "id", internalType: "uint256", type: "uint256", indexed: true }
    ],
    name: "URI"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "implementation",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "Upgraded"
  },
  { type: "error", inputs: [], name: "AccessControlBadConfirmation" },
  {
    type: "error",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "neededRole", internalType: "bytes32", type: "bytes32" }
    ],
    name: "AccessControlUnauthorizedAccount"
  },
  {
    type: "error",
    inputs: [{ name: "target", internalType: "address", type: "address" }],
    name: "AddressEmptyCode"
  },
  {
    type: "error",
    inputs: [{ name: "account", internalType: "address", type: "address" }],
    name: "AddressInsufficientBalance"
  },
  { type: "error", inputs: [], name: "AmountExceedsMaxSupply" },
  { type: "error", inputs: [], name: "AmountZero" },
  {
    type: "error",
    inputs: [
      { name: "sender", internalType: "address", type: "address" },
      { name: "balance", internalType: "uint256", type: "uint256" },
      { name: "needed", internalType: "uint256", type: "uint256" },
      { name: "tokenId", internalType: "uint256", type: "uint256" }
    ],
    name: "ERC1155InsufficientBalance"
  },
  {
    type: "error",
    inputs: [{ name: "approver", internalType: "address", type: "address" }],
    name: "ERC1155InvalidApprover"
  },
  {
    type: "error",
    inputs: [
      { name: "idsLength", internalType: "uint256", type: "uint256" },
      { name: "valuesLength", internalType: "uint256", type: "uint256" }
    ],
    name: "ERC1155InvalidArrayLength"
  },
  {
    type: "error",
    inputs: [{ name: "operator", internalType: "address", type: "address" }],
    name: "ERC1155InvalidOperator"
  },
  {
    type: "error",
    inputs: [{ name: "receiver", internalType: "address", type: "address" }],
    name: "ERC1155InvalidReceiver"
  },
  {
    type: "error",
    inputs: [{ name: "sender", internalType: "address", type: "address" }],
    name: "ERC1155InvalidSender"
  },
  {
    type: "error",
    inputs: [
      { name: "operator", internalType: "address", type: "address" },
      { name: "owner", internalType: "address", type: "address" }
    ],
    name: "ERC1155MissingApprovalForAll"
  },
  {
    type: "error",
    inputs: [{ name: "implementation", internalType: "address", type: "address" }],
    name: "ERC1967InvalidImplementation"
  },
  { type: "error", inputs: [], name: "ERC1967NonPayable" },
  { type: "error", inputs: [], name: "ERC20TransferFailed" },
  { type: "error", inputs: [], name: "FailedInnerCall" },
  { type: "error", inputs: [], name: "InsufficientBalance" },
  { type: "error", inputs: [], name: "InsufficientInteractionPower" },
  { type: "error", inputs: [], name: "InvalidAmountSent" },
  { type: "error", inputs: [], name: "InvalidInitialization" },
  { type: "error", inputs: [], name: "InvalidSignature" },
  { type: "error", inputs: [], name: "InvalidTotalAllocation" },
  { type: "error", inputs: [], name: "InvalidUpgrade" },
  { type: "error", inputs: [], name: "NotInitializing" },
  { type: "error", inputs: [], name: "NotMintable" },
  { type: "error", inputs: [], name: "ReentrancyGuardReentrantCall" },
  {
    type: "error",
    inputs: [{ name: "token", internalType: "address", type: "address" }],
    name: "SafeERC20FailedOperation"
  },
  { type: "error", inputs: [], name: "SignatureExpired" },
  { type: "error", inputs: [], name: "SoldOut" },
  { type: "error", inputs: [], name: "SplitLengthMismatch" },
  { type: "error", inputs: [], name: "UUPSUnauthorizedCallContext" },
  {
    type: "error",
    inputs: [{ name: "slot", internalType: "bytes32", type: "bytes32" }],
    name: "UUPSUnsupportedProxiableUUID"
  },
  { type: "error", inputs: [], name: "Unauthorized" }
];
var channelFactoryAbi = [
  {
    type: "constructor",
    inputs: [
      {
        name: "_infiniteChannelImpl",
        internalType: "address",
        type: "address"
      },
      { name: "_finiteChannelImpl", internalType: "address", type: "address" }
    ],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "UPGRADE_INTERFACE_VERSION",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "codeRepository",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractName",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractVersion",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [
      { name: "uri", internalType: "string", type: "string" },
      { name: "name", internalType: "string", type: "string" },
      { name: "defaultAdmin", internalType: "address", type: "address" },
      { name: "managers", internalType: "address[]", type: "address[]" },
      { name: "setupActions", internalType: "bytes[]", type: "bytes[]" },
      { name: "transportConfig", internalType: "bytes", type: "bytes" }
    ],
    name: "createFiniteChannel",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [
      { name: "uri", internalType: "string", type: "string" },
      { name: "name", internalType: "string", type: "string" },
      { name: "defaultAdmin", internalType: "address", type: "address" },
      { name: "managers", internalType: "address[]", type: "address[]" },
      { name: "setupActions", internalType: "bytes[]", type: "bytes[]" },
      { name: "transportConfig", internalType: "bytes", type: "bytes" }
    ],
    name: "createInfiniteChannel",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "finiteChannelImpl",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "infiniteChannelImpl",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "_initOwner", internalType: "address", type: "address" }],
    name: "initialize",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "owner",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "proxiableUUID",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "newOwner", internalType: "address", type: "address" }],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "newImplementation", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "upgradeToAndCall",
    outputs: [],
    stateMutability: "payable"
  },
  { type: "event", anonymous: false, inputs: [], name: "FactoryInitialized" },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "version",
        internalType: "uint64",
        type: "uint64",
        indexed: false
      }
    ],
    name: "Initialized"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "previousOwner",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "newOwner",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "OwnershipTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "contractAddress",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "uri", internalType: "string", type: "string", indexed: false },
      { name: "name", internalType: "string", type: "string", indexed: false },
      {
        name: "defaultAdmin",
        internalType: "address",
        type: "address",
        indexed: false
      },
      {
        name: "managers",
        internalType: "address[]",
        type: "address[]",
        indexed: false
      },
      {
        name: "transportConfig",
        internalType: "bytes",
        type: "bytes",
        indexed: false
      }
    ],
    name: "SetupNewContract"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "implementation",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "Upgraded"
  },
  {
    type: "error",
    inputs: [{ name: "target", internalType: "address", type: "address" }],
    name: "AddressEmptyCode"
  },
  {
    type: "error",
    inputs: [{ name: "account", internalType: "address", type: "address" }],
    name: "AddressInsufficientBalance"
  },
  { type: "error", inputs: [], name: "AddressZero" },
  {
    type: "error",
    inputs: [{ name: "implementation", internalType: "address", type: "address" }],
    name: "ERC1967InvalidImplementation"
  },
  { type: "error", inputs: [], name: "ERC1967NonPayable" },
  { type: "error", inputs: [], name: "ERC20TransferFailed" },
  { type: "error", inputs: [], name: "FailedInnerCall" },
  { type: "error", inputs: [], name: "InvalidInitialization" },
  { type: "error", inputs: [], name: "InvalidUpgrade" },
  { type: "error", inputs: [], name: "NotInitializing" },
  {
    type: "error",
    inputs: [{ name: "owner", internalType: "address", type: "address" }],
    name: "OwnableInvalidOwner"
  },
  {
    type: "error",
    inputs: [{ name: "account", internalType: "address", type: "address" }],
    name: "OwnableUnauthorizedAccount"
  },
  {
    type: "error",
    inputs: [{ name: "token", internalType: "address", type: "address" }],
    name: "SafeERC20FailedOperation"
  },
  { type: "error", inputs: [], name: "UUPSUnauthorizedCallContext" },
  {
    type: "error",
    inputs: [{ name: "slot", internalType: "bytes32", type: "bytes32" }],
    name: "UUPSUnsupportedProxiableUUID"
  }
];
var customFeesAbi = [
  {
    type: "constructor",
    inputs: [
      {
        name: "_uplinkRewardsAddress",
        internalType: "address",
        type: "address"
      }
    ],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "", internalType: "address", type: "address" }],
    name: "channelFees",
    outputs: [
      { name: "channelTreasury", internalType: "address", type: "address" },
      { name: "uplinkBps", internalType: "uint16", type: "uint16" },
      { name: "channelBps", internalType: "uint16", type: "uint16" },
      { name: "creatorBps", internalType: "uint16", type: "uint16" },
      { name: "mintReferralBps", internalType: "uint16", type: "uint16" },
      { name: "sponsorBps", internalType: "uint16", type: "uint16" },
      { name: "ethMintPrice", internalType: "uint256", type: "uint256" },
      { name: "erc20MintPrice", internalType: "uint256", type: "uint256" },
      { name: "erc20Contract", internalType: "address", type: "address" }
    ],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "codeRepository",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractName",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractVersion",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "getErc20MintPrice",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "getEthMintPrice",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "getFeeBps",
    outputs: [
      { name: "", internalType: "uint16", type: "uint16" },
      { name: "", internalType: "uint16", type: "uint16" },
      { name: "", internalType: "uint16", type: "uint16" },
      { name: "", internalType: "uint16", type: "uint16" },
      { name: "", internalType: "uint16", type: "uint16" }
    ],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "creators", internalType: "address[]", type: "address[]" },
      { name: "sponsors", internalType: "address[]", type: "address[]" },
      { name: "amounts", internalType: "uint256[]", type: "uint256[]" },
      { name: "mintReferral", internalType: "address", type: "address" }
    ],
    name: "requestErc20Mint",
    outputs: [
      {
        name: "",
        internalType: "struct Rewards.Split",
        type: "tuple",
        components: [
          { name: "recipients", internalType: "address[]", type: "address[]" },
          { name: "allocations", internalType: "uint256[]", type: "uint256[]" },
          { name: "totalAllocation", internalType: "uint256", type: "uint256" },
          { name: "token", internalType: "address", type: "address" }
        ]
      }
    ],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "creators", internalType: "address[]", type: "address[]" },
      { name: "sponsors", internalType: "address[]", type: "address[]" },
      { name: "amounts", internalType: "uint256[]", type: "uint256[]" },
      { name: "mintReferral", internalType: "address", type: "address" }
    ],
    name: "requestEthMint",
    outputs: [
      {
        name: "",
        internalType: "struct Rewards.Split",
        type: "tuple",
        components: [
          { name: "recipients", internalType: "address[]", type: "address[]" },
          { name: "allocations", internalType: "uint256[]", type: "uint256[]" },
          { name: "totalAllocation", internalType: "uint256", type: "uint256" },
          { name: "token", internalType: "address", type: "address" }
        ]
      }
    ],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes", type: "bytes" }],
    name: "setChannelFees",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "channel",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "feeconfig",
        internalType: "struct CustomFees.FeeConfig",
        type: "tuple",
        components: [
          { name: "channelTreasury", internalType: "address", type: "address" },
          { name: "uplinkBps", internalType: "uint16", type: "uint16" },
          { name: "channelBps", internalType: "uint16", type: "uint16" },
          { name: "creatorBps", internalType: "uint16", type: "uint16" },
          { name: "mintReferralBps", internalType: "uint16", type: "uint16" },
          { name: "sponsorBps", internalType: "uint16", type: "uint16" },
          { name: "ethMintPrice", internalType: "uint256", type: "uint256" },
          { name: "erc20MintPrice", internalType: "uint256", type: "uint256" },
          { name: "erc20Contract", internalType: "address", type: "address" }
        ],
        indexed: false
      }
    ],
    name: "FeeConfigSet"
  },
  { type: "error", inputs: [], name: "AddressZero" },
  { type: "error", inputs: [], name: "ERC20MintingDisabled" },
  { type: "error", inputs: [], name: "InvalidBps" },
  { type: "error", inputs: [], name: "InvalidETHMintPrice" },
  { type: "error", inputs: [], name: "InvalidSplit" },
  { type: "error", inputs: [], name: "TotalValueMismatch" }
];
var dynamicLogicAbi = [
  {
    type: "constructor",
    inputs: [{ name: "_initOwner", internalType: "address", type: "address" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "signature", internalType: "bytes4", type: "bytes4" },
      {
        name: "calldataAddressPosition",
        internalType: "uint256",
        type: "uint256"
      }
    ],
    name: "approveLogic",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "user", internalType: "address", type: "address" }],
    name: "calculateCreatorInteractionPower",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "user", internalType: "address", type: "address" }],
    name: "calculateMinterInteractionPower",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "codeRepository",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractName",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractVersion",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "owner",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes", type: "bytes" }],
    name: "setCreatorLogic",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes", type: "bytes" }],
    name: "setMinterLogic",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "newOwner", internalType: "address", type: "address" }],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "channel",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "logic",
        internalType: "struct DynamicLogic.InteractionLogic",
        type: "tuple",
        components: [
          { name: "targets", internalType: "address[]", type: "address[]" },
          { name: "signatures", internalType: "bytes4[]", type: "bytes4[]" },
          { name: "datas", internalType: "bytes[]", type: "bytes[]" },
          {
            name: "operators",
            internalType: "enum DynamicLogic.Operator[]",
            type: "uint8[]"
          },
          { name: "literalOperands", internalType: "bytes[]", type: "bytes[]" },
          {
            name: "interactionPowerTypes",
            internalType: "enum DynamicLogic.InteractionPowerType[]",
            type: "uint8[]"
          },
          {
            name: "interactionPowers",
            internalType: "uint256[]",
            type: "uint256[]"
          }
        ],
        indexed: false
      }
    ],
    name: "CreatorLogicSet"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "channel",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "logic",
        internalType: "struct DynamicLogic.InteractionLogic",
        type: "tuple",
        components: [
          { name: "targets", internalType: "address[]", type: "address[]" },
          { name: "signatures", internalType: "bytes4[]", type: "bytes4[]" },
          { name: "datas", internalType: "bytes[]", type: "bytes[]" },
          {
            name: "operators",
            internalType: "enum DynamicLogic.Operator[]",
            type: "uint8[]"
          },
          { name: "literalOperands", internalType: "bytes[]", type: "bytes[]" },
          {
            name: "interactionPowerTypes",
            internalType: "enum DynamicLogic.InteractionPowerType[]",
            type: "uint8[]"
          },
          {
            name: "interactionPowers",
            internalType: "uint256[]",
            type: "uint256[]"
          }
        ],
        indexed: false
      }
    ],
    name: "MinterLogicSet"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "previousOwner",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "newOwner",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "OwnershipTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "signature",
        internalType: "bytes4",
        type: "bytes4",
        indexed: false
      },
      {
        name: "calldataAddressPosition",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      }
    ],
    name: "SignatureApproved"
  },
  { type: "error", inputs: [], name: "CallFailed" },
  { type: "error", inputs: [], name: "InvalidSignature" },
  {
    type: "error",
    inputs: [{ name: "owner", internalType: "address", type: "address" }],
    name: "OwnableInvalidOwner"
  },
  {
    type: "error",
    inputs: [{ name: "account", internalType: "address", type: "address" }],
    name: "OwnableUnauthorizedAccount"
  }
];
var finiteChannelAbi = [
  {
    type: "constructor",
    inputs: [
      { name: "_upgradePath", internalType: "address", type: "address" },
      { name: "_weth", internalType: "address", type: "address" }
    ],
    stateMutability: "nonpayable"
  },
  { type: "fallback", stateMutability: "payable" },
  { type: "receive", stateMutability: "payable" },
  {
    type: "function",
    inputs: [],
    name: "DEFAULT_ADMIN_ROLE",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "DEFERRED_TOKEN_TYPEHASH",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "DOMAIN_SEPARATOR",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "EIP712_DOMAIN_TYPEHASH",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "MANAGER_ROLE",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "UPGRADE_INTERFACE_VERSION",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "id", internalType: "uint256", type: "uint256" }
    ],
    name: "balanceOf",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "accounts", internalType: "address[]", type: "address[]" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" }
    ],
    name: "balanceOfBatch",
    outputs: [{ name: "", internalType: "uint256[]", type: "uint256[]" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "codeRepository",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractName",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractURI",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "contractVersion",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [
      { name: "uri", internalType: "string", type: "string" },
      { name: "maxSupply", internalType: "uint256", type: "uint256" }
    ],
    name: "createToken",
    outputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "", internalType: "address", type: "address" }],
    name: "erc20Balances",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "feeContract",
    outputs: [{ name: "", internalType: "contract IFees", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "finiteChannelParams",
    outputs: [
      { name: "createStart", internalType: "uint40", type: "uint40" },
      { name: "mintStart", internalType: "uint40", type: "uint40" },
      { name: "mintEnd", internalType: "uint40", type: "uint40" },
      {
        name: "rewards",
        internalType: "struct FiniteChannel.FiniteRewards",
        type: "tuple",
        components: [
          { name: "ranks", internalType: "uint40[]", type: "uint40[]" },
          { name: "allocations", internalType: "uint256[]", type: "uint256[]" },
          { name: "totalAllocation", internalType: "uint256", type: "uint256" },
          { name: "token", internalType: "address", type: "address" }
        ]
      }
    ],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "role", internalType: "bytes32", type: "bytes32" }],
    name: "getRoleAdmin",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "index", internalType: "uint256", type: "uint256" }
    ],
    name: "getRoleMember",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "role", internalType: "bytes32", type: "bytes32" }],
    name: "getRoleMemberCount",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    name: "getToken",
    outputs: [
      {
        name: "",
        internalType: "struct ChannelStorage.TokenConfig",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "author", internalType: "address", type: "address" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "totalMinted", internalType: "uint256", type: "uint256" },
          { name: "sponsor", internalType: "address", type: "address" }
        ]
      }
    ],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "grantRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "hasRole",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "uri", internalType: "string", type: "string" },
      { name: "name", internalType: "string", type: "string" },
      { name: "defaultAdmin", internalType: "address", type: "address" },
      { name: "managers", internalType: "address[]", type: "address[]" },
      { name: "setupActions", internalType: "bytes[]", type: "bytes[]" },
      { name: "transportConfig", internalType: "bytes", type: "bytes" }
    ],
    name: "initialize",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "addr", internalType: "address", type: "address" }],
    name: "isAdmin",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "operator", internalType: "address", type: "address" }
    ],
    name: "isApprovedForAll",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "addr", internalType: "address", type: "address" }],
    name: "isManager",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "logicContract",
    outputs: [{ name: "", internalType: "contract ILogic", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "tokenId", internalType: "uint256", type: "uint256" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mint",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "amounts", internalType: "uint256[]", type: "uint256[]" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintBatchWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "amounts", internalType: "uint256[]", type: "uint256[]" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintBatchWithETH",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "tokenId", internalType: "uint256", type: "uint256" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes[]", type: "bytes[]" }],
    name: "multicall",
    outputs: [{ name: "results", internalType: "bytes[]", type: "bytes[]" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "name",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "proxiableUUID",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "callerConfirmation", internalType: "address", type: "address" }
    ],
    name: "renounceRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "revokeRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "from", internalType: "address", type: "address" },
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "values", internalType: "uint256[]", type: "uint256[]" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "safeBatchTransferFrom",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "from", internalType: "address", type: "address" },
      { name: "to", internalType: "address", type: "address" },
      { name: "id", internalType: "uint256", type: "uint256" },
      { name: "value", internalType: "uint256", type: "uint256" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "operator", internalType: "address", type: "address" },
      { name: "approved", internalType: "bool", type: "bool" }
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "fees", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "setFees",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "logic", internalType: "address", type: "address" },
      { name: "creatorLogic", internalType: "bytes", type: "bytes" },
      { name: "minterLogic", internalType: "bytes", type: "bytes" }
    ],
    name: "setLogic",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "managers", internalType: "address[]", type: "address[]" }],
    name: "setManagers",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes", type: "bytes" }],
    name: "setTransportConfig",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "settle",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      {
        name: "tokenPermission",
        internalType: "struct DeferredTokenAuthorization.DeferredTokenPermission",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "deadline", internalType: "uint256", type: "uint256" },
          { name: "nonce", internalType: "bytes32", type: "bytes32" }
        ]
      },
      { name: "author", internalType: "address", type: "address" },
      { name: "v", internalType: "uint8", type: "uint8" },
      { name: "r", internalType: "bytes32", type: "bytes32" },
      { name: "s", internalType: "bytes32", type: "bytes32" },
      { name: "to", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "sponsorWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      {
        name: "tokenPermission",
        internalType: "struct DeferredTokenAuthorization.DeferredTokenPermission",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "deadline", internalType: "uint256", type: "uint256" },
          { name: "nonce", internalType: "bytes32", type: "bytes32" }
        ]
      },
      { name: "author", internalType: "address", type: "address" },
      { name: "v", internalType: "uint8", type: "uint8" },
      { name: "r", internalType: "bytes32", type: "bytes32" },
      { name: "s", internalType: "bytes32", type: "bytes32" },
      { name: "to", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "sponsorWithETH",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [{ name: "interfaceId", internalType: "bytes4", type: "bytes4" }],
    name: "supportsInterface",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "newAdmin", internalType: "address", type: "address" }],
    name: "transferAdmin",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "channelName", internalType: "string", type: "string" },
      { name: "uri", internalType: "string", type: "string" }
    ],
    name: "updateChannelMetadata",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "newImplementation", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "upgradeToAndCall",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    name: "uri",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "token", internalType: "address", type: "address" },
      { name: "to", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" }
    ],
    name: "withdrawRewards",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "previousAdmin",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "newAdmin",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "AdminTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "approved", internalType: "bool", type: "bool", indexed: false }
    ],
    name: "ApprovalForAll"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "updater",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "channelName",
        internalType: "string",
        type: "string",
        indexed: false
      },
      { name: "uri", internalType: "string", type: "string", indexed: false }
    ],
    name: "ChannelMetadataUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "updater",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "updateType",
        internalType: "enum Channel.ConfigUpdate",
        type: "uint8",
        indexed: true
      },
      {
        name: "feeContract",
        internalType: "address",
        type: "address",
        indexed: false
      },
      {
        name: "logicContract",
        internalType: "address",
        type: "address",
        indexed: false
      }
    ],
    name: "ConfigUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "spender",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      },
      {
        name: "token",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "ERC20Transferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "spender",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      }
    ],
    name: "ETHTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "version",
        internalType: "uint64",
        type: "uint64",
        indexed: false
      }
    ],
    name: "Initialized"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "manager",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "ManagerRenounced"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "managers",
        internalType: "address[]",
        type: "address[]",
        indexed: false
      }
    ],
    name: "ManagersUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "previousAdminRole",
        internalType: "bytes32",
        type: "bytes32",
        indexed: true
      },
      {
        name: "newAdminRole",
        internalType: "bytes32",
        type: "bytes32",
        indexed: true
      }
    ],
    name: "RoleAdminChanged"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "sender",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "RoleGranted"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "sender",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "RoleRevoked"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "caller",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "Settled"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "tokenId",
        internalType: "uint256",
        type: "uint256",
        indexed: true
      },
      {
        name: "token",
        internalType: "struct ChannelStorage.TokenConfig",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "author", internalType: "address", type: "address" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "totalMinted", internalType: "uint256", type: "uint256" },
          { name: "sponsor", internalType: "address", type: "address" }
        ],
        indexed: false
      }
    ],
    name: "TokenCreated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "minter",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "mintReferral",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "tokenIds",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      {
        name: "amounts",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      { name: "data", internalType: "bytes", type: "bytes", indexed: false }
    ],
    name: "TokenMinted"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "from", internalType: "address", type: "address", indexed: true },
      { name: "to", internalType: "address", type: "address", indexed: true },
      {
        name: "ids",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      {
        name: "values",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      }
    ],
    name: "TransferBatch"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "from", internalType: "address", type: "address", indexed: true },
      { name: "to", internalType: "address", type: "address", indexed: true },
      { name: "id", internalType: "uint256", type: "uint256", indexed: false },
      {
        name: "value",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      }
    ],
    name: "TransferSingle"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "value", internalType: "string", type: "string", indexed: false },
      { name: "id", internalType: "uint256", type: "uint256", indexed: true }
    ],
    name: "URI"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "implementation",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "Upgraded"
  },
  { type: "error", inputs: [], name: "AccessControlBadConfirmation" },
  {
    type: "error",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "neededRole", internalType: "bytes32", type: "bytes32" }
    ],
    name: "AccessControlUnauthorizedAccount"
  },
  {
    type: "error",
    inputs: [{ name: "target", internalType: "address", type: "address" }],
    name: "AddressEmptyCode"
  },
  {
    type: "error",
    inputs: [{ name: "account", internalType: "address", type: "address" }],
    name: "AddressInsufficientBalance"
  },
  { type: "error", inputs: [], name: "AlreadySettled" },
  { type: "error", inputs: [], name: "AmountExceedsMaxSupply" },
  { type: "error", inputs: [], name: "AmountZero" },
  {
    type: "error",
    inputs: [
      { name: "sender", internalType: "address", type: "address" },
      { name: "balance", internalType: "uint256", type: "uint256" },
      { name: "needed", internalType: "uint256", type: "uint256" },
      { name: "tokenId", internalType: "uint256", type: "uint256" }
    ],
    name: "ERC1155InsufficientBalance"
  },
  {
    type: "error",
    inputs: [{ name: "approver", internalType: "address", type: "address" }],
    name: "ERC1155InvalidApprover"
  },
  {
    type: "error",
    inputs: [
      { name: "idsLength", internalType: "uint256", type: "uint256" },
      { name: "valuesLength", internalType: "uint256", type: "uint256" }
    ],
    name: "ERC1155InvalidArrayLength"
  },
  {
    type: "error",
    inputs: [{ name: "operator", internalType: "address", type: "address" }],
    name: "ERC1155InvalidOperator"
  },
  {
    type: "error",
    inputs: [{ name: "receiver", internalType: "address", type: "address" }],
    name: "ERC1155InvalidReceiver"
  },
  {
    type: "error",
    inputs: [{ name: "sender", internalType: "address", type: "address" }],
    name: "ERC1155InvalidSender"
  },
  {
    type: "error",
    inputs: [
      { name: "operator", internalType: "address", type: "address" },
      { name: "owner", internalType: "address", type: "address" }
    ],
    name: "ERC1155MissingApprovalForAll"
  },
  {
    type: "error",
    inputs: [{ name: "implementation", internalType: "address", type: "address" }],
    name: "ERC1967InvalidImplementation"
  },
  { type: "error", inputs: [], name: "ERC1967NonPayable" },
  { type: "error", inputs: [], name: "ERC20TransferFailed" },
  { type: "error", inputs: [], name: "FailedInnerCall" },
  { type: "error", inputs: [], name: "InsufficientBalance" },
  { type: "error", inputs: [], name: "InsufficientInteractionPower" },
  { type: "error", inputs: [], name: "InvalidAmountSent" },
  { type: "error", inputs: [], name: "InvalidInitialization" },
  { type: "error", inputs: [], name: "InvalidRewards" },
  { type: "error", inputs: [], name: "InvalidSignature" },
  { type: "error", inputs: [], name: "InvalidTiming" },
  { type: "error", inputs: [], name: "InvalidTotalAllocation" },
  { type: "error", inputs: [], name: "InvalidUpgrade" },
  { type: "error", inputs: [], name: "NotAcceptingCreations" },
  { type: "error", inputs: [], name: "NotAcceptingMints" },
  { type: "error", inputs: [], name: "NotInitializing" },
  { type: "error", inputs: [], name: "NotMintable" },
  { type: "error", inputs: [], name: "ReentrancyGuardReentrantCall" },
  {
    type: "error",
    inputs: [{ name: "token", internalType: "address", type: "address" }],
    name: "SafeERC20FailedOperation"
  },
  { type: "error", inputs: [], name: "SignatureExpired" },
  { type: "error", inputs: [], name: "SoldOut" },
  { type: "error", inputs: [], name: "SplitLengthMismatch" },
  { type: "error", inputs: [], name: "StillActive" },
  { type: "error", inputs: [], name: "UUPSUnauthorizedCallContext" },
  {
    type: "error",
    inputs: [{ name: "slot", internalType: "bytes32", type: "bytes32" }],
    name: "UUPSUnsupportedProxiableUUID"
  },
  { type: "error", inputs: [], name: "Unauthorized" }
];
var infiniteChannelAbi = [
  {
    type: "constructor",
    inputs: [
      { name: "_updgradePath", internalType: "address", type: "address" },
      { name: "_weth", internalType: "address", type: "address" }
    ],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "DEFAULT_ADMIN_ROLE",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "DEFERRED_TOKEN_TYPEHASH",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "DOMAIN_SEPARATOR",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "EIP712_DOMAIN_TYPEHASH",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "MANAGER_ROLE",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "UPGRADE_INTERFACE_VERSION",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "id", internalType: "uint256", type: "uint256" }
    ],
    name: "balanceOf",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "accounts", internalType: "address[]", type: "address[]" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" }
    ],
    name: "balanceOfBatch",
    outputs: [{ name: "", internalType: "uint256[]", type: "uint256[]" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "codeRepository",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractName",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractURI",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "contractVersion",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [
      { name: "uri", internalType: "string", type: "string" },
      { name: "maxSupply", internalType: "uint256", type: "uint256" }
    ],
    name: "createToken",
    outputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "", internalType: "address", type: "address" }],
    name: "erc20Balances",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "feeContract",
    outputs: [{ name: "", internalType: "contract IFees", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "role", internalType: "bytes32", type: "bytes32" }],
    name: "getRoleAdmin",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "index", internalType: "uint256", type: "uint256" }
    ],
    name: "getRoleMember",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "role", internalType: "bytes32", type: "bytes32" }],
    name: "getRoleMemberCount",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    name: "getToken",
    outputs: [
      {
        name: "",
        internalType: "struct ChannelStorage.TokenConfig",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "author", internalType: "address", type: "address" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "totalMinted", internalType: "uint256", type: "uint256" },
          { name: "sponsor", internalType: "address", type: "address" }
        ]
      }
    ],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "grantRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "hasRole",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "uri", internalType: "string", type: "string" },
      { name: "name", internalType: "string", type: "string" },
      { name: "defaultAdmin", internalType: "address", type: "address" },
      { name: "managers", internalType: "address[]", type: "address[]" },
      { name: "setupActions", internalType: "bytes[]", type: "bytes[]" },
      { name: "transportConfig", internalType: "bytes", type: "bytes" }
    ],
    name: "initialize",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "addr", internalType: "address", type: "address" }],
    name: "isAdmin",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "operator", internalType: "address", type: "address" }
    ],
    name: "isApprovedForAll",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "addr", internalType: "address", type: "address" }],
    name: "isManager",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "logicContract",
    outputs: [{ name: "", internalType: "contract ILogic", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "tokenId", internalType: "uint256", type: "uint256" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mint",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "amounts", internalType: "uint256[]", type: "uint256[]" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintBatchWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "amounts", internalType: "uint256[]", type: "uint256[]" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintBatchWithETH",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [
      { name: "to", internalType: "address", type: "address" },
      { name: "tokenId", internalType: "uint256", type: "uint256" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "mintWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes[]", type: "bytes[]" }],
    name: "multicall",
    outputs: [{ name: "results", internalType: "bytes[]", type: "bytes[]" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "name",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "proxiableUUID",
    outputs: [{ name: "", internalType: "bytes32", type: "bytes32" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "callerConfirmation", internalType: "address", type: "address" }
    ],
    name: "renounceRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32" },
      { name: "account", internalType: "address", type: "address" }
    ],
    name: "revokeRole",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "from", internalType: "address", type: "address" },
      { name: "to", internalType: "address", type: "address" },
      { name: "ids", internalType: "uint256[]", type: "uint256[]" },
      { name: "values", internalType: "uint256[]", type: "uint256[]" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "safeBatchTransferFrom",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "from", internalType: "address", type: "address" },
      { name: "to", internalType: "address", type: "address" },
      { name: "id", internalType: "uint256", type: "uint256" },
      { name: "value", internalType: "uint256", type: "uint256" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "safeTransferFrom",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "saleDuration",
    outputs: [{ name: "", internalType: "uint40", type: "uint40" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    name: "saleEnd",
    outputs: [{ name: "", internalType: "uint40", type: "uint40" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "operator", internalType: "address", type: "address" },
      { name: "approved", internalType: "bool", type: "bool" }
    ],
    name: "setApprovalForAll",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "fees", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "setFees",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "logic", internalType: "address", type: "address" },
      { name: "creatorLogic", internalType: "bytes", type: "bytes" },
      { name: "minterLogic", internalType: "bytes", type: "bytes" }
    ],
    name: "setLogic",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "managers", internalType: "address[]", type: "address[]" }],
    name: "setManagers",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "data", internalType: "bytes", type: "bytes" }],
    name: "setTransportConfig",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      {
        name: "tokenPermission",
        internalType: "struct DeferredTokenAuthorization.DeferredTokenPermission",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "deadline", internalType: "uint256", type: "uint256" },
          { name: "nonce", internalType: "bytes32", type: "bytes32" }
        ]
      },
      { name: "author", internalType: "address", type: "address" },
      { name: "v", internalType: "uint8", type: "uint8" },
      { name: "r", internalType: "bytes32", type: "bytes32" },
      { name: "s", internalType: "bytes32", type: "bytes32" },
      { name: "to", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "sponsorWithERC20",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      {
        name: "tokenPermission",
        internalType: "struct DeferredTokenAuthorization.DeferredTokenPermission",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "deadline", internalType: "uint256", type: "uint256" },
          { name: "nonce", internalType: "bytes32", type: "bytes32" }
        ]
      },
      { name: "author", internalType: "address", type: "address" },
      { name: "v", internalType: "uint8", type: "uint8" },
      { name: "r", internalType: "bytes32", type: "bytes32" },
      { name: "s", internalType: "bytes32", type: "bytes32" },
      { name: "to", internalType: "address", type: "address" },
      { name: "amount", internalType: "uint256", type: "uint256" },
      { name: "mintReferral", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "sponsorWithETH",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [{ name: "interfaceId", internalType: "bytes4", type: "bytes4" }],
    name: "supportsInterface",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [{ name: "newAdmin", internalType: "address", type: "address" }],
    name: "transferAdmin",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "channelName", internalType: "string", type: "string" },
      { name: "uri", internalType: "string", type: "string" }
    ],
    name: "updateChannelMetadata",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "newImplementation", internalType: "address", type: "address" },
      { name: "data", internalType: "bytes", type: "bytes" }
    ],
    name: "upgradeToAndCall",
    outputs: [],
    stateMutability: "payable"
  },
  {
    type: "function",
    inputs: [{ name: "tokenId", internalType: "uint256", type: "uint256" }],
    name: "uri",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "view"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "previousAdmin",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "newAdmin",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "AdminTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "approved", internalType: "bool", type: "bool", indexed: false }
    ],
    name: "ApprovalForAll"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "updater",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "channelName",
        internalType: "string",
        type: "string",
        indexed: false
      },
      { name: "uri", internalType: "string", type: "string", indexed: false }
    ],
    name: "ChannelMetadataUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "updater",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "updateType",
        internalType: "enum Channel.ConfigUpdate",
        type: "uint8",
        indexed: true
      },
      {
        name: "feeContract",
        internalType: "address",
        type: "address",
        indexed: false
      },
      {
        name: "logicContract",
        internalType: "address",
        type: "address",
        indexed: false
      }
    ],
    name: "ConfigUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "spender",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      },
      {
        name: "token",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "ERC20Transferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "spender",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      }
    ],
    name: "ETHTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "version",
        internalType: "uint64",
        type: "uint64",
        indexed: false
      }
    ],
    name: "Initialized"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "manager",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "ManagerRenounced"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "managers",
        internalType: "address[]",
        type: "address[]",
        indexed: false
      }
    ],
    name: "ManagersUpdated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "previousAdminRole",
        internalType: "bytes32",
        type: "bytes32",
        indexed: true
      },
      {
        name: "newAdminRole",
        internalType: "bytes32",
        type: "bytes32",
        indexed: true
      }
    ],
    name: "RoleAdminChanged"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "sender",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "RoleGranted"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "role", internalType: "bytes32", type: "bytes32", indexed: true },
      {
        name: "account",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "sender",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "RoleRevoked"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "tokenId",
        internalType: "uint256",
        type: "uint256",
        indexed: true
      },
      {
        name: "token",
        internalType: "struct ChannelStorage.TokenConfig",
        type: "tuple",
        components: [
          { name: "uri", internalType: "string", type: "string" },
          { name: "author", internalType: "address", type: "address" },
          { name: "maxSupply", internalType: "uint256", type: "uint256" },
          { name: "totalMinted", internalType: "uint256", type: "uint256" },
          { name: "sponsor", internalType: "address", type: "address" }
        ],
        indexed: false
      }
    ],
    name: "TokenCreated"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "minter",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "mintReferral",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "tokenIds",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      {
        name: "amounts",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      { name: "data", internalType: "bytes", type: "bytes", indexed: false }
    ],
    name: "TokenMinted"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "caller",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "tokenId",
        internalType: "uint256",
        type: "uint256",
        indexed: true
      },
      {
        name: "saleEnd",
        internalType: "uint40",
        type: "uint40",
        indexed: false
      }
    ],
    name: "TokenSaleSet"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "from", internalType: "address", type: "address", indexed: true },
      { name: "to", internalType: "address", type: "address", indexed: true },
      {
        name: "ids",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      },
      {
        name: "values",
        internalType: "uint256[]",
        type: "uint256[]",
        indexed: false
      }
    ],
    name: "TransferBatch"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "operator",
        internalType: "address",
        type: "address",
        indexed: true
      },
      { name: "from", internalType: "address", type: "address", indexed: true },
      { name: "to", internalType: "address", type: "address", indexed: true },
      { name: "id", internalType: "uint256", type: "uint256", indexed: false },
      {
        name: "value",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      }
    ],
    name: "TransferSingle"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      { name: "value", internalType: "string", type: "string", indexed: false },
      { name: "id", internalType: "uint256", type: "uint256", indexed: true }
    ],
    name: "URI"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "implementation",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "Upgraded"
  },
  { type: "error", inputs: [], name: "AccessControlBadConfirmation" },
  {
    type: "error",
    inputs: [
      { name: "account", internalType: "address", type: "address" },
      { name: "neededRole", internalType: "bytes32", type: "bytes32" }
    ],
    name: "AccessControlUnauthorizedAccount"
  },
  {
    type: "error",
    inputs: [{ name: "target", internalType: "address", type: "address" }],
    name: "AddressEmptyCode"
  },
  {
    type: "error",
    inputs: [{ name: "account", internalType: "address", type: "address" }],
    name: "AddressInsufficientBalance"
  },
  { type: "error", inputs: [], name: "AmountExceedsMaxSupply" },
  { type: "error", inputs: [], name: "AmountZero" },
  {
    type: "error",
    inputs: [
      { name: "sender", internalType: "address", type: "address" },
      { name: "balance", internalType: "uint256", type: "uint256" },
      { name: "needed", internalType: "uint256", type: "uint256" },
      { name: "tokenId", internalType: "uint256", type: "uint256" }
    ],
    name: "ERC1155InsufficientBalance"
  },
  {
    type: "error",
    inputs: [{ name: "approver", internalType: "address", type: "address" }],
    name: "ERC1155InvalidApprover"
  },
  {
    type: "error",
    inputs: [
      { name: "idsLength", internalType: "uint256", type: "uint256" },
      { name: "valuesLength", internalType: "uint256", type: "uint256" }
    ],
    name: "ERC1155InvalidArrayLength"
  },
  {
    type: "error",
    inputs: [{ name: "operator", internalType: "address", type: "address" }],
    name: "ERC1155InvalidOperator"
  },
  {
    type: "error",
    inputs: [{ name: "receiver", internalType: "address", type: "address" }],
    name: "ERC1155InvalidReceiver"
  },
  {
    type: "error",
    inputs: [{ name: "sender", internalType: "address", type: "address" }],
    name: "ERC1155InvalidSender"
  },
  {
    type: "error",
    inputs: [
      { name: "operator", internalType: "address", type: "address" },
      { name: "owner", internalType: "address", type: "address" }
    ],
    name: "ERC1155MissingApprovalForAll"
  },
  {
    type: "error",
    inputs: [{ name: "implementation", internalType: "address", type: "address" }],
    name: "ERC1967InvalidImplementation"
  },
  { type: "error", inputs: [], name: "ERC1967NonPayable" },
  { type: "error", inputs: [], name: "ERC20TransferFailed" },
  { type: "error", inputs: [], name: "FailedInnerCall" },
  { type: "error", inputs: [], name: "InsufficientBalance" },
  { type: "error", inputs: [], name: "InsufficientInteractionPower" },
  { type: "error", inputs: [], name: "InvalidAmountSent" },
  { type: "error", inputs: [], name: "InvalidInitialization" },
  { type: "error", inputs: [], name: "InvalidSignature" },
  { type: "error", inputs: [], name: "InvalidTiming" },
  { type: "error", inputs: [], name: "InvalidTotalAllocation" },
  { type: "error", inputs: [], name: "InvalidUpgrade" },
  { type: "error", inputs: [], name: "NotInitializing" },
  { type: "error", inputs: [], name: "NotMintable" },
  { type: "error", inputs: [], name: "ReentrancyGuardReentrantCall" },
  {
    type: "error",
    inputs: [{ name: "token", internalType: "address", type: "address" }],
    name: "SafeERC20FailedOperation"
  },
  { type: "error", inputs: [], name: "SaleOver" },
  { type: "error", inputs: [], name: "SignatureExpired" },
  { type: "error", inputs: [], name: "SoldOut" },
  { type: "error", inputs: [], name: "SplitLengthMismatch" },
  { type: "error", inputs: [], name: "UUPSUnauthorizedCallContext" },
  {
    type: "error",
    inputs: [{ name: "slot", internalType: "bytes32", type: "bytes32" }],
    name: "UUPSUnsupportedProxiableUUID"
  },
  { type: "error", inputs: [], name: "Unauthorized" }
];
var rewardsAbi = [
  {
    type: "constructor",
    inputs: [{ name: "weth", internalType: "address", type: "address" }],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "", internalType: "address", type: "address" }],
    name: "erc20Balances",
    outputs: [{ name: "", internalType: "uint256", type: "uint256" }],
    stateMutability: "view"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "spender",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      },
      {
        name: "token",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "ERC20Transferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "spender",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "recipient",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "amount",
        internalType: "uint256",
        type: "uint256",
        indexed: false
      }
    ],
    name: "ETHTransferred"
  },
  { type: "error", inputs: [], name: "ERC20TransferFailed" },
  { type: "error", inputs: [], name: "InsufficientBalance" },
  { type: "error", inputs: [], name: "InvalidAmountSent" },
  { type: "error", inputs: [], name: "InvalidTotalAllocation" },
  { type: "error", inputs: [], name: "SplitLengthMismatch" }
];
var upgradePathAbi = [
  { type: "constructor", inputs: [], stateMutability: "nonpayable" },
  {
    type: "function",
    inputs: [],
    name: "codeRepository",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractName",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [],
    name: "contractVersion",
    outputs: [{ name: "", internalType: "string", type: "string" }],
    stateMutability: "pure"
  },
  {
    type: "function",
    inputs: [{ name: "_initOwner", internalType: "address", type: "address" }],
    name: "initialize",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "", internalType: "address", type: "address" },
      { name: "", internalType: "address", type: "address" }
    ],
    name: "isAllowedUpgrade",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "baseImpl", internalType: "address", type: "address" },
      { name: "upgradeImpl", internalType: "address", type: "address" }
    ],
    name: "isRegisteredUpgradePath",
    outputs: [{ name: "", internalType: "bool", type: "bool" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [],
    name: "owner",
    outputs: [{ name: "", internalType: "address", type: "address" }],
    stateMutability: "view"
  },
  {
    type: "function",
    inputs: [
      { name: "baseImpls", internalType: "address[]", type: "address[]" },
      { name: "upgradeImpl", internalType: "address", type: "address" }
    ],
    name: "registerUpgradePath",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [
      { name: "baseImpl", internalType: "address", type: "address" },
      { name: "upgradeImpl", internalType: "address", type: "address" }
    ],
    name: "removeUpgradePath",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "function",
    inputs: [{ name: "newOwner", internalType: "address", type: "address" }],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "version",
        internalType: "uint64",
        type: "uint64",
        indexed: false
      }
    ],
    name: "Initialized"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "previousOwner",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "newOwner",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "OwnershipTransferred"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [],
    name: "UpgradePathContractInitialized"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "baseImpl",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "upgradeImpl",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "UpgradeRegistered"
  },
  {
    type: "event",
    anonymous: false,
    inputs: [
      {
        name: "baseImpl",
        internalType: "address",
        type: "address",
        indexed: true
      },
      {
        name: "upgradeImpl",
        internalType: "address",
        type: "address",
        indexed: true
      }
    ],
    name: "UpgradeRemoved"
  },
  { type: "error", inputs: [], name: "InvalidInitialization" },
  { type: "error", inputs: [], name: "NotInitializing" },
  {
    type: "error",
    inputs: [{ name: "owner", internalType: "address", type: "address" }],
    name: "OwnableInvalidOwner"
  },
  {
    type: "error",
    inputs: [{ name: "account", internalType: "address", type: "address" }],
    name: "OwnableUnauthorizedAccount"
  }
];
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  channelAbi,
  channelFactoryAbi,
  customFeesAbi,
  dynamicLogicAbi,
  finiteChannelAbi,
  infiniteChannelAbi,
  rewardsAbi,
  upgradePathAbi
});
//# sourceMappingURL=index.cjs.map