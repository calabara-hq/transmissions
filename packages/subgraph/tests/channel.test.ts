
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
import { BatchTokenTransferredData, ChannelCreatedData, ChannelMetadataUpdatedData, ConfigUpdatedData, createBatchTokenTransferredData, createChannelCreatedData, createChannelMetadataUpdatedData, createConfigUpdatedData, createCustomFeesUpdatedData, createDynamicLogicUpdatedData, createERC20TransferredData, createETHTransferredData, createManagerRenouncedData, createManagersUpdatedData, createSignatureApprovedData, createSingleTokenTransferredData, createTokenCreatedData, createTokenMintedData, createTransferAdminData, CustomFeesUpdatedData, DynamicLogicUpdatedData, ERC20TransferredData, ETHTransferredData, infiniteTransportBytes, ManagerRenouncedData, ManagersUpdatedData, SignatureApprovedData, SingleTokenTransferredData, TokenCreatedData, TokenMintedData, TransferAdminData } from './utils';
import { Address, Bytes, BigInt, log } from '@graphprotocol/graph-ts';
import { ApprovedDynamicLogicSignature, Channel, CustomFees, DynamicLogic, FeeConfig, LogicConfig, Mint, RewardTransferEvent, Token, TokenHolder, User } from '../src/generated/schema';
import { handleChannelCreated } from '../src/mappings/channelFactoryMappings';
import { handleRenounceManager, handleTokenBatchMinted, handleTokenCreated, handleTransferAdmin, handleTransferBatchToken, handleTransferSingleToken, handleUpdateChannelMetadata, handleUpdateConfig, handleUpdateManagers } from '../src/mappings/templates/channel/channelMappings';
import { handleUpdateCustomFees } from '../src/mappings/customFeeMappings';
import { BIGINT_10K, ZERO_ADDRESS } from '../src/utils/constants';
import { handleSignatureApproved, handleUpdateDynamicCreatorLogic, handleUpdateDynamicMinterLogic } from '../src/mappings/dynamicLogicMappings';

const CHANNEL_ADDRESS = "0x0000000000000000000000000000000000000001";
const ADMIN_ADDRESS = "0x0000000000000000000000000000000000000002";
const MANAGER1_ADDRESS = "0x0000000000000000000000000000000000000003";
const MANAGER2_ADDRESS = "0x0000000000000000000000000000000000000004";
const MANAGER3_ADDRESS = "0x0000000000000000000000000000000000000005";

const CHANNEL_TREASURY_ADDRESS = "0x0000000000000000000000000000000000000006";
const UPLINK_BPS = BigInt.fromI32(1000);
const CHANNEL_BPS = BigInt.fromI32(1000);
const CREATOR_BPS = BigInt.fromI32(1000);
const MINT_REFERRAL_BPS = BigInt.fromI32(1000);
const SPONSOR_BPS = BigInt.fromI32(1000);
const ERC20_MINT_PRICE = BigInt.fromI32(100000000);
const ETH_MINT_PRICE = BigInt.fromI32(1000000);
const ERC20_CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000007";


const FEE_CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000008"
const LOGIC_CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000009"

const LOGIC_TARGET_0 = "0x000000000000000000000000000000000000000a"
const LOGIC_SIGNATURE_0 = "0x12345678"
const LOGIC_DATA_0 = "0x00"
const LOGIC_OPERATOR_0 = 0;
const LOGIC_LITERAL_OPERAND_0 = "0x01"
const LOGIC_INTERACTION_POWER_TYPE_0 = 0;
const LOGIC_INTERACTION_POWER_0 = BIGINT_10K;

const CREATOR_ADDRESS = "0x000000000000000000000000000000000000000b"
const SPONSOR_ADDRESS = "0x000000000000000000000000000000000000000c"
const MINTER_ADDRESS = "0x000000000000000000000000000000000000000d"
const REFERRAL_ADDRESS = "0x000000000000000000000000000000000000000e"



afterEach(() => {
    clearStore();
})

