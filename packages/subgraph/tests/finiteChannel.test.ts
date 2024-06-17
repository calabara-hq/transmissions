import {
    assert,
    clearStore,
    test,
    describe,
    afterAll,
    beforeEach,
    afterEach,
    createMockedFunction,
    logStore
} from 'matchstick-as/assembly/index';

import { ChannelCreatedData, createChannelCreatedData, createFiniteChannelSettledData, FiniteChannelSettledData } from "./utils";
import { handleChannelCreated } from '../src/mappings/channelFactoryMappings';
import { Address, Bytes, BigInt, log } from '@graphprotocol/graph-ts';
import { finiteTransportBytes } from './utils';
import { handleFiniteChannelSettled } from '../src/mappings/templates/finiteChannel/finiteChannelMappings';
import { FiniteTransportConfig } from '../src/generated/schema';


const CHANNEL_ADDRESS = "0x0000000000000000000000000000000000000001";
const ADMIN_ADDRESS = "0x0000000000000000000000000000000000000002";
const MANAGER_ADDRESS = "0x0000000000000000000000000000000000000003";


afterEach(() => {
    clearStore();
})


describe('Finite Channel settlement', () => {

    beforeEach(() => {
        const channelData = new ChannelCreatedData();
        channelData.contractAddress = Address.fromString(CHANNEL_ADDRESS);
        channelData.uri = 'sample uri';
        channelData.name = 'sample name';
        channelData.admin = Address.fromString(ADMIN_ADDRESS);
        channelData.managers = [Address.fromString(MANAGER_ADDRESS)];
        channelData.transportConfig = Bytes.fromHexString(finiteTransportBytes);
        channelData.eventBlockNumber = BigInt.fromI32(123456);
        channelData.eventBlockTimestamp = BigInt.fromI32(1620012345);
        channelData.txHash = Bytes.fromHexString("0x1234");
        channelData.logIndex = BigInt.fromI32(0);
        channelData.address = Address.fromString(CHANNEL_ADDRESS);

        const event = createChannelCreatedData(channelData);

        handleChannelCreated(event);
    })


    test("properly handles settled event", () => {
        const settledData = new FiniteChannelSettledData();
        settledData.caller = Address.fromString(ADMIN_ADDRESS);

        settledData.eventBlockNumber = BigInt.fromI32(123456);
        settledData.eventBlockTimestamp = BigInt.fromI32(1620012345);
        settledData.txHash = Bytes.fromHexString("0x1234");
        settledData.logIndex = BigInt.fromI32(0);
        settledData.address = Address.fromString(CHANNEL_ADDRESS);

        const event = createFiniteChannelSettledData(settledData);

        handleFiniteChannelSettled(event);


        const finiteTransportConfig = FiniteTransportConfig.load(CHANNEL_ADDRESS);

        assert.booleanEquals(finiteTransportConfig!.settled, true);
        assert.bytesEquals(finiteTransportConfig!.settledBy, settledData.caller);
        assert.bigIntEquals(finiteTransportConfig!.settledAt, settledData.eventBlockTimestamp);
    })
})