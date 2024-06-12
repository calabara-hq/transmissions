import {
    getOrCreateChannel,
    updateFeeConfig,
    updateLogicConfig,
    getOrCreateToken,
    getOrCreateUser,
    getOrCreateMint,
    getOrCreateRewardTransferEvent,
    handleUpdateTokenHolders
} from "../../../utils/helpers";
import {
    AdminTransferred,
    ConfigUpdated,
    ERC20Transferred,
    ETHTransferred,
    ManagerRenounced,
    ManagersUpdated,
    TokenCreated,
    TokenMinted,
    TokenURIUpdated,
    TransferBatch,
    TransferSingle
} from "../../../generated/templates/Channel/Channel";
import { Bytes } from "@graphprotocol/graph-ts";
import { NATIVE_TOKEN } from "../../../utils/constants";


export function handleTokenURIUpdated(event: TokenURIUpdated): void {

    let channel = getOrCreateChannel(event.address.toHexString());
    let token = getOrCreateToken(channel.id + '-' + event.params.tokenId.toString());

    channel.uri = event.params.uri;
    token.uri = event.params.uri;
    token.save();
    channel.save();
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

    token.createdAt = event.block.timestamp;

    token.channel = channel.id;

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
        mint.mintedAt = event.block.timestamp;
        mint.referral = referral.id;

        mint.channel = channel.id;

        token.totalMinted = token.totalMinted.plus(amounts[i]);

        mint.save();
        token.save();
    }

    minter.save();
    referral.save();
}


export function handleERC20Transferred(event: ERC20Transferred): void {
    let channel = getOrCreateChannel(event.address.toHexString());

    let spender = getOrCreateUser(event.params.spender.toHexString());
    let recipient = getOrCreateUser(event.params.recipient.toHexString());
    let amount = event.params.amount;
    let token = event.params.token;

    let transferEvent = getOrCreateRewardTransferEvent(event.transaction.hash.toHexString() + '-' + event.logIndex.toString());

    transferEvent.from = spender.id;
    transferEvent.to = recipient.id;
    transferEvent.amount = amount;
    transferEvent.token = Bytes.fromHexString(token.toHexString());

    transferEvent.blockNumber = event.block.number;
    transferEvent.blockTimestamp = event.block.timestamp;

    transferEvent.channel = channel.id;

    spender.save();
    recipient.save();
    transferEvent.save();
}


export function handleETHTransferred(event: ETHTransferred): void {
    let channel = getOrCreateChannel(event.address.toHexString());

    let spender = getOrCreateUser(event.params.spender.toHexString());
    let recipient = getOrCreateUser(event.params.recipient.toHexString());
    let amount = event.params.amount;

    let transferEvent = getOrCreateRewardTransferEvent(event.transaction.hash.toHexString() + '-' + event.logIndex.toString());

    transferEvent.from = spender.id;
    transferEvent.to = recipient.id;
    transferEvent.amount = amount;
    transferEvent.token = Bytes.fromHexString(NATIVE_TOKEN);

    transferEvent.blockNumber = event.block.number;
    transferEvent.blockTimestamp = event.block.timestamp;

    transferEvent.channel = channel.id;

    spender.save();
    recipient.save();
    transferEvent.save();
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


