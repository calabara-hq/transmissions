import {
    Channel as ChannelTemplate,
    Rewards as RewardsTemplate,
    InfiniteChannel as InfiniteChannelTemplate,
    FiniteChannel as FiniteChannelTemplate
} from "../generated/templates";

import { SetupNewContract } from "../generated/ChannelFactoryV1/ChannelFactory";
import {
    getOrCreateChannel,
    getOrCreateTransportLayer,
    getOrCreateUser
} from "../utils/helpers";


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
        transportLayer.blockNumber = event.block.number;
        transportLayer.blockTimestamp = event.block.timestamp;
        InfiniteChannelTemplate.create(event.params.contractAddress);

    } else {

        transportLayer.type = 'finite';
        transportLayer.blockNumber = event.block.number;
        transportLayer.blockTimestamp = event.block.timestamp;
        FiniteChannelTemplate.create(event.params.contractAddress);

    }

    transportLayer.save();

    channel.blockNumber = event.block.number;
    channel.blockTimestamp = event.block.timestamp;
    channel.transportLayer = transportLayer.id;

    channel.save();

    ChannelTemplate.create(event.params.contractAddress);
    RewardsTemplate.create(event.params.contractAddress);
}
