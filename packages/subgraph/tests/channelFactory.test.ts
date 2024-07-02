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

import { Channel } from '../src/generated/schema';
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
        test("properly sets fields for new channel", () => {
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

            const channel = Channel.load(CHANNEL_ADDRESS);

            /// check channel
            assert.stringEquals(channel!.uri, 'sample uri');
            assert.stringEquals(channel!.name, 'sample name');
            assert.stringEquals(channel!.admin, channelData.admin.toHexString());
            assert.stringEquals(channel!.managers[0], channelData.managers[0].toHexString());

        });
    });
});


