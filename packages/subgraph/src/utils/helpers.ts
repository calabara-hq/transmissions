import { Address, BigInt, store } from "@graphprotocol/graph-ts";
import {
    Channel,
    TransportLayer,
    FiniteTransportConfig,
    InfiniteTransportConfig,
    CustomFees,
    FeeConfig,
    LogicConfig,
    DynamicLogic,
    Token,
    User,
    Mint,
    RewardTransferEvent,
    TokenHolder,
    ApprovedDynamicLogicSignature,
    ChannelUpgradeRegisteredEvent
} from "../generated/schema";
import { BIGINT_ZERO, ZERO_ADDRESS } from "./constants";
import { ConfigUpdated } from "../generated/templates/Channel/Channel";


export function updateFeeConfig(channelId: string, event: ConfigUpdated): string {
    let feeConfig = getOrCreateFeeConfig(channelId);

    feeConfig.feeContract = event.params.feeContract;
    feeConfig.updatedBy = event.params.updater;
    feeConfig.blockNumber = event.block.number;
    feeConfig.blockTimestamp = event.block.timestamp;

    if (event.params.feeContract == Address.fromHexString(ZERO_ADDRESS)) {
        feeConfig.customFees = null;
        feeConfig.type = "";
        store.remove('CustomFees', channelId);
    } else {
        let customFees = getOrCreateCustomFees(channelId);
        feeConfig.type = "customFees";
        feeConfig.customFees = customFees.id;
    }

    feeConfig.save();
    return feeConfig.id;
}

export class UpdatedInteractionLogic {
    creatorLogic: string | null;
    minterLogic: string | null;
}

export function updateLogicConfig(channelId: string, event: ConfigUpdated): UpdatedInteractionLogic {
    let creatorLogicConfig = getOrCreateLogicConfig(channelId + '-creator');
    let minterLogicConfig = getOrCreateLogicConfig(channelId + '-minter');

    creatorLogicConfig.logicContract = event.params.logicContract;
    creatorLogicConfig.updatedBy = event.params.updater;
    creatorLogicConfig.blockNumber = event.block.number;
    creatorLogicConfig.blockTimestamp = event.block.timestamp;

    minterLogicConfig.logicContract = event.params.logicContract;
    minterLogicConfig.updatedBy = event.params.updater;
    minterLogicConfig.blockNumber = event.block.number;
    minterLogicConfig.blockTimestamp = event.block.timestamp;


    if (event.params.logicContract == Address.fromHexString(ZERO_ADDRESS)) {
        creatorLogicConfig.dynamicLogic = null;
        store.remove('DynamicLogic', channelId + '-creator');
        creatorLogicConfig.type = "";

        minterLogicConfig.dynamicLogic = null;
        store.remove('DynamicLogic', channelId + '-minter');
        minterLogicConfig.type = "";
    } else {
        let creatorLogic = getOrCreateDynamicLogic(channelId + '-creator');
        let minterLogic = getOrCreateDynamicLogic(channelId + '-minter');

        creatorLogicConfig.type = "dynamicLogic";
        creatorLogicConfig.dynamicLogic = creatorLogic.id;

        minterLogicConfig.type = "dynamicLogic";
        minterLogicConfig.dynamicLogic = minterLogic.id;
    }

    creatorLogicConfig.save();
    minterLogicConfig.save();

    return { creatorLogic: creatorLogicConfig.id, minterLogic: minterLogicConfig.id } as UpdatedInteractionLogic;
}

export function handleUpdateTokenHolders(
    channelId: string,
    from: string,
    to: string,
    id: string,
    value: BigInt
): void {

    let newTokenHolder = getOrCreateTokenHolder(to + '-' + channelId + '-' + id);
    let newHolderUser = getOrCreateUser(to);
    let token = getOrCreateToken(channelId + '-' + id);

    newTokenHolder.user = newHolderUser.id;
    newTokenHolder.token = token.id;



    // Partial balance transfer from old token holder
    let oldTokenHolder = TokenHolder.load(from + '-' + channelId + '-' + id);

    if (oldTokenHolder) {
        oldTokenHolder.balance = oldTokenHolder.balance.minus(value);
        if (oldTokenHolder.balance == BIGINT_ZERO) {
            store.remove('TokenHolder', oldTokenHolder.id);
        }
    }

    newTokenHolder.balance = newTokenHolder.balance.plus(value);

    newHolderUser.save();
    newTokenHolder.save();

}



export function getOrCreateChannel(id: string, createIfNotFound: boolean = true, save: boolean = false): Channel {
    let channel = Channel.load(id);

    if (channel == null && createIfNotFound) {
        channel = new Channel(id);
        if (save) {
            channel.save();
        }
    }

    return channel as Channel;
}

export function getOrCreateTransportLayer(id: string, createIfNotFound: boolean = true, save: boolean = false): TransportLayer {
    let transportLayer = TransportLayer.load(id);

    if (transportLayer == null && createIfNotFound) {
        transportLayer = new TransportLayer(id);
        if (save) {
            transportLayer.save();
        }
    }

    return transportLayer as TransportLayer;
}


