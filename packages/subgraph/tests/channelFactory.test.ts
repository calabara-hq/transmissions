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

import { Channel, TransportLayer } from '../src/generated/schema';
import { handleChannelCreated } from '../src/mappings/channelFactoryMappings';
import { ChannelCreatedData, createChannelCreatedData, finiteTransportBytes, infiniteTransportBytes } from './utils';
import { Address, Bytes, BigInt, log } from '@graphprotocol/graph-ts';


const CHANNEL_ADDRESS = "0x0000000000000000000000000000000000000001";
const ADMIN_ADDRESS = "0x0000000000000000000000000000000000000002";
const MANAGER_ADDRESS = "0x0000000000000000000000000000000000000003";



afterEach(() => {
    clearStore();
})

describe('ChannelFactory', () => {
    describe('handleChannelCreated', () => {
        test("properly sets fields for new finite channel", () => {
            const channelData = new ChannelCreatedData();
            channelData.id = Address.fromString(CHANNEL_ADDRESS);
            channelData.uri = 'sample uri';
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

            const channel = Channel.load(CHANNEL_ADDRESS);
            const transport = TransportLayer.load(CHANNEL_ADDRESS);

            assert.stringEquals(channel!.uri, 'sample uri');
            assert.bytesEquals(channel!.admin, channelData.admin);
            assert.bytesEquals(channel!.managers[0], channelData.managers[0]);

            assert.assertNotNull(transport);

            if (transport != null) {
                assert.stringEquals(transport.type!, 'finite');
                assert.bigIntEquals(transport.createStart!, BigInt.fromI32(1));
                assert.bigIntEquals(transport.mintStart!, BigInt.fromI32(2));
                assert.bigIntEquals(transport.mintEnd!, BigInt.fromI32(3));
                assert.bigIntEquals(transport.ranks![0], BigInt.fromI32(1));
                assert.bigIntEquals(transport.allocations![0], BigInt.fromI32(1));
                assert.bigIntEquals(transport.totalAllocation!, BigInt.fromI32(1));
                assert.bytesEquals(transport.token!, Address.fromString('0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'));

            }
        });

        test("properly sets fields for new infinite channel", () => {
            const channelData = new ChannelCreatedData();
            channelData.id = Address.fromString(CHANNEL_ADDRESS);
            channelData.uri = 'sample uri';
            channelData.admin = Address.fromString(ADMIN_ADDRESS);
            channelData.managers = [Address.fromString(MANAGER_ADDRESS)];
            channelData.transportConfig = Bytes.fromHexString(infiniteTransportBytes);
            channelData.eventBlockNumber = BigInt.fromI32(123456);
            channelData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            channelData.txHash = Bytes.fromHexString("0x1234");
            channelData.logIndex = BigInt.fromI32(0);
            channelData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createChannelCreatedData(channelData);

            handleChannelCreated(event);

            const channel = Channel.load(CHANNEL_ADDRESS);
            const transport = TransportLayer.load(CHANNEL_ADDRESS);

            assert.stringEquals(channel!.uri, 'sample uri');
            assert.bytesEquals(channel!.admin, channelData.admin);
            assert.bytesEquals(channel!.managers[0], channelData.managers[0]);

            assert.assertNotNull(transport);

            if (transport != null) {
                assert.stringEquals(transport.type!, 'infinite');
                assert.bigIntEquals(transport.saleDuration!, BigInt.fromI32(1));
            }
        });
    });
});