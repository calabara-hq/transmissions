import { SetupNewContract } from "../src/generated/ChannelFactoryV1/ChannelFactory";
import { AdminTransferred, ChannelMetadataUpdated, ConfigUpdated, ERC20Transferred, ETHTransferred, ManagerRenounced, ManagersUpdated, TokenCreated, TokenMinted, TransferBatch, TransferSingle } from "../src/generated/templates/Channel/Channel";
import { FeeConfigSet } from "../src/generated/CustomFeesV1/CustomFees";
import { BIGINT_ONE, BIGINT_ZERO, ZERO_ADDRESS } from '../src/utils/constants';
import { BigInt, Address, Bytes, ethereum, Int8, json, dataSource } from "@graphprotocol/graph-ts";
import { newMockEvent } from 'matchstick-as/assembly/index';
import { CreatorLogicSet, SignatureApproved } from "../src/generated/DynamicLogicV1/DynamicLogic";
import { FiniteTransportConfigSet, Settled } from "../src/generated/templates/FiniteChannel/FiniteChannel";
import { InfiniteTransportConfigSet } from "../src/generated/templates/InfiniteChannel/InfiniteChannel";
import { TokenMetadata } from "../src/generated/templates";
import { UpgradeRegistered, UpgradeRemoved } from "../src/generated/UpgradePathV1/UpgradePath";


export const finiteTransportBytes =
    "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000001000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001"

export const infiniteTransportBytes = "0x0000000000000000000000000000000000000000000000000000000000000001"


