
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
import { ChannelCreatedData, createChannelCreatedData, createManagersUpdatedData, infiniteTransportBytes, ManagersUpdatedData } from './utils';
import { Address, Bytes, BigInt, log } from '@graphprotocol/graph-ts';
import { Channel } from '../src/generated/schema';
import { handleChannelCreated } from '../src/mappings/channelFactoryMappings';
import { handleUpdateManagers } from '../src/mappings/templates/channel/channelMappings';

const CHANNEL_ADDRESS = "0x0000000000000000000000000000000000000001";
const ADMIN_ADDRESS = "0x0000000000000000000000000000000000000002";
const MANAGER1_ADDRESS = "0x0000000000000000000000000000000000000003";
const MANAGER2_ADDRESS = "0x0000000000000000000000000000000000000004";
const MANAGER3_ADDRESS = "0x0000000000000000000000000000000000000005";


afterEach(() => {
    clearStore();
})

describe("Channel", () => {

    beforeEach(() => {
        const channelData = new ChannelCreatedData();
        channelData.id = Address.fromString(CHANNEL_ADDRESS);
        channelData.uri = 'sample uri';
        channelData.admin = Address.fromString(ADMIN_ADDRESS);
        channelData.managers = [Address.fromString(MANAGER1_ADDRESS)];
        channelData.transportConfig = Bytes.fromHexString(infiniteTransportBytes)
        channelData.eventBlockNumber = BigInt.fromI32(123456);
        channelData.eventBlockTimestamp = BigInt.fromI32(1620012345);
        channelData.txHash = Bytes.fromHexString("0x1234");
        channelData.logIndex = BigInt.fromI32(0);
        channelData.address = Address.fromString(CHANNEL_ADDRESS);

        const event = createChannelCreatedData(channelData);

        handleChannelCreated(event);

    })


    describe("handlUpdateManagers", () => {
        test("properly updates managers", () => {

            const managersUpdatedData = new ManagersUpdatedData();
            managersUpdatedData.managers = [Address.fromString(MANAGER1_ADDRESS), Address.fromString(MANAGER2_ADDRESS), Address.fromString(MANAGER3_ADDRESS)];
            managersUpdatedData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createManagersUpdatedData(managersUpdatedData);

            handleUpdateManagers(event);

            const updatedChannel = Channel.load(CHANNEL_ADDRESS);

            assert.bytesEquals(updatedChannel!.managers[0], managersUpdatedData.managers[0]);
            assert.bytesEquals(updatedChannel!.managers[1], managersUpdatedData.managers[1]);
            assert.bytesEquals(updatedChannel!.managers[2], managersUpdatedData.managers[2]);

        });
    });
});