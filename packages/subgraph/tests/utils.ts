import { SetupNewContract } from "../src/generated/ChannelFactoryV1/ChannelFactory";
import { ManagersUpdated } from "../src/generated/templates/Channel/Channel";
import { BIGINT_ONE, BIGINT_ZERO, ZERO_ADDRESS } from '../src/utils/constants';
import { BigInt, Address, Bytes, ethereum } from "@graphprotocol/graph-ts";
import { newMockEvent } from 'matchstick-as/assembly/index';


export const finiteTransportBytes =
    "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000000000000000001000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001"

export const infiniteTransportBytes = "0x0000000000000000000000000000000000000000000000000000000000000001"


export class ChannelCreatedData {
    id: Address = Address.fromString(ZERO_ADDRESS);
    uri: string = '';
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

    let contractAddressParam = new ethereum.EventParam("contractAddress", ethereum.Value.fromAddress(input.id));
    let uriParam = new ethereum.EventParam("uri", ethereum.Value.fromString(input.uri));
    let adminParam = new ethereum.EventParam("defaultAdmin", ethereum.Value.fromAddress(input.admin));
    let managersParam = new ethereum.EventParam("managers", ethereum.Value.fromAddressArray(input.managers));
    let transportConfigParam = new ethereum.EventParam("transportConfig", ethereum.Value.fromBytes(input.transportConfig));

    newEvent.parameters.push(contractAddressParam);
    newEvent.parameters.push(uriParam);
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