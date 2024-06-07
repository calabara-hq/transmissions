export declare const channelAbi: readonly [{
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "DEFAULT_ADMIN_ROLE";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "MANAGER_ROLE";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "UPGRADE_INTERFACE_VERSION";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "balanceOf";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "accounts";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }];
    readonly name: "balanceOfBatch";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "author";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "maxSupply";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "createToken";
    readonly outputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "erc20Balances";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "erc20MintPrice";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "ethMintPrice";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "feeContract";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "contract IFees";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "getRoleAdmin";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "index";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "getRoleMember";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "getRoleMemberCount";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "getToken";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "struct ChannelStorage.TokenConfig";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "uri";
            readonly internalType: "string";
            readonly type: "string";
        }, {
            readonly name: "author";
            readonly internalType: "address";
            readonly type: "address";
        }, {
            readonly name: "maxSupply";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "totalMinted";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "sponsor";
            readonly internalType: "address";
            readonly type: "address";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "user";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "getUserStats";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "struct ChannelStorage.UserStats";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "numCreations";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "numMints";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "grantRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "hasRole";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "defaultAdmin";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "setupActions";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }, {
        readonly name: "transportConfig";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "initialize";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "addr";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isAdmin";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isApprovedForAll";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "addr";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isManager";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "logicContract";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "contract ILogic";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mint";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintBatchWithERC20";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintBatchWithETH";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintWithERC20";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }];
    readonly name: "multicall";
    readonly outputs: readonly [{
        readonly name: "results";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "nextTokenId";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "proxiableUUID";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "callerConfirmation";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "renounceRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "revokeRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "values";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "safeBatchTransferFrom";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "value";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "safeTransferFrom";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "approved";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly name: "setApprovalForAll";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "fees";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setFees";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "logic";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "creatorLogic";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }, {
        readonly name: "minterLogic";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setLogic";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }];
    readonly name: "setManagers";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setTransportConfig";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "interfaceId";
        readonly internalType: "bytes4";
        readonly type: "bytes4";
    }];
    readonly name: "supportsInterface";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "tokens";
    readonly outputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "author";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "maxSupply";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "totalMinted";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "sponsor";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newAdmin";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "transferAdmin";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly name: "updateChannelTokenUri";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newImplementation";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "upgradeToAndCall";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "uri";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "userStats";
    readonly outputs: readonly [{
        readonly name: "numCreations";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "numMints";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "previousAdmin";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "newAdmin";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "AdminTransferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "approved";
        readonly internalType: "bool";
        readonly type: "bool";
        readonly indexed: false;
    }];
    readonly name: "ApprovalForAll";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "updater";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "updateType";
        readonly internalType: "enum Channel.ConfigUpdate";
        readonly type: "uint8";
        readonly indexed: true;
    }, {
        readonly name: "feeContract";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: false;
    }, {
        readonly name: "logicContract";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: false;
    }];
    readonly name: "ConfigUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "spender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "recipient";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }, {
        readonly name: "token";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "ERC20Transferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "spender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "recipient";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }];
    readonly name: "ETHTransferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "version";
        readonly internalType: "uint64";
        readonly type: "uint64";
        readonly indexed: false;
    }];
    readonly name: "Initialized";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "manager";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "ManagerRenounced";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
        readonly indexed: false;
    }];
    readonly name: "ManagersUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "previousAdminRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "newAdminRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }];
    readonly name: "RoleAdminChanged";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "RoleGranted";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "RoleRevoked";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }, {
        readonly name: "token";
        readonly internalType: "struct ChannelStorage.TokenConfig";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "uri";
            readonly internalType: "string";
            readonly type: "string";
        }, {
            readonly name: "author";
            readonly internalType: "address";
            readonly type: "address";
        }, {
            readonly name: "maxSupply";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "totalMinted";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "sponsor";
            readonly internalType: "address";
            readonly type: "address";
        }];
        readonly indexed: false;
    }];
    readonly name: "TokenCreated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "minter";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "tokenIds";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
        readonly indexed: false;
    }];
    readonly name: "TokenMinted";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }, {
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
        readonly indexed: false;
    }];
    readonly name: "TokenURIUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "values";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }];
    readonly name: "TransferBatch";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }, {
        readonly name: "value";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }];
    readonly name: "TransferSingle";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "value";
        readonly internalType: "string";
        readonly type: "string";
        readonly indexed: false;
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }];
    readonly name: "URI";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "implementation";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "Upgraded";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AccessControlBadConfirmation";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "neededRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "AccessControlUnauthorizedAccount";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "target";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "AddressEmptyCode";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "AddressInsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AmountExceedsMaxSupply";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AmountZero";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "balance";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "needed";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "ERC1155InsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "approver";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidApprover";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "idsLength";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "valuesLength";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "ERC1155InvalidArrayLength";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidOperator";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "receiver";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidReceiver";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidSender";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "owner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155MissingApprovalForAll";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "implementation";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1967InvalidImplementation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC1967NonPayable";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC20TransferFailed";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "FailedInnerCall";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InsufficientInteractionPower";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidAmountSent";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidInitialization";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidTotalAllocation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidUpgrade";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotInitializing";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotMintable";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ReentrancyGuardReentrantCall";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "token";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "SafeERC20FailedOperation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "SoldOut";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "SplitLengthMismatch";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "UUPSUnauthorizedCallContext";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "slot";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "UUPSUnsupportedProxiableUUID";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "Unauthorized";
}];
export declare const channelFactoryAbi: readonly [{
    readonly type: "constructor";
    readonly inputs: readonly [{
        readonly name: "_infiniteChannelImpl";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "_finiteChannelImpl";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "UPGRADE_INTERFACE_VERSION";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractName";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractURI";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractVersion";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "defaultAdmin";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "setupActions";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }, {
        readonly name: "transportConfig";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "createFiniteChannel";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "defaultAdmin";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "setupActions";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }, {
        readonly name: "transportConfig";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "createInfiniteChannel";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "finiteChannelImpl";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "infiniteChannelImpl";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "_initOwner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "initialize";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "owner";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "proxiableUUID";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "renounceOwnership";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newOwner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "transferOwnership";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newImplementation";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "upgradeToAndCall";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [];
    readonly name: "FactoryInitialized";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "version";
        readonly internalType: "uint64";
        readonly type: "uint64";
        readonly indexed: false;
    }];
    readonly name: "Initialized";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "previousOwner";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "newOwner";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "OwnershipTransferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "contractAddress";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
        readonly indexed: false;
    }, {
        readonly name: "defaultAdmin";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: false;
    }, {
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
        readonly indexed: false;
    }, {
        readonly name: "transportConfig";
        readonly internalType: "bytes";
        readonly type: "bytes";
        readonly indexed: false;
    }];
    readonly name: "SetupNewContract";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "implementation";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "Upgraded";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "target";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "AddressEmptyCode";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "AddressInsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AddressZero";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "implementation";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1967InvalidImplementation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC1967NonPayable";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC20TransferFailed";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "FailedInnerCall";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidInitialization";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidUpgrade";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotInitializing";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "owner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "OwnableInvalidOwner";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "OwnableUnauthorizedAccount";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "token";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "SafeERC20FailedOperation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "UUPSUnauthorizedCallContext";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "slot";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "UUPSUnsupportedProxiableUUID";
}];
export declare const customFeesAbi: readonly [{
    readonly type: "constructor";
    readonly inputs: readonly [{
        readonly name: "_uplinkRewardsAddress";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "channelFees";
    readonly outputs: readonly [{
        readonly name: "channelTreasury";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "uplinkBps";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "channelBps";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "creatorBps";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "mintReferralBps";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "sponsorBps";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "ethMintPrice";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "erc20MintPrice";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "erc20Contract";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractName";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractURI";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractVersion";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "getErc20MintPrice";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "getEthMintPrice";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "getFeeBps";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }, {
        readonly name: "";
        readonly internalType: "uint16";
        readonly type: "uint16";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "creators";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "sponsors";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "requestErc20Mint";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "struct Rewards.Split";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "recipients";
            readonly internalType: "address[]";
            readonly type: "address[]";
        }, {
            readonly name: "allocations";
            readonly internalType: "uint256[]";
            readonly type: "uint256[]";
        }, {
            readonly name: "totalAllocation";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "token";
            readonly internalType: "address";
            readonly type: "address";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "creators";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "sponsors";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "requestEthMint";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "struct Rewards.Split";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "recipients";
            readonly internalType: "address[]";
            readonly type: "address[]";
        }, {
            readonly name: "allocations";
            readonly internalType: "uint256[]";
            readonly type: "uint256[]";
        }, {
            readonly name: "totalAllocation";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "token";
            readonly internalType: "address";
            readonly type: "address";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setChannelFees";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "channel";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "feeconfig";
        readonly internalType: "struct CustomFees.FeeConfig";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "channelTreasury";
            readonly internalType: "address";
            readonly type: "address";
        }, {
            readonly name: "uplinkBps";
            readonly internalType: "uint16";
            readonly type: "uint16";
        }, {
            readonly name: "channelBps";
            readonly internalType: "uint16";
            readonly type: "uint16";
        }, {
            readonly name: "creatorBps";
            readonly internalType: "uint16";
            readonly type: "uint16";
        }, {
            readonly name: "mintReferralBps";
            readonly internalType: "uint16";
            readonly type: "uint16";
        }, {
            readonly name: "sponsorBps";
            readonly internalType: "uint16";
            readonly type: "uint16";
        }, {
            readonly name: "ethMintPrice";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "erc20MintPrice";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "erc20Contract";
            readonly internalType: "address";
            readonly type: "address";
        }];
        readonly indexed: false;
    }];
    readonly name: "FeeConfigSet";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AddressZero";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC20MintingDisabled";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidBps";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidETHMintPrice";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidSplit";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "TotalValueMismatch";
}];
export declare const dynamicLogicAbi: readonly [{
    readonly type: "constructor";
    readonly inputs: readonly [{
        readonly name: "_initOwner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "signature";
        readonly internalType: "bytes4";
        readonly type: "bytes4";
    }, {
        readonly name: "calldataAddressPosition";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "approveLogic";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "user";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "calculateCreatorInteractionPower";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "user";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "calculateMinterInteractionPower";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractName";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractURI";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractVersion";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "owner";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "renounceOwnership";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setCreatorLogic";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setMinterLogic";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newOwner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "transferOwnership";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "channel";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "logic";
        readonly internalType: "struct DynamicLogic.InteractionLogic";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "targets";
            readonly internalType: "address[]";
            readonly type: "address[]";
        }, {
            readonly name: "signatures";
            readonly internalType: "bytes4[]";
            readonly type: "bytes4[]";
        }, {
            readonly name: "datas";
            readonly internalType: "bytes[]";
            readonly type: "bytes[]";
        }, {
            readonly name: "operators";
            readonly internalType: "enum DynamicLogic.Operator[]";
            readonly type: "uint8[]";
        }, {
            readonly name: "literalOperands";
            readonly internalType: "bytes[]";
            readonly type: "bytes[]";
        }, {
            readonly name: "interactionPowerTypes";
            readonly internalType: "enum DynamicLogic.InteractionPowerType[]";
            readonly type: "uint8[]";
        }, {
            readonly name: "interactionPowers";
            readonly internalType: "uint256[]";
            readonly type: "uint256[]";
        }];
        readonly indexed: false;
    }];
    readonly name: "CreatorLogicSet";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "channel";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "logic";
        readonly internalType: "struct DynamicLogic.InteractionLogic";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "targets";
            readonly internalType: "address[]";
            readonly type: "address[]";
        }, {
            readonly name: "signatures";
            readonly internalType: "bytes4[]";
            readonly type: "bytes4[]";
        }, {
            readonly name: "datas";
            readonly internalType: "bytes[]";
            readonly type: "bytes[]";
        }, {
            readonly name: "operators";
            readonly internalType: "enum DynamicLogic.Operator[]";
            readonly type: "uint8[]";
        }, {
            readonly name: "literalOperands";
            readonly internalType: "bytes[]";
            readonly type: "bytes[]";
        }, {
            readonly name: "interactionPowerTypes";
            readonly internalType: "enum DynamicLogic.InteractionPowerType[]";
            readonly type: "uint8[]";
        }, {
            readonly name: "interactionPowers";
            readonly internalType: "uint256[]";
            readonly type: "uint256[]";
        }];
        readonly indexed: false;
    }];
    readonly name: "MinterLogicSet";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "previousOwner";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "newOwner";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "OwnershipTransferred";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "CallFailed";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidSignature";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "owner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "OwnableInvalidOwner";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "OwnableUnauthorizedAccount";
}];
export declare const finiteChannelAbi: readonly [{
    readonly type: "constructor";
    readonly inputs: readonly [{
        readonly name: "_upgradePath";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "_weth";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "DEFAULT_ADMIN_ROLE";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "MANAGER_ROLE";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "UPGRADE_INTERFACE_VERSION";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "balanceOf";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "accounts";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }];
    readonly name: "balanceOfBatch";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractName";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractURI";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractVersion";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "author";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "maxSupply";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "createToken";
    readonly outputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "erc20Balances";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "erc20MintPrice";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "ethMintPrice";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "feeContract";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "contract IFees";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "finiteChannelParams";
    readonly outputs: readonly [{
        readonly name: "createStart";
        readonly internalType: "uint80";
        readonly type: "uint80";
    }, {
        readonly name: "mintStart";
        readonly internalType: "uint80";
        readonly type: "uint80";
    }, {
        readonly name: "mintEnd";
        readonly internalType: "uint80";
        readonly type: "uint80";
    }, {
        readonly name: "rewards";
        readonly internalType: "struct FiniteChannel.FiniteRewards";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "ranks";
            readonly internalType: "uint40[]";
            readonly type: "uint40[]";
        }, {
            readonly name: "allocations";
            readonly internalType: "uint256[]";
            readonly type: "uint256[]";
        }, {
            readonly name: "totalAllocation";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "token";
            readonly internalType: "address";
            readonly type: "address";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "getRoleAdmin";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "index";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "getRoleMember";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "getRoleMemberCount";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "getToken";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "struct ChannelStorage.TokenConfig";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "uri";
            readonly internalType: "string";
            readonly type: "string";
        }, {
            readonly name: "author";
            readonly internalType: "address";
            readonly type: "address";
        }, {
            readonly name: "maxSupply";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "totalMinted";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "sponsor";
            readonly internalType: "address";
            readonly type: "address";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "user";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "getUserStats";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "struct ChannelStorage.UserStats";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "numCreations";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "numMints";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "grantRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "hasRole";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "head";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "defaultAdmin";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "setupActions";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }, {
        readonly name: "transportConfig";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "initialize";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "addr";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isAdmin";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isApprovedForAll";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "addr";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isManager";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "length";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "logicContract";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "contract ILogic";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mint";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintBatchWithERC20";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintBatchWithETH";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintWithERC20";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }];
    readonly name: "multicall";
    readonly outputs: readonly [{
        readonly name: "results";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "nextTokenId";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "nodes";
    readonly outputs: readonly [{
        readonly name: "next";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "prev";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "proxiableUUID";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "callerConfirmation";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "renounceRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "revokeRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "values";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "safeBatchTransferFrom";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "value";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "safeTransferFrom";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "approved";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly name: "setApprovalForAll";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "fees";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setFees";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "logic";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "creatorLogic";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }, {
        readonly name: "minterLogic";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setLogic";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }];
    readonly name: "setManagers";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setTransportConfig";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "settle";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "interfaceId";
        readonly internalType: "bytes4";
        readonly type: "bytes4";
    }];
    readonly name: "supportsInterface";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "tail";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "tokens";
    readonly outputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "author";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "maxSupply";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "totalMinted";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "sponsor";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newAdmin";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "transferAdmin";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly name: "updateChannelTokenUri";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newImplementation";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "upgradeToAndCall";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "uri";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "userStats";
    readonly outputs: readonly [{
        readonly name: "numCreations";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "numMints";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "token";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "withdrawRewards";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "previousAdmin";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "newAdmin";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "AdminTransferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "approved";
        readonly internalType: "bool";
        readonly type: "bool";
        readonly indexed: false;
    }];
    readonly name: "ApprovalForAll";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "updater";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "updateType";
        readonly internalType: "enum Channel.ConfigUpdate";
        readonly type: "uint8";
        readonly indexed: true;
    }, {
        readonly name: "feeContract";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: false;
    }, {
        readonly name: "logicContract";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: false;
    }];
    readonly name: "ConfigUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "spender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "recipient";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }, {
        readonly name: "token";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "ERC20Transferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "spender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "recipient";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }];
    readonly name: "ETHTransferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "version";
        readonly internalType: "uint64";
        readonly type: "uint64";
        readonly indexed: false;
    }];
    readonly name: "Initialized";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "manager";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "ManagerRenounced";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
        readonly indexed: false;
    }];
    readonly name: "ManagersUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "previousAdminRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "newAdminRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }];
    readonly name: "RoleAdminChanged";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "RoleGranted";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "RoleRevoked";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "caller";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "Settled";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }, {
        readonly name: "token";
        readonly internalType: "struct ChannelStorage.TokenConfig";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "uri";
            readonly internalType: "string";
            readonly type: "string";
        }, {
            readonly name: "author";
            readonly internalType: "address";
            readonly type: "address";
        }, {
            readonly name: "maxSupply";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "totalMinted";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "sponsor";
            readonly internalType: "address";
            readonly type: "address";
        }];
        readonly indexed: false;
    }];
    readonly name: "TokenCreated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "minter";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "tokenIds";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
        readonly indexed: false;
    }];
    readonly name: "TokenMinted";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }, {
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
        readonly indexed: false;
    }];
    readonly name: "TokenURIUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "values";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }];
    readonly name: "TransferBatch";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }, {
        readonly name: "value";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }];
    readonly name: "TransferSingle";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "value";
        readonly internalType: "string";
        readonly type: "string";
        readonly indexed: false;
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }];
    readonly name: "URI";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "implementation";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "Upgraded";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AccessControlBadConfirmation";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "neededRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "AccessControlUnauthorizedAccount";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "target";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "AddressEmptyCode";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "AddressInsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AlreadySettled";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AmountExceedsMaxSupply";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AmountZero";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "balance";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "needed";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "ERC1155InsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "approver";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidApprover";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "idsLength";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "valuesLength";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "ERC1155InvalidArrayLength";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidOperator";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "receiver";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidReceiver";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidSender";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "owner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155MissingApprovalForAll";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "implementation";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1967InvalidImplementation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC1967NonPayable";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC20TransferFailed";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "FailedInnerCall";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InsufficientInteractionPower";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidAmountSent";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidInitialization";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidTiming";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidTotalAllocation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidUpgrade";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotAcceptingCreations";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotAcceptingMints";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotInitializing";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotMintable";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ReentrancyGuardReentrantCall";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "token";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "SafeERC20FailedOperation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "SoldOut";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "SplitLengthMismatch";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "StillActive";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "UUPSUnauthorizedCallContext";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "slot";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "UUPSUnsupportedProxiableUUID";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "Unauthorized";
}];
export declare const infiniteChannelAbi: readonly [{
    readonly type: "constructor";
    readonly inputs: readonly [{
        readonly name: "_updgradePath";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "_weth";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "DEFAULT_ADMIN_ROLE";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "MANAGER_ROLE";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "UPGRADE_INTERFACE_VERSION";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "balanceOf";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "accounts";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }];
    readonly name: "balanceOfBatch";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractName";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractURI";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractVersion";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "author";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "maxSupply";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "createToken";
    readonly outputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "erc20Balances";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "erc20MintPrice";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "ethMintPrice";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "feeContract";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "contract IFees";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "getRoleAdmin";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "index";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "getRoleMember";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "getRoleMemberCount";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "getToken";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "struct ChannelStorage.TokenConfig";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "uri";
            readonly internalType: "string";
            readonly type: "string";
        }, {
            readonly name: "author";
            readonly internalType: "address";
            readonly type: "address";
        }, {
            readonly name: "maxSupply";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "totalMinted";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "sponsor";
            readonly internalType: "address";
            readonly type: "address";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "user";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "getUserStats";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "struct ChannelStorage.UserStats";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "numCreations";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "numMints";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }];
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "grantRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "hasRole";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "defaultAdmin";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "setupActions";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }, {
        readonly name: "transportConfig";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "initialize";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "addr";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isAdmin";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isApprovedForAll";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "addr";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isManager";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "logicContract";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "contract ILogic";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mint";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintBatchWithERC20";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintBatchWithETH";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "mintWithERC20";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }];
    readonly name: "multicall";
    readonly outputs: readonly [{
        readonly name: "results";
        readonly internalType: "bytes[]";
        readonly type: "bytes[]";
    }];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "nextTokenId";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "proxiableUUID";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "callerConfirmation";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "renounceRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "revokeRole";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "values";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "safeBatchTransferFrom";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "value";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "safeTransferFrom";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "saleDuration";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint40";
        readonly type: "uint40";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "saleEnd";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "uint40";
        readonly type: "uint40";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "approved";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly name: "setApprovalForAll";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "fees";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setFees";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "logic";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "creatorLogic";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }, {
        readonly name: "minterLogic";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setLogic";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }];
    readonly name: "setManagers";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "setTransportConfig";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "interfaceId";
        readonly internalType: "bytes4";
        readonly type: "bytes4";
    }];
    readonly name: "supportsInterface";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "tokens";
    readonly outputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }, {
        readonly name: "author";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "maxSupply";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "totalMinted";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "sponsor";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newAdmin";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "transferAdmin";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly name: "updateChannelTokenUri";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newImplementation";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
    }];
    readonly name: "upgradeToAndCall";
    readonly outputs: readonly [];
    readonly stateMutability: "payable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "uri";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "userStats";
    readonly outputs: readonly [{
        readonly name: "numCreations";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "numMints";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "previousAdmin";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "newAdmin";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "AdminTransferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "approved";
        readonly internalType: "bool";
        readonly type: "bool";
        readonly indexed: false;
    }];
    readonly name: "ApprovalForAll";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "updater";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "updateType";
        readonly internalType: "enum Channel.ConfigUpdate";
        readonly type: "uint8";
        readonly indexed: true;
    }, {
        readonly name: "feeContract";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: false;
    }, {
        readonly name: "logicContract";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: false;
    }];
    readonly name: "ConfigUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "spender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "recipient";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }, {
        readonly name: "token";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "ERC20Transferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "spender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "recipient";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "amount";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }];
    readonly name: "ETHTransferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "version";
        readonly internalType: "uint64";
        readonly type: "uint64";
        readonly indexed: false;
    }];
    readonly name: "Initialized";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "manager";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "ManagerRenounced";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "managers";
        readonly internalType: "address[]";
        readonly type: "address[]";
        readonly indexed: false;
    }];
    readonly name: "ManagersUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "previousAdminRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "newAdminRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }];
    readonly name: "RoleAdminChanged";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "RoleGranted";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "role";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
        readonly indexed: true;
    }, {
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "RoleRevoked";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }, {
        readonly name: "token";
        readonly internalType: "struct ChannelStorage.TokenConfig";
        readonly type: "tuple";
        readonly components: readonly [{
            readonly name: "uri";
            readonly internalType: "string";
            readonly type: "string";
        }, {
            readonly name: "author";
            readonly internalType: "address";
            readonly type: "address";
        }, {
            readonly name: "maxSupply";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "totalMinted";
            readonly internalType: "uint256";
            readonly type: "uint256";
        }, {
            readonly name: "sponsor";
            readonly internalType: "address";
            readonly type: "address";
        }];
        readonly indexed: false;
    }];
    readonly name: "TokenCreated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "minter";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "mintReferral";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "tokenIds";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "amounts";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "data";
        readonly internalType: "bytes";
        readonly type: "bytes";
        readonly indexed: false;
    }];
    readonly name: "TokenMinted";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "caller";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }, {
        readonly name: "saleEnd";
        readonly internalType: "uint40";
        readonly type: "uint40";
        readonly indexed: false;
    }];
    readonly name: "TokenSaleSet";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }, {
        readonly name: "uri";
        readonly internalType: "string";
        readonly type: "string";
        readonly indexed: false;
    }];
    readonly name: "TokenURIUpdated";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "ids";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }, {
        readonly name: "values";
        readonly internalType: "uint256[]";
        readonly type: "uint256[]";
        readonly indexed: false;
    }];
    readonly name: "TransferBatch";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "from";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "to";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }, {
        readonly name: "value";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: false;
    }];
    readonly name: "TransferSingle";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "value";
        readonly internalType: "string";
        readonly type: "string";
        readonly indexed: false;
    }, {
        readonly name: "id";
        readonly internalType: "uint256";
        readonly type: "uint256";
        readonly indexed: true;
    }];
    readonly name: "URI";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "implementation";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "Upgraded";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AccessControlBadConfirmation";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "neededRole";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "AccessControlUnauthorizedAccount";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "target";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "AddressEmptyCode";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "AddressInsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AmountExceedsMaxSupply";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "AmountZero";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "balance";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "needed";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "tokenId";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "ERC1155InsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "approver";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidApprover";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "idsLength";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }, {
        readonly name: "valuesLength";
        readonly internalType: "uint256";
        readonly type: "uint256";
    }];
    readonly name: "ERC1155InvalidArrayLength";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidOperator";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "receiver";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidReceiver";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "sender";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155InvalidSender";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "operator";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "owner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1155MissingApprovalForAll";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "implementation";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "ERC1967InvalidImplementation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC1967NonPayable";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ERC20TransferFailed";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "FailedInnerCall";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InsufficientBalance";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InsufficientInteractionPower";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidAmountSent";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidInitialization";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidTiming";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidTotalAllocation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidUpgrade";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotInitializing";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotMintable";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "ReentrancyGuardReentrantCall";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "token";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "SafeERC20FailedOperation";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "SaleOver";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "SoldOut";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "SplitLengthMismatch";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "UUPSUnauthorizedCallContext";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "slot";
        readonly internalType: "bytes32";
        readonly type: "bytes32";
    }];
    readonly name: "UUPSUnsupportedProxiableUUID";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "Unauthorized";
}];
export declare const upgradePathAbi: readonly [{
    readonly type: "constructor";
    readonly inputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractName";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractURI";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "contractVersion";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "string";
        readonly type: "string";
    }];
    readonly stateMutability: "pure";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "_initOwner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "initialize";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isAllowedUpgrade";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "baseImpl";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "upgradeImpl";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "isRegisteredUpgradePath";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "bool";
        readonly type: "bool";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "owner";
    readonly outputs: readonly [{
        readonly name: "";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly stateMutability: "view";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "baseImpls";
        readonly internalType: "address[]";
        readonly type: "address[]";
    }, {
        readonly name: "upgradeImpl";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "registerUpgradePath";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "baseImpl";
        readonly internalType: "address";
        readonly type: "address";
    }, {
        readonly name: "upgradeImpl";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "removeUpgradePath";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [];
    readonly name: "renounceOwnership";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "function";
    readonly inputs: readonly [{
        readonly name: "newOwner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "transferOwnership";
    readonly outputs: readonly [];
    readonly stateMutability: "nonpayable";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "version";
        readonly internalType: "uint64";
        readonly type: "uint64";
        readonly indexed: false;
    }];
    readonly name: "Initialized";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "previousOwner";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "newOwner";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "OwnershipTransferred";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [];
    readonly name: "UpgradePathContractInitialized";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "baseImpl";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "upgradeImpl";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "UpgradeRegistered";
}, {
    readonly type: "event";
    readonly anonymous: false;
    readonly inputs: readonly [{
        readonly name: "baseImpl";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }, {
        readonly name: "upgradeImpl";
        readonly internalType: "address";
        readonly type: "address";
        readonly indexed: true;
    }];
    readonly name: "UpgradeRemoved";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "InvalidInitialization";
}, {
    readonly type: "error";
    readonly inputs: readonly [];
    readonly name: "NotInitializing";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "owner";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "OwnableInvalidOwner";
}, {
    readonly type: "error";
    readonly inputs: readonly [{
        readonly name: "account";
        readonly internalType: "address";
        readonly type: "address";
    }];
    readonly name: "OwnableUnauthorizedAccount";
}];
//# sourceMappingURL=index.d.ts.map