export class ChannelCreatedData {
    contractAddress: Address = Address.fromString(ZERO_ADDRESS);
    uri: string = '';
    name: string = '';
    admin: Address = Address.fromString(ZERO_ADDRESS);
    managers: Address[] = [];
    transportConfig: Bytes = Bytes.empty();

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createChannelCreatedData(input: ChannelCreatedData): SetupNewContract {
    let newEvent = changetype<SetupNewContract>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let contractAddressParam = new ethereum.EventParam("contractAddress", ethereum.Value.fromAddress(input.contractAddress));
    let uriParam = new ethereum.EventParam("uri", ethereum.Value.fromString(input.uri));
    let nameParam = new ethereum.EventParam("name", ethereum.Value.fromString(input.name));
    let adminParam = new ethereum.EventParam("defaultAdmin", ethereum.Value.fromAddress(input.admin));
    let managersParam = new ethereum.EventParam("managers", ethereum.Value.fromAddressArray(input.managers));
    let transportConfigParam = new ethereum.EventParam("transportConfig", ethereum.Value.fromBytes(input.transportConfig));

    newEvent.parameters.push(contractAddressParam);
    newEvent.parameters.push(uriParam);
    newEvent.parameters.push(nameParam);
    newEvent.parameters.push(adminParam);
    newEvent.parameters.push(managersParam);
    newEvent.parameters.push(transportConfigParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent;
}

export class FiniteTransportConfigSetData {
    caller: Address = Address.fromString(ZERO_ADDRESS);
    createStart: BigInt = BIGINT_ZERO;
    mintStart: BigInt = BIGINT_ZERO;
    mintEnd: BigInt = BIGINT_ZERO;
    ranks: BigInt[] = [];
    allocations: BigInt[] = [];
    totalAllocation: BigInt = BIGINT_ZERO;
    token: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createFiniteTransportConfigSetData(input: FiniteTransportConfigSetData): FiniteTransportConfigSet {
    let newEvent = changetype<FiniteTransportConfigSet>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let callerParam = new ethereum.EventParam("updater", ethereum.Value.fromAddress(input.caller));
    let createStartParam = new ethereum.EventParam("createStart", ethereum.Value.fromUnsignedBigInt(input.createStart));
    let mintStartParam = new ethereum.EventParam("mintStart", ethereum.Value.fromUnsignedBigInt(input.mintStart));
    let mintEndParam = new ethereum.EventParam("mintEnd", ethereum.Value.fromUnsignedBigInt(input.mintEnd));
    let ranksParam = new ethereum.EventParam("ranks", ethereum.Value.fromUnsignedBigIntArray(input.ranks));
    let allocationsParam = new ethereum.EventParam("allocations", ethereum.Value.fromUnsignedBigIntArray(input.allocations));
    let totalAllocationParam = new ethereum.EventParam("totalAllocation", ethereum.Value.fromUnsignedBigInt(input.totalAllocation));
    let tokenParam = new ethereum.EventParam("token", ethereum.Value.fromAddress(input.token));

    newEvent.parameters.push(callerParam);
    newEvent.parameters.push(createStartParam);
    newEvent.parameters.push(mintStartParam);
    newEvent.parameters.push(mintEndParam);
    newEvent.parameters.push(ranksParam);
    newEvent.parameters.push(allocationsParam);
    newEvent.parameters.push(totalAllocationParam);
    newEvent.parameters.push(tokenParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as FiniteTransportConfigSet;
}

export class InfiniteTransportConfigSetData {
    caller: Address = Address.fromString(ZERO_ADDRESS);
    saleDuration: BigInt = BIGINT_ZERO;

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createInfiniteTransportConfigSetData(input: InfiniteTransportConfigSetData): InfiniteTransportConfigSet {
    let newEvent = changetype<InfiniteTransportConfigSet>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let callerParam = new ethereum.EventParam("updater", ethereum.Value.fromAddress(input.caller));
    let saleDurationParam = new ethereum.EventParam("saleDuration", ethereum.Value.fromUnsignedBigInt(input.saleDuration));

    newEvent.parameters.push(callerParam);
    newEvent.parameters.push(saleDurationParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent;
}


export class ChannelMetadataUpdatedData {
    updater: Address = Address.fromString(ZERO_ADDRESS);
    channelName: string = '';
    uri: string = '';

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createChannelMetadataUpdatedData(input: ChannelMetadataUpdatedData): ChannelMetadataUpdated {
    let newEvent = changetype<ChannelMetadataUpdated>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let updaterParam = new ethereum.EventParam("updater", ethereum.Value.fromAddress(input.updater));
    let channelNameParam = new ethereum.EventParam("channelName", ethereum.Value.fromString(input.channelName));
    let uriParam = new ethereum.EventParam("uri", ethereum.Value.fromString(input.uri));

    newEvent.parameters.push(updaterParam);
    newEvent.parameters.push(channelNameParam);
    newEvent.parameters.push(uriParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as ChannelMetadataUpdated;


}

export class ManagersUpdatedData {
    managers: Address[] = [];

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createManagersUpdatedData(input: ManagersUpdatedData): ManagersUpdated {
    let newEvent = changetype<ManagersUpdated>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let managersParam = new ethereum.EventParam("managers", ethereum.Value.fromAddressArray(input.managers));

    newEvent.parameters.push(managersParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent;
}

export class ManagerRenouncedData {
    manager: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createManagerRenouncedData(input: ManagerRenouncedData): ManagerRenounced {
    let newEvent = changetype<ManagerRenounced>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let managerParam = new ethereum.EventParam("manager", ethereum.Value.fromAddress(input.manager));

    newEvent.parameters.push(managerParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as ManagerRenounced;

}

export class TransferAdminData {
    previousAdmin: Address = Address.fromString(ZERO_ADDRESS);
    newAdmin: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}


export function createTransferAdminData(input: TransferAdminData): AdminTransferred {
    let newEvent = changetype<AdminTransferred>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let previousAdminParam = new ethereum.EventParam("previousAdmin", ethereum.Value.fromAddress(input.previousAdmin));
    let newAdminParam = new ethereum.EventParam("newAdmin", ethereum.Value.fromAddress(input.newAdmin));

    newEvent.parameters.push(previousAdminParam);
    newEvent.parameters.push(newAdminParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as AdminTransferred;

}

export class ConfigUpdatedData {
    updater: Address = Address.fromString(ZERO_ADDRESS);
    updateType: BigInt = BigInt.fromI32(0);
    feeContract: Address = Address.fromString(ZERO_ADDRESS);
    logicContract: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createConfigUpdatedData(input: ConfigUpdatedData): ConfigUpdated {

    let newEvent = changetype<ConfigUpdated>(newMockEvent());

    newEvent.parameters = new Array<ethereum.EventParam>();

    let updaterParam = new ethereum.EventParam("updater", ethereum.Value.fromAddress(input.updater));
    let updateTypeParam = new ethereum.EventParam("updateType", ethereum.Value.fromUnsignedBigInt(input.updateType));
    let feeContractParam = new ethereum.EventParam("feeContract", ethereum.Value.fromAddress(input.feeContract));
    let logicContractParam = new ethereum.EventParam("logicContract", ethereum.Value.fromAddress(input.logicContract));

    newEvent.parameters.push(updaterParam);
    newEvent.parameters.push(updateTypeParam);
    newEvent.parameters.push(feeContractParam);
    newEvent.parameters.push(logicContractParam);


    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as ConfigUpdated;

}


export class CustomFeesUpdatedData {
    channel: Address = Address.fromString(ZERO_ADDRESS);
    channelTreasury: Address = Address.fromString(ZERO_ADDRESS);
    uplinkBps: BigInt = BIGINT_ZERO;
    channelBps: BigInt = BIGINT_ZERO;
    creatorBps: BigInt = BIGINT_ZERO;
    mintReferralBps: BigInt = BIGINT_ZERO;
    sponsorBps: BigInt = BIGINT_ZERO;
    ethMintPrice: BigInt = BIGINT_ZERO;
    erc20MintPrice: BigInt = BIGINT_ZERO;
    erc20Contract: Address = Address.fromString(ZERO_ADDRESS);


    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createCustomFeesUpdatedData(input: CustomFeesUpdatedData): FeeConfigSet {
    let newEvent = changetype<FeeConfigSet>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    // Create the tuple
    let feeconfigTuple = changetype<ethereum.Tuple>([
        ethereum.Value.fromAddress(input.channelTreasury),
        ethereum.Value.fromUnsignedBigInt(input.uplinkBps),
        ethereum.Value.fromUnsignedBigInt(input.channelBps),
        ethereum.Value.fromUnsignedBigInt(input.creatorBps),
        ethereum.Value.fromUnsignedBigInt(input.mintReferralBps),
        ethereum.Value.fromUnsignedBigInt(input.sponsorBps),
        ethereum.Value.fromUnsignedBigInt(input.ethMintPrice),
        ethereum.Value.fromUnsignedBigInt(input.erc20MintPrice),
        ethereum.Value.fromAddress(input.erc20Contract)
    ]);

    let feeconfigParam = new ethereum.EventParam(
        "feeconfig",
        ethereum.Value.fromTuple(feeconfigTuple)
    );

    let channelAddressParam = new ethereum.EventParam("channel", ethereum.Value.fromAddress(input.channel));

    newEvent.parameters.push(channelAddressParam);
    newEvent.parameters.push(feeconfigParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent;
}

export class DynamicLogicUpdatedData {
    channel: Address = Address.fromString(ZERO_ADDRESS);
    targets: Address[] = [];
    signatures: Bytes[] = [];
    datas: Bytes[] = [];
    operators: BigInt[] = [];
    literalOperands: Bytes[] = [];
    interactionPowerTypes: BigInt[] = [];
    interactionPowers: BigInt[] = [];

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}


export function createDynamicLogicUpdatedData(input: DynamicLogicUpdatedData): CreatorLogicSet {
    let newEvent = changetype<CreatorLogicSet>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();


    let dynamicLogicTuple = changetype<ethereum.Tuple>([
        ethereum.Value.fromAddressArray(input.targets),
        ethereum.Value.fromBytesArray(input.signatures),
        ethereum.Value.fromBytesArray(input.datas),
        ethereum.Value.fromUnsignedBigIntArray(input.operators),
        ethereum.Value.fromBytesArray(input.literalOperands),
        ethereum.Value.fromUnsignedBigIntArray(input.interactionPowerTypes),
        ethereum.Value.fromUnsignedBigIntArray(input.interactionPowers)
    ]);

    let channelAddressParam = new ethereum.EventParam("channel", ethereum.Value.fromAddress(input.channel));

    let dynamicLogicParam = new ethereum.EventParam(
        "dynamicLogic",
        ethereum.Value.fromTuple(dynamicLogicTuple)
    );

    newEvent.parameters.push(channelAddressParam);
    newEvent.parameters.push(dynamicLogicParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as CreatorLogicSet;
}

export class TokenCreatedData {
    tokenId: BigInt = BIGINT_ZERO;
    uri: string = '';
    author: Address = Address.fromString(ZERO_ADDRESS);
    maxSupply: BigInt = BIGINT_ZERO;
    totalMinted: BigInt = BIGINT_ZERO;
    sponsor: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createTokenCreatedData(input: TokenCreatedData): TokenCreated {
    let newEvent = changetype<TokenCreated>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let tokenConfigTuple = changetype<ethereum.Tuple>([
        ethereum.Value.fromString(input.uri),
        ethereum.Value.fromAddress(input.author),
        ethereum.Value.fromUnsignedBigInt(input.maxSupply),
        ethereum.Value.fromUnsignedBigInt(input.totalMinted),
        ethereum.Value.fromAddress(input.sponsor)

    ]);


    let tokenIdParam = new ethereum.EventParam("tokenId", ethereum.Value.fromUnsignedBigInt(input.tokenId));
    let tokenConfigParam = new ethereum.EventParam("tokenConfig", ethereum.Value.fromTuple(tokenConfigTuple));

    newEvent.parameters.push(tokenIdParam);
    newEvent.parameters.push(tokenConfigParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as TokenCreated;

}


export class TokenMintedData {
    minter: Address = Address.fromString(ZERO_ADDRESS);
    mintReferral: Address = Address.fromString(ZERO_ADDRESS);
    tokenIds: BigInt[] = [];
    amounts: BigInt[] = [];
    data: Bytes = Bytes.fromI32(0);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}


export function createTokenMintedData(input: TokenMintedData): TokenMinted {
    let newEvent = changetype<TokenMinted>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let minterParam = new ethereum.EventParam("minter", ethereum.Value.fromAddress(input.minter));
    let mintReferralParam = new ethereum.EventParam("mintReferral", ethereum.Value.fromAddress(input.mintReferral));
    let tokenIdsParam = new ethereum.EventParam("tokenIds", ethereum.Value.fromUnsignedBigIntArray(input.tokenIds));
    let amountsParam = new ethereum.EventParam("amounts", ethereum.Value.fromUnsignedBigIntArray(input.amounts));
    let dataParam = new ethereum.EventParam("data", ethereum.Value.fromBytes(input.data));

    newEvent.parameters.push(minterParam);
    newEvent.parameters.push(mintReferralParam);
    newEvent.parameters.push(tokenIdsParam);
    newEvent.parameters.push(amountsParam);
    newEvent.parameters.push(dataParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as TokenMinted;
}

export class ERC20TransferredData {
    spender: Address = Address.fromString(ZERO_ADDRESS);
    recipient: Address = Address.fromString(ZERO_ADDRESS);
    amount: BigInt = BIGINT_ZERO;
    token: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createERC20TransferredData(input: ERC20TransferredData): ERC20Transferred {
    let newEvent = changetype<ERC20Transferred>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let spenderParam = new ethereum.EventParam("spender", ethereum.Value.fromAddress(input.spender));
    let recipientParam = new ethereum.EventParam("recipient", ethereum.Value.fromAddress(input.recipient));
    let amountParam = new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(input.amount));
    let tokenParam = new ethereum.EventParam("token", ethereum.Value.fromAddress(input.token));

    newEvent.parameters.push(spenderParam);
    newEvent.parameters.push(recipientParam);
    newEvent.parameters.push(amountParam);
    newEvent.parameters.push(tokenParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as ERC20Transferred;
}


export class ETHTransferredData {
    spender: Address = Address.fromString(ZERO_ADDRESS);
    recipient: Address = Address.fromString(ZERO_ADDRESS);
    amount: BigInt = BIGINT_ZERO;

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createETHTransferredData(input: ETHTransferredData): ETHTransferred {
    let newEvent = changetype<ETHTransferred>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let spenderParam = new ethereum.EventParam("spender", ethereum.Value.fromAddress(input.spender));
    let recipientParam = new ethereum.EventParam("recipient", ethereum.Value.fromAddress(input.recipient));
    let amountParam = new ethereum.EventParam("amount", ethereum.Value.fromUnsignedBigInt(input.amount));

    newEvent.parameters.push(spenderParam);
    newEvent.parameters.push(recipientParam);
    newEvent.parameters.push(amountParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as ETHTransferred;
}


export class SingleTokenTransferredData {
    operator: Address = Address.fromString(ZERO_ADDRESS);
    from: Address = Address.fromString(ZERO_ADDRESS);
    to: Address = Address.fromString(ZERO_ADDRESS);
    id: BigInt = BIGINT_ZERO;
    value: BigInt = BIGINT_ZERO;

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}


export function createSingleTokenTransferredData(input: SingleTokenTransferredData): TransferSingle {
    let newEvent = changetype<TransferSingle>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let operatorParam = new ethereum.EventParam("operator", ethereum.Value.fromAddress(input.operator));
    let fromParam = new ethereum.EventParam("from", ethereum.Value.fromAddress(input.from));
    let toParam = new ethereum.EventParam("to", ethereum.Value.fromAddress(input.to));
    let idParam = new ethereum.EventParam("id", ethereum.Value.fromUnsignedBigInt(input.id));
    let valueParam = new ethereum.EventParam("value", ethereum.Value.fromUnsignedBigInt(input.value));

    newEvent.parameters.push(operatorParam);
    newEvent.parameters.push(fromParam);
    newEvent.parameters.push(toParam);
    newEvent.parameters.push(idParam);
    newEvent.parameters.push(valueParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as TransferSingle;
}

export class BatchTokenTransferredData {
    operator: Address = Address.fromString(ZERO_ADDRESS);
    from: Address = Address.fromString(ZERO_ADDRESS);
    to: Address = Address.fromString(ZERO_ADDRESS);
    ids: BigInt[] = [];
    values: BigInt[] = [];

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createBatchTokenTransferredData(input: BatchTokenTransferredData): TransferBatch {
    let newEvent = changetype<TransferBatch>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let operatorParam = new ethereum.EventParam("operator", ethereum.Value.fromAddress(input.operator));
    let fromParam = new ethereum.EventParam("from", ethereum.Value.fromAddress(input.from));
    let toParam = new ethereum.EventParam("to", ethereum.Value.fromAddress(input.to));
    let idsParam = new ethereum.EventParam("ids", ethereum.Value.fromUnsignedBigIntArray(input.ids));
    let valuesParam = new ethereum.EventParam("values", ethereum.Value.fromUnsignedBigIntArray(input.values));

    newEvent.parameters.push(operatorParam);
    newEvent.parameters.push(fromParam);
    newEvent.parameters.push(toParam);
    newEvent.parameters.push(idsParam);
    newEvent.parameters.push(valuesParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as TransferBatch;
}


export class SignatureApprovedData {
    signature: Bytes = Bytes.fromI32(0);
    calldataAddressPosition: BigInt = BIGINT_ZERO;

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createSignatureApprovedData(input: SignatureApprovedData): SignatureApproved {
    let newEvent = changetype<SignatureApproved>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let signatureParam = new ethereum.EventParam("signature", ethereum.Value.fromBytes(input.signature));
    let calldataAddressPositionParam = new ethereum.EventParam("calldataAddressPosition", ethereum.Value.fromUnsignedBigInt(input.calldataAddressPosition));

    newEvent.parameters.push(signatureParam);
    newEvent.parameters.push(calldataAddressPositionParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as SignatureApproved;
}

export class FiniteChannelSettledData {
    caller: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createFiniteChannelSettledData(input: FiniteChannelSettledData): Settled {
    let newEvent = changetype<Settled>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let callerParam = new ethereum.EventParam("caller", ethereum.Value.fromAddress(input.caller));

    newEvent.parameters.push(callerParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as Settled;
}

export class UpgradeRegisteredData {
    baseImpl: Address = Address.fromString(ZERO_ADDRESS);
    upgradeImpl: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createUpgradeRegisteredData(input: UpgradeRegisteredData): UpgradeRegistered {
    let newEvent = changetype<UpgradeRegistered>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let baseImplParam = new ethereum.EventParam("baseImpl", ethereum.Value.fromAddress(input.baseImpl));
    let upgradeImplParam = new ethereum.EventParam("upgradeImpl", ethereum.Value.fromAddress(input.upgradeImpl));

    newEvent.parameters.push(baseImplParam);
    newEvent.parameters.push(upgradeImplParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as UpgradeRegistered;
}

export class UpgradeRemovedData {
    baseImpl: Address = Address.fromString(ZERO_ADDRESS);
    upgradeImpl: Address = Address.fromString(ZERO_ADDRESS);

    eventBlockNumber: BigInt = BIGINT_ZERO;
    eventBlockTimestamp: BigInt = BIGINT_ZERO;
    txHash: Bytes = Bytes.fromI32(0);
    logIndex: BigInt = BIGINT_ZERO;
    address: Address = Address.fromString(ZERO_ADDRESS);
}

export function createUpgradeRemovedData(input: UpgradeRemovedData): UpgradeRemoved {
    let newEvent = changetype<UpgradeRemoved>(newMockEvent());
    newEvent.parameters = new Array<ethereum.EventParam>();

    let baseImplParam = new ethereum.EventParam("baseImpl", ethereum.Value.fromAddress(input.baseImpl));
    let upgradeImplParam = new ethereum.EventParam("upgradeImpl", ethereum.Value.fromAddress(input.upgradeImpl));

    newEvent.parameters.push(baseImplParam);
    newEvent.parameters.push(upgradeImplParam);

    newEvent.block.number = input.eventBlockNumber;
    newEvent.block.timestamp = input.eventBlockTimestamp;
    newEvent.transaction.hash = input.txHash;
    newEvent.logIndex = input.logIndex;
    newEvent.address = input.address;

    return newEvent as UpgradeRemoved;
}