describe("Channel", () => {

    beforeEach(() => {
        const channelData = new ChannelCreatedData();
        channelData.contractAddress = Address.fromString(CHANNEL_ADDRESS);
        channelData.uri = 'sample uri';
        channelData.name = 'sample name';
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

    describe("handle channel metadata updated event", () => {
        beforeEach(() => {
            /// mock the default token on initialization
            const tokenCreatedData = new TokenCreatedData();
            tokenCreatedData.tokenId = BigInt.fromI32(0);
            tokenCreatedData.author = Address.fromString(CREATOR_ADDRESS);
            tokenCreatedData.sponsor = Address.fromString(SPONSOR_ADDRESS);
            tokenCreatedData.uri = "sample uri";
            tokenCreatedData.maxSupply = BigInt.fromI32(100);
            tokenCreatedData.totalMinted = BigInt.fromI32(0);

            tokenCreatedData.eventBlockNumber = BigInt.fromI32(123456);
            tokenCreatedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            tokenCreatedData.txHash = Bytes.fromHexString("0x1234");
            tokenCreatedData.logIndex = BigInt.fromI32(0);
            tokenCreatedData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createTokenCreatedData(tokenCreatedData);

            handleTokenCreated(event);

        });
        test("properly updates channel metadata", () => {
            const metadataUpdatedData = new ChannelMetadataUpdatedData();
            metadataUpdatedData.updater = Address.fromString(ADMIN_ADDRESS);
            metadataUpdatedData.channelName = "new name";
            metadataUpdatedData.uri = "new uri";

            metadataUpdatedData.eventBlockNumber = BigInt.fromI32(123456);
            metadataUpdatedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            metadataUpdatedData.txHash = Bytes.fromHexString("0x1234");
            metadataUpdatedData.logIndex = BigInt.fromI32(0);
            metadataUpdatedData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createChannelMetadataUpdatedData(metadataUpdatedData);

            handleUpdateChannelMetadata(event);

            const updatedChannel = Channel.load(CHANNEL_ADDRESS);

            assert.stringEquals(updatedChannel!.name, "new name");
            assert.stringEquals(updatedChannel!.uri, "new uri");

            const updatedTokenZero = Token.load(CHANNEL_ADDRESS + '-0');
            assert.stringEquals(updatedTokenZero!.uri, "new uri");

        })
    })


    describe("handle RBAC events", () => {
        test("properly updates managers", () => {

            const managersUpdatedData = new ManagersUpdatedData();
            managersUpdatedData.managers = [Address.fromString(MANAGER1_ADDRESS), Address.fromString(MANAGER2_ADDRESS), Address.fromString(MANAGER3_ADDRESS)];
            managersUpdatedData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createManagersUpdatedData(managersUpdatedData);

            handleUpdateManagers(event);

            const updatedChannel = Channel.load(CHANNEL_ADDRESS);

            assert.stringEquals(updatedChannel!.admin, ADMIN_ADDRESS);

            assert.stringEquals(updatedChannel!.managers[0], managersUpdatedData.managers[0].toHexString());
            assert.stringEquals(updatedChannel!.managers[1], managersUpdatedData.managers[1].toHexString());
            assert.stringEquals(updatedChannel!.managers[2], managersUpdatedData.managers[2].toHexString());

        });

        test("properly renounces manager", () => {
            const managerRenouncedData = new ManagerRenouncedData();
            managerRenouncedData.manager = Address.fromString(MANAGER1_ADDRESS);
            managerRenouncedData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createManagerRenouncedData(managerRenouncedData);
            handleRenounceManager(event);

            const updatedChannel = Channel.load(CHANNEL_ADDRESS);

            assert.stringEquals(updatedChannel!.admin, ADMIN_ADDRESS);
            assert.i32Equals(updatedChannel!.managers.length, 0);

        });

        test("properly transfers admin", () => {
            const adminTransferredData = new TransferAdminData();
            adminTransferredData.previousAdmin = Address.fromString(ADMIN_ADDRESS);
            adminTransferredData.newAdmin = Address.fromString(MANAGER2_ADDRESS);
            adminTransferredData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createTransferAdminData(adminTransferredData);

            handleTransferAdmin(event);

            const updatedChannel = Channel.load(CHANNEL_ADDRESS);
            assert.stringEquals(updatedChannel!.admin, MANAGER2_ADDRESS);

        });
    });

    describe("handleUpdateCustomFees", () => {
        beforeEach(() => {
            const customFeesUpdatedData = new CustomFeesUpdatedData();
            customFeesUpdatedData.channel = Address.fromString(CHANNEL_ADDRESS);
            customFeesUpdatedData.channelTreasury = Address.fromString(CHANNEL_TREASURY_ADDRESS);
            customFeesUpdatedData.uplinkBps = UPLINK_BPS;
            customFeesUpdatedData.channelBps = CHANNEL_BPS;
            customFeesUpdatedData.creatorBps = CREATOR_BPS;
            customFeesUpdatedData.mintReferralBps = MINT_REFERRAL_BPS;
            customFeesUpdatedData.sponsorBps = SPONSOR_BPS;
            customFeesUpdatedData.erc20MintPrice = ERC20_MINT_PRICE;
            customFeesUpdatedData.ethMintPrice = ETH_MINT_PRICE;
            customFeesUpdatedData.erc20Contract = Address.fromString(ERC20_CONTRACT_ADDRESS);
            customFeesUpdatedData.eventBlockNumber = BigInt.fromI32(123456);
            customFeesUpdatedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            customFeesUpdatedData.txHash = Bytes.fromHexString("0x1234");
            customFeesUpdatedData.logIndex = BigInt.fromI32(0);
            customFeesUpdatedData.address = Address.fromString(FEE_CONTRACT_ADDRESS);

            const event = createCustomFeesUpdatedData(customFeesUpdatedData);

            handleUpdateCustomFees(event);
        });


        test("properly updates custom fees", () => {
            const updatedFees = CustomFees.load(CHANNEL_ADDRESS);

            assert.bytesEquals(updatedFees!.channelTreasury, Address.fromString(CHANNEL_TREASURY_ADDRESS));
            assert.bigIntEquals(updatedFees!.uplinkBps, UPLINK_BPS);
            assert.bigIntEquals(updatedFees!.channelBps, CHANNEL_BPS);
            assert.bigIntEquals(updatedFees!.creatorBps, CREATOR_BPS);
            assert.bigIntEquals(updatedFees!.mintReferralBps, MINT_REFERRAL_BPS);
            assert.bigIntEquals(updatedFees!.sponsorBps, SPONSOR_BPS);
            assert.bigIntEquals(updatedFees!.ethMintPrice, ETH_MINT_PRICE);
            assert.bigIntEquals(updatedFees!.erc20MintPrice, ERC20_MINT_PRICE);
            assert.bytesEquals(updatedFees!.erc20Contract, Address.fromString(ERC20_CONTRACT_ADDRESS));
        });


        test("properly links fee config update with custom fees", () => {

            simulateConfigUpdateEvent(BigInt.fromI32(0), Address.fromString(FEE_CONTRACT_ADDRESS), Address.fromString(LOGIC_CONTRACT_ADDRESS));

            const updatedFeeConfig = FeeConfig.load(CHANNEL_ADDRESS);
            const channel = Channel.load(CHANNEL_ADDRESS);

            assert.stringEquals(updatedFeeConfig!.type, "customFees");
            assert.bytesEquals(updatedFeeConfig!.updatedBy, Address.fromString(ADMIN_ADDRESS));
            assert.bytesEquals(updatedFeeConfig!.feeContract, Address.fromString(FEE_CONTRACT_ADDRESS));

            const updatedCustomFees = CustomFees.load(CHANNEL_ADDRESS);

            assert.stringEquals(channel!.fees!, updatedFeeConfig!.id);
            assert.stringEquals(updatedCustomFees!.id, updatedFeeConfig!.customFees!);

        });

        test("properly unlinks fee config update with custom fees set to address zero", () => {

            // first, link the fee config with custom fees

            simulateConfigUpdateEvent(BigInt.fromI32(0), Address.fromString(FEE_CONTRACT_ADDRESS), Address.fromString(LOGIC_CONTRACT_ADDRESS));

            // then, unlink the fee config with custom fees

            simulateConfigUpdateEvent(BigInt.fromI32(0), Address.fromString(ZERO_ADDRESS), Address.fromString(LOGIC_CONTRACT_ADDRESS));

            const updatedFeeConfig = FeeConfig.load(CHANNEL_ADDRESS);
            const channel = Channel.load(CHANNEL_ADDRESS);

            assert.stringEquals(channel!.fees!, updatedFeeConfig!.id);

            assert.stringEquals(updatedFeeConfig!.type, "");
            assert.bytesEquals(updatedFeeConfig!.updatedBy, Address.fromString(ADMIN_ADDRESS));
            assert.bytesEquals(updatedFeeConfig!.feeContract, Address.fromHexString(ZERO_ADDRESS));

            /// customFees should be deleted from feeConfig entity
            assert.assertNull(updatedFeeConfig!.customFees);

            const updatedCustomFees = CustomFees.load(CHANNEL_ADDRESS);

            /// custom fees entity for channel should be deleted
            assert.assertNull(updatedCustomFees);

        });
    });


    describe("handle update logic", () => {
        beforeEach(() => {
            const dynamicCreatorLogicUpdatedData = new DynamicLogicUpdatedData();
            dynamicCreatorLogicUpdatedData.channel = Address.fromString(CHANNEL_ADDRESS);
            dynamicCreatorLogicUpdatedData.targets = [Address.fromString(LOGIC_TARGET_0)];
            dynamicCreatorLogicUpdatedData.signatures = [Bytes.fromHexString(LOGIC_SIGNATURE_0)];
            dynamicCreatorLogicUpdatedData.datas = [Bytes.fromHexString(LOGIC_DATA_0)];
            dynamicCreatorLogicUpdatedData.operators = [BigInt.fromI32(LOGIC_OPERATOR_0)];
            dynamicCreatorLogicUpdatedData.literalOperands = [Bytes.fromHexString(LOGIC_LITERAL_OPERAND_0)];
            dynamicCreatorLogicUpdatedData.interactionPowerTypes = [BigInt.fromI32(LOGIC_INTERACTION_POWER_TYPE_0)];
            dynamicCreatorLogicUpdatedData.interactionPowers = [LOGIC_INTERACTION_POWER_0];

            dynamicCreatorLogicUpdatedData.eventBlockNumber = BigInt.fromI32(123456);
            dynamicCreatorLogicUpdatedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            dynamicCreatorLogicUpdatedData.txHash = Bytes.fromHexString("0x1234");
            dynamicCreatorLogicUpdatedData.logIndex = BigInt.fromI32(0);
            dynamicCreatorLogicUpdatedData.address = Address.fromString(CHANNEL_ADDRESS);

            const dynamicMinterLogicUpdatedData = new DynamicLogicUpdatedData();

            dynamicMinterLogicUpdatedData.channel = Address.fromString(CHANNEL_ADDRESS);
            dynamicMinterLogicUpdatedData.targets = [Address.fromString(LOGIC_TARGET_0)];
            dynamicMinterLogicUpdatedData.signatures = [Bytes.fromHexString(LOGIC_SIGNATURE_0)];
            dynamicMinterLogicUpdatedData.datas = [Bytes.fromHexString(LOGIC_DATA_0)];
            dynamicMinterLogicUpdatedData.operators = [BigInt.fromI32(LOGIC_OPERATOR_0)];
            dynamicMinterLogicUpdatedData.literalOperands = [Bytes.fromHexString(LOGIC_LITERAL_OPERAND_0)];
            dynamicMinterLogicUpdatedData.interactionPowerTypes = [BigInt.fromI32(LOGIC_INTERACTION_POWER_TYPE_0)];
            dynamicMinterLogicUpdatedData.interactionPowers = [LOGIC_INTERACTION_POWER_0];

            dynamicMinterLogicUpdatedData.eventBlockNumber = BigInt.fromI32(123456);
            dynamicMinterLogicUpdatedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            dynamicMinterLogicUpdatedData.txHash = Bytes.fromHexString("0x1234");
            dynamicMinterLogicUpdatedData.logIndex = BigInt.fromI32(0);
            dynamicMinterLogicUpdatedData.address = Address.fromString(CHANNEL_ADDRESS);




            const creatorLogicSetEvent = createDynamicLogicUpdatedData(dynamicCreatorLogicUpdatedData);
            const minterLogicSetEvent = createDynamicLogicUpdatedData(dynamicMinterLogicUpdatedData);

            handleUpdateDynamicCreatorLogic(creatorLogicSetEvent);
            handleUpdateDynamicMinterLogic(minterLogicSetEvent);
        });


        test("properly updates dynamic creator logic", () => {
            const creatorLogic = DynamicLogic.load(CHANNEL_ADDRESS + "-creator");

            assert.bytesEquals(creatorLogic!.targets[0], Address.fromString(LOGIC_TARGET_0));
            assert.bytesEquals(creatorLogic!.signatures[0], Bytes.fromHexString(LOGIC_SIGNATURE_0));
            assert.bytesEquals(creatorLogic!.datas[0], Bytes.fromHexString(LOGIC_DATA_0));
            assert.bigIntEquals(creatorLogic!.operators[0], BigInt.fromI32(LOGIC_OPERATOR_0));
            assert.bytesEquals(creatorLogic!.literalOperands[0], Bytes.fromHexString(LOGIC_LITERAL_OPERAND_0));
            assert.bigIntEquals(creatorLogic!.interactionPowerTypes[0], BigInt.fromI32(LOGIC_INTERACTION_POWER_TYPE_0));
            assert.bigIntEquals(creatorLogic!.interactionPowers[0], LOGIC_INTERACTION_POWER_0);

        });

        test("properly links logic config update with creator logic", () => {

            simulateConfigUpdateEvent(BigInt.fromI32(1), Address.fromString(FEE_CONTRACT_ADDRESS), Address.fromString(LOGIC_CONTRACT_ADDRESS));

            const updatedLogicConfig = LogicConfig.load(CHANNEL_ADDRESS + "-creator");
            const channel = Channel.load(CHANNEL_ADDRESS);

            const updatedDynamicLogic = DynamicLogic.load(CHANNEL_ADDRESS + "-creator");

            assert.bytesEquals(updatedLogicConfig!.logicContract, Address.fromString(LOGIC_CONTRACT_ADDRESS));
            assert.bytesEquals(updatedLogicConfig!.updatedBy, Address.fromString(ADMIN_ADDRESS));

            assert.stringEquals(channel!.creatorLogic!, updatedLogicConfig!.id);
            assert.stringEquals(updatedLogicConfig!.id, updatedDynamicLogic!.id);

        });

        test("properly unlinks logic config update with logic set to address zero", () => {

            // first, link the logic config with creator logic

            simulateConfigUpdateEvent(BigInt.fromI32(1), Address.fromString(FEE_CONTRACT_ADDRESS), Address.fromString(LOGIC_CONTRACT_ADDRESS));

            // then, unlink the logic config with creator logic

            simulateConfigUpdateEvent(BigInt.fromI32(1), Address.fromString(FEE_CONTRACT_ADDRESS), Address.fromString(ZERO_ADDRESS));

            const updatedLogicConfig = LogicConfig.load(CHANNEL_ADDRESS + "-creator");
            const channel = Channel.load(CHANNEL_ADDRESS);

            assert.stringEquals(channel!.creatorLogic!, updatedLogicConfig!.id);

            assert.bytesEquals(updatedLogicConfig!.logicContract, Address.fromHexString(ZERO_ADDRESS));
            assert.bytesEquals(updatedLogicConfig!.updatedBy, Address.fromString(ADMIN_ADDRESS));

            const updatedDynamicLogic = DynamicLogic.load(CHANNEL_ADDRESS + "-creator");

            /// dynamic logic entity should be deleted
            assert.assertNull(updatedDynamicLogic);

            /// dynamic logiclink should be removed from logic config
            assert.assertNull(updatedLogicConfig!.dynamicLogic);
        });


    });

    describe("handle approve logic signature event", () => {
        test("properly handles signature approval", () => {
            const signatureApprovedData = new SignatureApprovedData();
            signatureApprovedData.signature = Bytes.fromHexString("0x12345678");
            signatureApprovedData.calldataAddressPosition = BigInt.fromI32(0);

            signatureApprovedData.eventBlockNumber = BigInt.fromI32(123456);
            signatureApprovedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            signatureApprovedData.txHash = Bytes.fromHexString("0x1234");
            signatureApprovedData.logIndex = BigInt.fromI32(0);
            signatureApprovedData.address = Address.fromString(LOGIC_CONTRACT_ADDRESS);

            const event = createSignatureApprovedData(signatureApprovedData);

            handleSignatureApproved(event);

            const approvedSignature = ApprovedDynamicLogicSignature.load(event.transaction.hash.toHexString() + '-' + event.logIndex.toString());

            assert.bytesEquals(approvedSignature!.signature, signatureApprovedData.signature);
            assert.bigIntEquals(approvedSignature!.calldataAddressOffset, BigInt.fromI32(0));
        });
    });


    describe("handle token events", () => {
        beforeEach(() => {
            const tokenCreatedData = new TokenCreatedData();
            tokenCreatedData.tokenId = BigInt.fromI32(0);
            tokenCreatedData.author = Address.fromString(CREATOR_ADDRESS);
            tokenCreatedData.sponsor = Address.fromString(SPONSOR_ADDRESS);
            tokenCreatedData.uri = "sample uri";
            tokenCreatedData.maxSupply = BigInt.fromI32(100);
            tokenCreatedData.totalMinted = BigInt.fromI32(0);

            tokenCreatedData.eventBlockNumber = BigInt.fromI32(123456);
            tokenCreatedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            tokenCreatedData.txHash = Bytes.fromHexString("0x1234");
            tokenCreatedData.logIndex = BigInt.fromI32(0);
            tokenCreatedData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createTokenCreatedData(tokenCreatedData);

            handleTokenCreated(event);
        });

        test("properly creates token", () => {

            const token = Token.load(CHANNEL_ADDRESS + '-0');
            const author = User.load(CREATOR_ADDRESS);
            const sponsor = User.load(SPONSOR_ADDRESS);
            const channel = Channel.load(CHANNEL_ADDRESS);

            assert.stringEquals(token!.uri, "sample uri");
            assert.bigIntEquals(token!.tokenId, BigInt.fromI32(0));
            assert.bigIntEquals(token!.maxSupply, BigInt.fromI32(100));
            assert.bigIntEquals(token!.totalMinted, BigInt.fromI32(0));

            assert.stringEquals(token!.channel, CHANNEL_ADDRESS);

            assert.stringEquals(token!.author, CREATOR_ADDRESS);
            assert.stringEquals(token!.sponsor, SPONSOR_ADDRESS);

            assert.stringEquals(author!.id, CREATOR_ADDRESS);
            assert.stringEquals(sponsor!.id, SPONSOR_ADDRESS);

            assert.bigIntEquals(token!.blockTimestamp, BigInt.fromI32(1620012345));

        });

        test("properly mints token", () => {
            const tokenMintedData = new TokenMintedData();
            tokenMintedData.minter = Address.fromString(MINTER_ADDRESS);
            tokenMintedData.mintReferral = Address.fromString(REFERRAL_ADDRESS);
            tokenMintedData.amounts = [BigInt.fromI32(1)];
            tokenMintedData.tokenIds = [BigInt.fromI32(0)];
            tokenMintedData.data = Bytes.fromHexString("0x00");

            tokenMintedData.eventBlockNumber = BigInt.fromI32(123456);
            tokenMintedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
            tokenMintedData.txHash = Bytes.fromHexString("0x1234");
            tokenMintedData.logIndex = BigInt.fromI32(0);
            tokenMintedData.address = Address.fromString(CHANNEL_ADDRESS);

            const event = createTokenMintedData(tokenMintedData);

            handleTokenBatchMinted(event);

            /// token entity validation
            const token = Token.load(CHANNEL_ADDRESS + '-0');
            assert.bigIntEquals(token!.totalMinted, BigInt.fromI32(1));

            /// mint entity validation
            const mint = Mint.load(tokenMintedData.txHash.toHexString() + '-0');
            assert.stringEquals(mint!.token, CHANNEL_ADDRESS + '-0');
            assert.bigIntEquals(mint!.amount, BigInt.fromI32(1));
            assert.bytesEquals(mint!.data, Bytes.fromHexString("0x00"));
            assert.stringEquals(mint!.minter, MINTER_ADDRESS);
            assert.bigIntEquals(mint!.blockTimestamp, tokenMintedData.eventBlockTimestamp);

            /// user validation
            const minter = User.load(MINTER_ADDRESS);
            assert.stringEquals(minter!.id, MINTER_ADDRESS);

        })
    });


    describe("handle single token transfer events", () => {

        beforeEach(() => {
            /// create a sample token 

            const token = new Token(CHANNEL_ADDRESS + '-0');
            token.uri = 'sample uri';
            token.tokenId = BigInt.fromI32(0);
            token.author = CREATOR_ADDRESS;
            token.sponsor = SPONSOR_ADDRESS;
            token.maxSupply = BigInt.fromI32(100);
            token.totalMinted = BigInt.fromI32(0);
            token.channel = CHANNEL_ADDRESS;
            token.blockTimestamp = BigInt.fromI32(1620012345);
            token.blockNumber = BigInt.fromI32(123456);

            token.save();

            /// create an initial token holder

            let from = Address.fromString(ZERO_ADDRESS);
            let to = Address.fromString(MINTER_ADDRESS);
            let id = BigInt.fromI32(0);
            let value = BigInt.fromI32(1);

            simulateSingleTokenTransferEvent(from, to, id, value);

        });

        test("properly handles single eth transfer from address 0 (mint)", () => {

            const updatedTokenHolder = TokenHolder.load(MINTER_ADDRESS + '-' + CHANNEL_ADDRESS + '-0');

            assert.bigIntEquals(updatedTokenHolder!.balance, BigInt.fromI32(1));
            assert.stringEquals(updatedTokenHolder!.user, MINTER_ADDRESS);
        });

        test("properly handles single eth transfer and removes holder on full token balance transfer", () => {

            let from = Address.fromString(MINTER_ADDRESS);
            let to = Address.fromString(ZERO_ADDRESS);
            let id = BigInt.fromI32(0);
            let value = BigInt.fromI32(1);

            simulateSingleTokenTransferEvent(from, to, id, value);

            const fromTokenHolder = TokenHolder.load(from.toHexString() + '-' + CHANNEL_ADDRESS + '-' + id.toString());
            const toTokenHolder = TokenHolder.load(to.toHexString() + '-' + CHANNEL_ADDRESS + '-' + id.toString());

            assert.assertNull(fromTokenHolder);
            assert.bigIntEquals(toTokenHolder!.balance, BigInt.fromI32(1));
        });

        test("properly handles single eth transfer and leaves holder intact on partial token balance transfer", () => {

            let from = Address.fromString(MINTER_ADDRESS);
            let to = Address.fromString(ZERO_ADDRESS);
            let id = BigInt.fromI32(0);
            let value = BigInt.fromI32(9);

            simulateSingleTokenTransferEvent(from, to, id, value);

            const fromTokenHolder = TokenHolder.load(from.toHexString() + '-' + CHANNEL_ADDRESS + '-' + id.toString());
            const toTokenHolder = TokenHolder.load(to.toHexString() + '-' + CHANNEL_ADDRESS + '-' + id.toString());

            assert.bigIntEquals(fromTokenHolder!.balance, BigInt.fromI32(1));
            assert.bigIntEquals(toTokenHolder!.balance, BigInt.fromI32(9));
        });

    });

    describe("handle batch token transfer events", () => {

        beforeEach(() => {

            /// create some sample tokens

            const token1 = new Token(CHANNEL_ADDRESS + '-0');
            token1.uri = 'sample uri';
            token1.tokenId = BigInt.fromI32(0);
            token1.author = CREATOR_ADDRESS;
            token1.sponsor = SPONSOR_ADDRESS;
            token1.maxSupply = BigInt.fromI32(100);
            token1.totalMinted = BigInt.fromI32(0);
            token1.channel = CHANNEL_ADDRESS;
            token1.blockTimestamp = BigInt.fromI32(1620012345);
            token1.blockNumber = BigInt.fromI32(123456);

            token1.save();

            const token2 = new Token(CHANNEL_ADDRESS + '-1');
            token2.uri = 'sample uri';
            token2.tokenId = BigInt.fromI32(1);
            token2.author = CREATOR_ADDRESS;
            token2.sponsor = SPONSOR_ADDRESS;
            token2.maxSupply = BigInt.fromI32(100);
            token2.totalMinted = BigInt.fromI32(0);
            token2.channel = CHANNEL_ADDRESS;
            token2.blockTimestamp = BigInt.fromI32(1620012345);
            token2.blockNumber = BigInt.fromI32(123456);

            token2.save();

            /// simulate an initial token holder event

            let from = Address.fromString(ZERO_ADDRESS);
            let to = Address.fromString(MINTER_ADDRESS);
            let ids = [BigInt.fromI32(0), BigInt.fromI32(1)];
            let values = [BigInt.fromI32(1), BigInt.fromI32(1)];

            simulateBatchTokenTransferEvent(from, to, ids, values);

        });

        test("properly handles batch eth transfer from address 0 (mint)", () => {

            const updatedToken_1Holder = TokenHolder.load(MINTER_ADDRESS + '-' + CHANNEL_ADDRESS + '-0');
            const updatedToken_2Holder = TokenHolder.load(MINTER_ADDRESS + '-' + CHANNEL_ADDRESS + '-1');

            assert.bigIntEquals(updatedToken_1Holder!.balance, BigInt.fromI32(1));
            assert.bigIntEquals(updatedToken_2Holder!.balance, BigInt.fromI32(1));
            assert.stringEquals(updatedToken_1Holder!.user, MINTER_ADDRESS);
            assert.stringEquals(updatedToken_2Holder!.user, MINTER_ADDRESS);
        });

        test("properly handles batch eth transfer and removes holder on full token balance transfer", () => {

            let from = Address.fromString(MINTER_ADDRESS);
            let to = Address.fromString(ZERO_ADDRESS);
            let ids = [BigInt.fromI32(0), BigInt.fromI32(1)];
            let values = [BigInt.fromI32(1), BigInt.fromI32(1)];

            simulateBatchTokenTransferEvent(from, to, ids, values);

            const fromToken_1Holder = TokenHolder.load(from.toHexString() + '-' + CHANNEL_ADDRESS + '-0');
            const toToken_1Holder = TokenHolder.load(to.toHexString() + '-' + CHANNEL_ADDRESS + '-0');

            const fromToken_2Holder = TokenHolder.load(from.toHexString() + '-' + CHANNEL_ADDRESS + '-1');
            const toToken_2Holder = TokenHolder.load(to.toHexString() + '-' + CHANNEL_ADDRESS + '-1');

            assert.assertNull(fromToken_1Holder);
            assert.bigIntEquals(toToken_1Holder!.balance, BigInt.fromI32(1));

            assert.assertNull(fromToken_2Holder);
            assert.bigIntEquals(toToken_2Holder!.balance, BigInt.fromI32(1));
        });

        test("properly handles batch eth transfer and leaves holder intact on partial token balance transfer", () => {

            let from = Address.fromString(MINTER_ADDRESS);
            let to = Address.fromString(ZERO_ADDRESS);
            let ids = [BigInt.fromI32(0), BigInt.fromI32(1)];
            let values = [BigInt.fromI32(9), BigInt.fromI32(9)];

            simulateBatchTokenTransferEvent(from, to, ids, values);

            const fromToken_1Holder = TokenHolder.load(from.toHexString() + '-' + CHANNEL_ADDRESS + '-0');
            const toToken_1Holder = TokenHolder.load(to.toHexString() + '-' + CHANNEL_ADDRESS + '-0');

            const fromToken_2Holder = TokenHolder.load(from.toHexString() + '-' + CHANNEL_ADDRESS + '-1');
            const toToken_2Holder = TokenHolder.load(to.toHexString() + '-' + CHANNEL_ADDRESS + '-1');

            assert.bigIntEquals(fromToken_1Holder!.balance, BigInt.fromI32(1));
            assert.bigIntEquals(toToken_1Holder!.balance, BigInt.fromI32(9));

            assert.bigIntEquals(fromToken_2Holder!.balance, BigInt.fromI32(1));
            assert.bigIntEquals(toToken_2Holder!.balance, BigInt.fromI32(9));
        });

    });

});


function simulateSingleTokenTransferEvent(from: Address, to: Address, id: BigInt, value: BigInt): void {
    const tokenTransferredData = new SingleTokenTransferredData();
    tokenTransferredData.from = from;
    tokenTransferredData.to = to;
    tokenTransferredData.id = id;
    tokenTransferredData.value = value;

    tokenTransferredData.eventBlockNumber = BigInt.fromI32(123456);
    tokenTransferredData.eventBlockTimestamp = BigInt.fromI32(1620012345);
    tokenTransferredData.txHash = Bytes.fromHexString("0x1234");
    tokenTransferredData.logIndex = BigInt.fromI32(0);
    tokenTransferredData.address = Address.fromString(CHANNEL_ADDRESS);

    const event = createSingleTokenTransferredData(tokenTransferredData);

    handleTransferSingleToken(event);
}

function simulateBatchTokenTransferEvent(from: Address, to: Address, ids: Array<BigInt>, values: Array<BigInt>): void {
    const tokenTransferredData = new BatchTokenTransferredData();
    tokenTransferredData.from = from;
    tokenTransferredData.to = to;
    tokenTransferredData.ids = ids;
    tokenTransferredData.values = values;

    tokenTransferredData.eventBlockNumber = BigInt.fromI32(123456);
    tokenTransferredData.eventBlockTimestamp = BigInt.fromI32(1620012345);
    tokenTransferredData.txHash = Bytes.fromHexString("0x1234");
    tokenTransferredData.logIndex = BigInt.fromI32(0);
    tokenTransferredData.address = Address.fromString(CHANNEL_ADDRESS);

    const event = createBatchTokenTransferredData(tokenTransferredData);

    handleTransferBatchToken(event);

}

function simulateConfigUpdateEvent(updateType: BigInt, feeContract: Address, logicContract: Address): void {
    const configUpdatedData = new ConfigUpdatedData();
    configUpdatedData.updateType = updateType;
    configUpdatedData.updater = Address.fromString(ADMIN_ADDRESS);
    configUpdatedData.feeContract = feeContract;
    configUpdatedData.logicContract = logicContract;
    configUpdatedData.eventBlockNumber = BigInt.fromI32(123456);
    configUpdatedData.eventBlockTimestamp = BigInt.fromI32(1620012345);
    configUpdatedData.txHash = Bytes.fromHexString("0x1234");
    configUpdatedData.logIndex = BigInt.fromI32(0);
    configUpdatedData.address = Address.fromString(CHANNEL_ADDRESS);

    const event = createConfigUpdatedData(configUpdatedData);

    handleUpdateConfig(event);
}