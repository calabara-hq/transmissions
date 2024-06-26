import { Channel as ChannelTemplate } from "../generated/templates";
import { FiniteChannel as FiniteChannelTemplate } from "../generated/templates";
import { Address, ethereum } from '@graphprotocol/graph-ts';
import { SetupNewContract } from "../generated/ChannelFactoryV1/ChannelFactory";
import {
    getOrCreateChannel,
    getOrCreateFiniteTransportConfig,
    getOrCreateInfiniteTransportConfig,
    getOrCreateTransportLayer,
    getOrCreateUser
} from "../utils/helpers";
import { BIGINT_ZERO, ZERO_ADDRESS } from "../utils/constants";


export function handleChannelCreated(event: SetupNewContract): void {
    let channelId = event.params.contractAddress.toHex();
    let channel = getOrCreateChannel(channelId);
    let transportLayer = getOrCreateTransportLayer(channelId);

    let tempManagers: string[] = [];
    for (let i = 0; i < event.params.managers.length; i++) {
        let manager = getOrCreateUser(event.params.managers[i].toHex());
        tempManagers.push(manager.id);
        manager.save();
    }

    let admin = getOrCreateUser(event.params.defaultAdmin.toHex());
    admin.save();

    channel.uri = event.params.uri;
    channel.name = event.params.name;
    channel.managers = tempManagers;
    channel.admin = admin.id;


    if (event.params.transportConfig.length == 32) {

        transportLayer.type = 'infinite';
        let infiniteTransportConfig = getOrCreateInfiniteTransportConfig(channelId);

        /// decode the infinite transport layer
        let decoded = ethereum.decode('(uint40)', event.params.transportConfig);
        let tuple = decoded!.toTuple();

        infiniteTransportConfig.saleDuration = tuple[0].toBigInt();

        infiniteTransportConfig.save();

        transportLayer.infiniteTransportConfig = infiniteTransportConfig.id;

    } else {
        transportLayer.type = 'finite';
        let finiteTransportConfig = getOrCreateFiniteTransportConfig(channelId);

        /// decode the finite transport layer
        let decoded = ethereum.decode('(uint40,uint40,uint40,(uint40[],uint256[],uint256,address))', event.params.transportConfig);


        let tuple = decoded!.toTuple();
        let rewardsTuple = tuple[3].toTuple();

        finiteTransportConfig.createStart = tuple[0].toBigInt();
        finiteTransportConfig.mintStart = tuple[1].toBigInt();
        finiteTransportConfig.mintEnd = tuple[2].toBigInt();
        finiteTransportConfig.ranks = rewardsTuple[0].toBigIntArray();
        finiteTransportConfig.allocations = rewardsTuple[1].toBigIntArray();
        finiteTransportConfig.totalAllocation = rewardsTuple[2].toBigInt();
        finiteTransportConfig.token = rewardsTuple[3].toAddress();

        finiteTransportConfig.settled = false;
        finiteTransportConfig.settledBy = Address.fromString(ZERO_ADDRESS);
        finiteTransportConfig.settledAt = BIGINT_ZERO;

        finiteTransportConfig.save();

        transportLayer.finiteTransportConfig = finiteTransportConfig.id;

        FiniteChannelTemplate.create(event.params.contractAddress);

    }

    channel.transportLayer = transportLayer.id;

    transportLayer.save();
    channel.save();

    ChannelTemplate.create(event.params.contractAddress);
}
