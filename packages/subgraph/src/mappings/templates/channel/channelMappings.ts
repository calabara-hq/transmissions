import {
    getOrCreateChannel,
    updateFeeConfig,
    updateLogicConfig,
    getOrCreateToken,
    getOrCreateUser,
    getOrCreateMint,
    handleUpdateTokenHolders
} from "../../../utils/helpers";
import {
    AdminTransferred,
    ChannelMetadataUpdated,
    ConfigUpdated,
    ManagerRenounced,
    ManagersUpdated,
    TokenCreated,
    TokenMinted,
    TransferBatch,
    TransferSingle
} from "../../../generated/templates/Channel/Channel";
import { TokenMetadata as TokenMetadataTemplate } from "../../../generated/templates";

export function handleUpdateChannelMetadata(event: ChannelMetadataUpdated): void {
    let channel = getOrCreateChannel(event.address.toHexString());
    let token = getOrCreateToken(channel.id + '-0');

    channel.name = event.params.channelName;
    channel.uri = event.params.uri;
    token.uri = event.params.uri;

    channel.save();
    token.save();
}

export function handleUpdateManagers(event: ManagersUpdated): void {
    let channel = getOrCreateChannel(event.address.toHexString());

    let tempManagers: string[] = [];

    for (let i = 0; i < event.params.managers.length; i++) {
        let manager = getOrCreateUser(event.params.managers[i].toHex());
        tempManagers.push(manager.id);
        manager.save();
    }

    channel.managers = tempManagers;

    channel.save();
}

/// wasm doesn't support closures
let toRemoveManager: string = "";

export function handleRenounceManager(event: ManagerRenounced): void {
    let channel = getOrCreateChannel(event.address.toHexString());

    let previousManagers = channel.managers;
    toRemoveManager = event.params.manager.toHexString();

    channel.managers = previousManagers.filter(m => m != toRemoveManager);

    channel.save();
}

export function handleTransferAdmin(event: AdminTransferred): void {
    let channel = getOrCreateChannel(event.address.toHexString());
    let newAdmin = getOrCreateUser(event.params.newAdmin.toHexString());

    channel.admin = newAdmin.id;

    newAdmin.save();
    channel.save();
}


export function handleUpdateConfig(event: ConfigUpdated): void {
    let channel = getOrCreateChannel(event.address.toHexString());


    if (event.params.updateType == 0) {
        let feeConfigId = updateFeeConfig(channel.id, event);
        channel.fees = feeConfigId;

    } else {
        let updatedLogic = updateLogicConfig(channel.id, event);

        channel.creatorLogic = updatedLogic.creatorLogic;
        channel.minterLogic = updatedLogic.minterLogic;

    }

    channel.save();
}

export function handleTokenCreated(event: TokenCreated): void {
    let channel = getOrCreateChannel(event.address.toHexString());
    let token = getOrCreateToken(event.address.toHexString() + '-' + event.params.tokenId.toString());

    let tokenConfig = event.params.token;

    let author = getOrCreateUser(tokenConfig.author.toHexString());
    let sponsor = getOrCreateUser(tokenConfig.sponsor.toHexString());

    token.tokenId = event.params.tokenId;
    token.author = author.id;
    token.sponsor = sponsor.id;
    token.uri = tokenConfig.uri;
    token.maxSupply = tokenConfig.maxSupply;
    token.totalMinted = tokenConfig.totalMinted;

    // /// set metadata if it's an ipfs hash, but don't break the runtime if it's not
    const ipfsSplit = tokenConfig.uri.split('ipfs://')

    if (ipfsSplit.length > 1) {
        let ipfsHash = ipfsSplit[1];
        token.metadata = ipfsHash;
        TokenMetadataTemplate.create(ipfsHash);
    }

    token.channel = channel.id;

    token.blockNumber = event.block.number;
    token.blockTimestamp = event.block.timestamp;

    token.save();
    author.save();
    sponsor.save();
    channel.save();
}


export function handleTokenBatchMinted(event: TokenMinted): void {
    let channel = getOrCreateChannel(event.address.toHexString());

    let amounts = event.params.amounts;
    let tokenIds = event.params.tokenIds;
    let data = event.params.data;

    let minter = getOrCreateUser(event.params.minter.toHexString());
    let referral = getOrCreateUser(event.params.mintReferral.toHexString());

    for (let i = 0; i < tokenIds.length; i++) {
        let token = getOrCreateToken(event.address.toHexString() + '-' + tokenIds[i].toString());
        let mint = getOrCreateMint(event.transaction.hash.toHexString() + '-' + i.toString());

        mint.token = token.id;
        mint.amount = amounts[i];
        mint.data = data;
        mint.minter = minter.id;
        mint.referral = referral.id;

        mint.channel = channel.id;

        mint.blockNumber = event.block.number;
        mint.blockTimestamp = event.block.timestamp;

        token.totalMinted = token.totalMinted.plus(amounts[i]);

        mint.save();
        token.save();
    }

    minter.save();
    referral.save();
}


export function handleTransferSingleToken(event: TransferSingle): void {
    handleUpdateTokenHolders(
        event.address.toHexString(),
        event.params.from.toHexString(),
        event.params.to.toHexString(),
        event.params.id.toString(),
        event.params.value
    );
}

export function handleTransferBatchToken(event: TransferBatch): void {
    let ids = event.params.ids;
    let values = event.params.values;

    for (let i = 0; i < ids.length; i++) {
        handleUpdateTokenHolders(
            event.address.toHexString(),
            event.params.from.toHexString(),
            event.params.to.toHexString(),
            ids[i].toString(),
            values[i]
        );
    }
}


