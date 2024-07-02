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

import { ChannelCreatedData, createChannelCreatedData, createFiniteChannelSettledData, createFiniteTransportConfigSetData, FiniteChannelSettledData, FiniteTransportConfigSetData } from "./utils";
import { handleChannelCreated } from '../src/mappings/channelFactoryMappings';
import { Address, Bytes, BigInt, log } from '@graphprotocol/graph-ts';
import { finiteTransportBytes } from './utils';
import { handleFiniteChannelSettled, handleFiniteTransportConfigSet } from '../src/mappings/templates/channel/finiteChannelMappings';
import { FiniteTransportConfig, TransportLayer } from '../src/generated/schema';
import { ZERO_ADDRESS } from '../src/utils/constants';


const CHANNEL_ADDRESS = "0x0000000000000000000000000000000000000001";
const ADMIN_ADDRESS = "0x0000000000000000000000000000000000000002";
const MANAGER_ADDRESS = "0x0000000000000000000000000000000000000003";
const ERC20_CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000007";


afterEach(() => {
    clearStore();
})


describe('Finite Channel', () => {

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

        const channelCreatedEvent = createChannelCreatedData(channelData);

        handleChannelCreated(channelCreatedEvent);

        const finiteTransportConfig = new FiniteTransportConfigSetData();
        finiteTransportConfig.caller = Address.fromString(ADMIN_ADDRESS);
        finiteTransportConfig.createStart = BigInt.fromI32(123);
        finiteTransportConfig.mintStart = BigInt.fromI32(456);
        finiteTransportConfig.mintEnd = BigInt.fromI32(789);
        finiteTransportConfig.ranks = [BigInt.fromI32(1), BigInt.fromI32(2)];
        finiteTransportConfig.allocations = [BigInt.fromI32(100), BigInt.fromI32(200)];
        finiteTransportConfig.totalAllocation = BigInt.fromI32(300);
        finiteTransportConfig.token = Address.fromString(ERC20_CONTRACT_ADDRESS);
        finiteTransportConfig.address = Address.fromString(CHANNEL_ADDRESS);

        const finiteTransportConfigEvent = createFiniteTransportConfigSetData(finiteTransportConfig);

        handleFiniteTransportConfigSet(finiteTransportConfigEvent);


    })


    describe('Transport Layer', () => {
        test("properly sets fields on FiniteTransportConfigSet", () => {
            const finiteTransportConfig = FiniteTransportConfig.load(CHANNEL_ADDRESS);
            const transportLayer = TransportLayer.load(CHANNEL_ADDRESS);

            assert.bigIntEquals(finiteTransportConfig!.createStart, BigInt.fromI32(123));
            assert.bigIntEquals(finiteTransportConfig!.mintStart, BigInt.fromI32(456));
            assert.bigIntEquals(finiteTransportConfig!.mintEnd, BigInt.fromI32(789));
            assert.bigIntEquals(finiteTransportConfig!.ranks[0], BigInt.fromI32(1));
            assert.bigIntEquals(finiteTransportConfig!.ranks[1], BigInt.fromI32(2));
            assert.bigIntEquals(finiteTransportConfig!.allocations[0], BigInt.fromI32(100));
            assert.bigIntEquals(finiteTransportConfig!.allocations[1], BigInt.fromI32(200));
            assert.bigIntEquals(finiteTransportConfig!.totalAllocation, BigInt.fromI32(300));
            assert.bytesEquals(finiteTransportConfig!.token, Address.fromString(ERC20_CONTRACT_ADDRESS));

            assert.booleanEquals(finiteTransportConfig!.settled, false);
            assert.bytesEquals(finiteTransportConfig!.settledBy, Address.fromString(ZERO_ADDRESS));
            assert.bigIntEquals(finiteTransportConfig!.settledAt, BigInt.fromI32(0));

            assert.stringEquals(transportLayer!.id, CHANNEL_ADDRESS);
            assert.stringEquals(transportLayer!.type, 'finite');
            assert.stringEquals(transportLayer!.finiteTransportConfig!, CHANNEL_ADDRESS);

        });
    });


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