export function getOrCreateFiniteTransportConfig(id: string, createIfNotFound: boolean = true, save: boolean = false): FiniteTransportConfig {
    let finiteConfig = FiniteTransportConfig.load(id);

    if (finiteConfig == null && createIfNotFound) {
        finiteConfig = new FiniteTransportConfig(id);
        if (save) {
            finiteConfig.save();
        }
    }

    return finiteConfig as FiniteTransportConfig;
}


export function getOrCreateInfiniteTransportConfig(id: string, createIfNotFound: boolean = true, save: boolean = false): InfiniteTransportConfig {
    let infiniteConfig = InfiniteTransportConfig.load(id);

    if (infiniteConfig == null && createIfNotFound) {
        infiniteConfig = new InfiniteTransportConfig(id);
        if (save) {
            infiniteConfig.save();
        }
    }

    return infiniteConfig as InfiniteTransportConfig;

}

export function getOrCreateFeeConfig(id: string, createIfNotFound: boolean = true, save: boolean = false): FeeConfig {
    let feeConfig = FeeConfig.load(id);

    if (feeConfig == null && createIfNotFound) {
        feeConfig = new FeeConfig(id);

        if (save) {
            feeConfig.save();
        }
    }

    return feeConfig as FeeConfig;
}


export function getOrCreateCustomFees(id: string, createIfNotFound: boolean = true, save: boolean = false): CustomFees {
    let customFees = CustomFees.load(id);

    if (customFees == null && createIfNotFound) {
        customFees = new CustomFees(id);

        if (save) {
            customFees.save();
        }
    }

    return customFees as CustomFees;
}


export function getOrCreateLogicConfig(id: string, createIfNotFound: boolean = true, save: boolean = false): LogicConfig {
    let logicConfig = LogicConfig.load(id);

    if (logicConfig == null && createIfNotFound) {
        logicConfig = new LogicConfig(id);

        if (save) {
            logicConfig.save();
        }
    }

    return logicConfig as LogicConfig;

}


export function getOrCreateDynamicLogic(id: string, createIfNotFound: boolean = true, save: boolean = false): DynamicLogic {
    let dynamicLogic = DynamicLogic.load(id);

    if (dynamicLogic == null && createIfNotFound) {
        dynamicLogic = new DynamicLogic(id);

        if (save) {
            dynamicLogic.save();
        }
    }

    return dynamicLogic as DynamicLogic;
}


export function getOrCreateToken(id: string, createIfNotFound: boolean = true, save: boolean = false): Token {
    let token = Token.load(id);

    if (token == null && createIfNotFound) {
        token = new Token(id);

        if (save) {
            token.save();
        }
    }

    return token as Token;
}

export function getOrCreateMint(id: string, createIfNotFound: boolean = true, save: boolean = false): Mint {
    let mint = Mint.load(id);

    if (mint == null && createIfNotFound) {
        mint = new Mint(id);

        if (save) {
            mint.save();
        }
    }

    return mint as Mint;
}


export function getOrCreateUser(id: string, createIfNotFound: boolean = true, save: boolean = false): User {
    let user = User.load(id);

    if (user == null && createIfNotFound) {
        user = new User(id);

        if (save) {
            user.save();
        }
    }

    return user as User;
}

export function getOrCreateRewardTransferEvent(id: string, createIfNotFound: boolean = true, save: boolean = false): RewardTransferEvent {
    let transferEvent = RewardTransferEvent.load(id);

    if (transferEvent == null && createIfNotFound) {
        transferEvent = new RewardTransferEvent(id);

        if (save) {
            transferEvent.save();
        }
    }

    return transferEvent as RewardTransferEvent;
}


export function getOrCreateTokenHolder(id: string, createIfNotFound: boolean = true, save: boolean = false): TokenHolder {
    let tokenHolder = TokenHolder.load(id);

    if (tokenHolder == null && createIfNotFound) {
        tokenHolder = new TokenHolder(id);
        tokenHolder.user = "";
        tokenHolder.token = "";
        tokenHolder.balance = BigInt.fromI32(0);


        if (save) {
            tokenHolder.save();
        }
    }

    return tokenHolder as TokenHolder;
}

export function getOrCreateApprovedSignature(id: string, createIfNotFound: boolean = true, save: boolean = false): ApprovedDynamicLogicSignature {
    let approvedSignature = ApprovedDynamicLogicSignature.load(id);

    if (approvedSignature == null && createIfNotFound) {
        approvedSignature = new ApprovedDynamicLogicSignature(id);

        if (save) {
            approvedSignature.save();
        }
    }

    return approvedSignature as ApprovedDynamicLogicSignature;
}

export function getOrCreateUpgrade(id: string, createIfNotFound: boolean = true, save: boolean = false): ChannelUpgradeRegisteredEvent {
    let upgrade = ChannelUpgradeRegisteredEvent.load(id);

    if (upgrade == null && createIfNotFound) {
        upgrade = new ChannelUpgradeRegisteredEvent(id);

        if (save) {
            upgrade.save();
        }
    }

    return upgrade as ChannelUpgradeRegisteredEvent;
}
