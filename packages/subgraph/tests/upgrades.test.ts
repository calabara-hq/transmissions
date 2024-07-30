
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
import { ERC20TransferredData, ETHTransferredData, UpgradeRegisteredData, UpgradeRemovedData, createERC20TransferredData, createETHTransferredData, createUpgradeRegisteredData, createUpgradeRemovedData } from './utils';
import { handleERC20Transferred, handleETHTransferred } from '../src/mappings/templates/rewards/rewardsMappings';
import { Address, BigInt, Bytes } from '@graphprotocol/graph-ts';
import { ChannelUpgradeRegisteredEvent, RewardTransferEvent, User } from '../src/generated/schema';
import { NATIVE_TOKEN } from '../src/utils/constants';
import { handleUpgradeRegistered, handleUpgradeRemoved } from '../src/mappings/upgradePathMappings';

const CHANNEL_ADDRESS = "0x0000000000000000000000000000000000000001";
const ERC20_CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000007";

const BASE_IMPL = "0x000000000000000000000000000000000000000d"
const UPGRADE_IMPL = "0x000000000000000000000000000000000000000e"

describe("handle ugprade events", () => {
    beforeEach(() => {
        const upgradeRegistered = new UpgradeRegisteredData();
        upgradeRegistered.baseImpl = Address.fromString(BASE_IMPL);
        upgradeRegistered.upgradeImpl = Address.fromString(UPGRADE_IMPL);

        upgradeRegistered.eventBlockNumber = BigInt.fromI32(123456);
        upgradeRegistered.eventBlockTimestamp = BigInt.fromI32(1620012345);
        upgradeRegistered.txHash = Bytes.fromHexString("0x1234");
        upgradeRegistered.logIndex = BigInt.fromI32(0);
        upgradeRegistered.address = Address.fromString(CHANNEL_ADDRESS);

        const event = createUpgradeRegisteredData(upgradeRegistered);

        handleUpgradeRegistered(event);
    })


    test("properly handles an upgrade", () => {

        const upgradeRegisteredEvent = ChannelUpgradeRegisteredEvent.load(BASE_IMPL + "-" + UPGRADE_IMPL);

        assert.bytesEquals(upgradeRegisteredEvent!.baseImpl, Address.fromString(BASE_IMPL));
        assert.bytesEquals(upgradeRegisteredEvent!.upgradeImpl, Address.fromString(UPGRADE_IMPL));

    });

    test("properly removes an upgrade", () => {

        const upgradeRemoved = new UpgradeRemovedData();
        upgradeRemoved.baseImpl = Address.fromString(BASE_IMPL);
        upgradeRemoved.upgradeImpl = Address.fromString(UPGRADE_IMPL);

        upgradeRemoved.eventBlockNumber = BigInt.fromI32(123456);
        upgradeRemoved.eventBlockTimestamp = BigInt.fromI32(1620012345);
        upgradeRemoved.txHash = Bytes.fromHexString("0x1234");
        upgradeRemoved.logIndex = BigInt.fromI32(0);
        upgradeRemoved.address = Address.fromString(CHANNEL_ADDRESS);

        const event = createUpgradeRemovedData(upgradeRemoved);

        assert.assertNotNull(ChannelUpgradeRegisteredEvent.load(BASE_IMPL + "-" + UPGRADE_IMPL));

        handleUpgradeRemoved(event);

        assert.assertNull(ChannelUpgradeRegisteredEvent.load(BASE_IMPL + "-" + UPGRADE_IMPL));

    });

});