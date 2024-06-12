import { Channel as ChannelTemplate } from "../generated/templates";
import { ethereum } from '@graphprotocol/graph-ts';
import { SetupNewContract } from "../generated/ChannelFactoryV1/ChannelFactory";
import {
    getOrCreateChannel,
    getOrCreateFiniteTransportConfig,
    getOrCreateInfiniteTransportConfig,
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
        let decoded = ethereum.decode('(uint80,uint80,uint80,(uint40[],uint256[],uint256,address))', event.params.transportConfig);


        let tuple = decoded!.toTuple();
        let rewardsTuple = tuple[3].toTuple();

        finiteTransportConfig.createStart = tuple[0].toBigInt();
        finiteTransportConfig.mintStart = tuple[1].toBigInt();
        finiteTransportConfig.mintEnd = tuple[2].toBigInt();
        finiteTransportConfig.ranks = rewardsTuple[0].toBigIntArray();
        finiteTransportConfig.allocations = rewardsTuple[1].toBigIntArray();
        finiteTransportConfig.totalAllocation = rewardsTuple[2].toBigInt();
        finiteTransportConfig.token = rewardsTuple[3].toAddress();

        finiteTransportConfig.save();

        transportLayer.finiteTransportConfig = finiteTransportConfig.id;
    }

    channel.transportLayer = transportLayer.id;

    transportLayer.save();
    channel.save();

    ChannelTemplate.create(event.params.contractAddress);
}
