import { CreatorLogicSet, SignatureApproved } from "../generated/DynamicLogicV1/DynamicLogic";
import { getOrCreateApprovedSignature, getOrCreateDynamicLogic } from "../utils/helpers";
import { Bytes, BigInt } from '@graphprotocol/graph-ts';

export function handleUpdateDynamicCreatorLogic(event: CreatorLogicSet): void {
    let channelId = event.params.channel.toHexString();
    let dynamicLogic = getOrCreateDynamicLogic(channelId + '-creator');

    let logic = event.params.logic;

    dynamicLogic.targets = changetype<Bytes[]>(logic.targets);
    dynamicLogic.signatures = logic.signatures;
    dynamicLogic.datas = logic.datas;
    dynamicLogic.operators = logic.operators.map<BigInt>(x => BigInt.fromI32(x));
    dynamicLogic.literalOperands = logic.literalOperands;
    dynamicLogic.interactionPowerTypes = logic.interactionPowerTypes.map<BigInt>(x => BigInt.fromI32(x));
    dynamicLogic.interactionPowers = logic.interactionPowers;

    dynamicLogic.save();
}

export function handleUpdateDynamicMinterLogic(event: CreatorLogicSet): void {
    let channelId = event.params.channel.toHexString();
    let dynamicLogic = getOrCreateDynamicLogic(channelId + '-minter');

    let logic = event.params.logic;

    dynamicLogic.targets = changetype<Bytes[]>(logic.targets);
    dynamicLogic.signatures = logic.signatures;
    dynamicLogic.datas = logic.datas;
    dynamicLogic.operators = logic.operators.map<BigInt>(x => BigInt.fromI32(x));
    dynamicLogic.literalOperands = logic.literalOperands;
    dynamicLogic.interactionPowerTypes = logic.interactionPowerTypes.map<BigInt>(x => BigInt.fromI32(x));
    dynamicLogic.interactionPowers = logic.interactionPowers;

    dynamicLogic.save();
}

export function handleSignatureApproved(event: SignatureApproved): void {

    let approvedSignature = getOrCreateApprovedSignature(event.transaction.hash.toHexString() + '-' + event.logIndex.toString());
    approvedSignature.signature = event.params.signature;
    approvedSignature.calldataAddressOffset = event.params.calldataAddressPosition;

    approvedSignature.save();
}