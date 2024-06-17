
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
import { ERC20TransferredData, ETHTransferredData, createERC20TransferredData, createETHTransferredData } from './utils';
import { handleERC20Transferred, handleETHTransferred } from '../src/mappings/templates/rewards/rewardsMappings';
import { Address, BigInt, Bytes } from '@graphprotocol/graph-ts';
import { RewardTransferEvent, User } from '../src/generated/schema';
import { NATIVE_TOKEN } from '../src/utils/constants';

const CHANNEL_ADDRESS = "0x0000000000000000000000000000000000000001";
const ERC20_CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000007";

const MINTER_ADDRESS = "0x000000000000000000000000000000000000000d"
const REFERRAL_ADDRESS = "0x000000000000000000000000000000000000000e"

describe("handle reward transfer events", () => {
    test("properly handles erc20 reward transfer", () => {
        const rewardTransferData = new ERC20TransferredData();
        rewardTransferData.spender = Address.fromString(MINTER_ADDRESS);
        rewardTransferData.recipient = Address.fromString(REFERRAL_ADDRESS);
        rewardTransferData.amount = BigInt.fromI32(1);
        rewardTransferData.token = Address.fromString(ERC20_CONTRACT_ADDRESS);

        rewardTransferData.eventBlockNumber = BigInt.fromI32(123456);
        rewardTransferData.eventBlockTimestamp = BigInt.fromI32(1620012345);
        rewardTransferData.txHash = Bytes.fromHexString("0x1234");
        rewardTransferData.logIndex = BigInt.fromI32(0);
        rewardTransferData.address = Address.fromString(CHANNEL_ADDRESS);

        const event = createERC20TransferredData(rewardTransferData);

        handleERC20Transferred(event);

        const rewardTransferEvent = RewardTransferEvent.load(rewardTransferData.txHash.toHexString() + '-0');

        assert.stringEquals(rewardTransferEvent!.from, MINTER_ADDRESS);
        assert.stringEquals(rewardTransferEvent!.to, REFERRAL_ADDRESS);
        assert.bigIntEquals(rewardTransferEvent!.amount, BigInt.fromI32(1));
        assert.bytesEquals(rewardTransferEvent!.token, Address.fromString(ERC20_CONTRACT_ADDRESS));

        /// user validation

        const spender = User.load(MINTER_ADDRESS);
        const recipient = User.load(REFERRAL_ADDRESS);

        assert.stringEquals(spender!.id, rewardTransferEvent!.from);
        assert.stringEquals(recipient!.id, rewardTransferEvent!.to);

    });

    test("properly handles eth reward transfer", () => {
        const rewardTransferData = new ETHTransferredData();
        rewardTransferData.spender = Address.fromString(MINTER_ADDRESS);
        rewardTransferData.recipient = Address.fromString(REFERRAL_ADDRESS);
        rewardTransferData.amount = BigInt.fromI32(1);

        rewardTransferData.eventBlockNumber = BigInt.fromI32(123456);
        rewardTransferData.eventBlockTimestamp = BigInt.fromI32(1620012345);
        rewardTransferData.txHash = Bytes.fromHexString("0x1234");
        rewardTransferData.logIndex = BigInt.fromI32(0);
        rewardTransferData.address = Address.fromString(CHANNEL_ADDRESS);

        const event = createETHTransferredData(rewardTransferData);

        handleETHTransferred(event);

        const rewardTransferEvent = RewardTransferEvent.load(rewardTransferData.txHash.toHexString() + '-0');

        assert.stringEquals(rewardTransferEvent!.from, MINTER_ADDRESS);
        assert.stringEquals(rewardTransferEvent!.to, REFERRAL_ADDRESS);
        assert.bigIntEquals(rewardTransferEvent!.amount, BigInt.fromI32(1));
        assert.bytesEquals(rewardTransferEvent!.token, Address.fromString(NATIVE_TOKEN));
        /// user validation

        const spender = User.load(MINTER_ADDRESS);
        const recipient = User.load(REFERRAL_ADDRESS);

        assert.stringEquals(spender!.id, rewardTransferEvent!.from);
        assert.stringEquals(recipient!.id, rewardTransferEvent!.to);
    });
});