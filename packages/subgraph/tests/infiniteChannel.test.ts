import {
    assert,
    clearStore,
    test,
    describe,
    beforeEach,
    afterEach,
} from 'matchstick-as/assembly/index';

import { ChannelCreatedData, createChannelCreatedData, createInfiniteTransportConfigSetData, infiniteTransportBytes, InfiniteTransportConfigSetData } from "./utils";
import { handleChannelCreated } from '../src/mappings/channelFactoryMappings';
import { Address, Bytes, BigInt, log } from '@graphprotocol/graph-ts';
import { InfiniteTransportConfig, TransportLayer } from '../src/generated/schema';
import { handleInfiniteTransportConfigSet } from '../src/mappings/templates/channel/infiniteChannelMappings';


const CHANNEL_ADDRESS = "0x0000000000000000000000000000000000000001";
const ADMIN_ADDRESS = "0x0000000000000000000000000000000000000002";
const MANAGER_ADDRESS = "0x0000000000000000000000000000000000000003";

afterEach(() => {
    clearStore();
})


describe('Infinite Channel', () => {

    beforeEach(() => {
        const channelData = new ChannelCreatedData();
        channelData.contractAddress = Address.fromString(CHANNEL_ADDRESS);
        channelData.uri = 'sample uri';
        channelData.name = 'sample name';
        channelData.admin = Address.fromString(ADMIN_ADDRESS);
        channelData.managers = [Address.fromString(MANAGER_ADDRESS)];
        channelData.transportConfig = Bytes.fromHexString(infiniteTransportBytes);
        channelData.eventBlockNumber = BigInt.fromI32(123456);
        channelData.eventBlockTimestamp = BigInt.fromI32(1620012345);
        channelData.txHash = Bytes.fromHexString("0x1234");
        channelData.logIndex = BigInt.fromI32(0);
        channelData.address = Address.fromString(CHANNEL_ADDRESS);

        const channelCreatedEvent = createChannelCreatedData(channelData);

        handleChannelCreated(channelCreatedEvent);

        const infiniteTransportConfig = new InfiniteTransportConfigSetData();
        infiniteTransportConfig.caller = Address.fromString(ADMIN_ADDRESS);
        infiniteTransportConfig.saleDuration = BigInt.fromI32(123);
        infiniteTransportConfig.address = Address.fromString(CHANNEL_ADDRESS);

        const infiniteTransportConfigEvent = createInfiniteTransportConfigSetData(infiniteTransportConfig);

        handleInfiniteTransportConfigSet(infiniteTransportConfigEvent);

    })


    describe('Transport Layer', () => {
        test("properly sets fields on InfiniteTransportConfigSet", () => {
            const infiniteTransportConfig = InfiniteTransportConfig.load(CHANNEL_ADDRESS);
            const transportLayer = TransportLayer.load(CHANNEL_ADDRESS);

            assert.bigIntEquals(infiniteTransportConfig!.saleDuration, BigInt.fromI32(123));

            assert.stringEquals(transportLayer!.id, CHANNEL_ADDRESS);
            assert.stringEquals(transportLayer!.type, 'infinite');
            assert.stringEquals(transportLayer!.infiniteTransportConfig!, CHANNEL_ADDRESS);

        });
    });

})