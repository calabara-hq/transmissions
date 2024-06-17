
import { ERC20Transferred, ETHTransferred } from "../../../generated/templates/Channel/Channel";
import { getOrCreateChannel, getOrCreateRewardTransferEvent, getOrCreateUser } from "../../../utils/helpers";
import { NATIVE_TOKEN } from "../../../utils/constants";
import { Bytes } from "@graphprotocol/graph-ts";

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
