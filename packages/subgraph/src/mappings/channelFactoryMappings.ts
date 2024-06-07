import { Channel, TransportLayer } from "../generated/schema";
import { Channel as ChannelTemplate } from "../generated/templates";
import { Bytes, log, Address, ethereum } from '@graphprotocol/graph-ts';
import { SetupNewContract } from "../generated/ChannelFactoryV1/ChannelFactory";
import { getOrCreateChannel, getOrCreateTransportLayer } from "../utils/helpers";

export function handleChannelCreated(event: SetupNewContract): void {
    let channelId = event.params.contractAddress.toHex();
    let channel = getOrCreateChannel(channelId);
    let transport = getOrCreateTransportLayer(event.params.contractAddress.toHex());


    channel.uri = event.params.uri;
    channel.admin = Bytes.fromHexString(event.params.defaultAdmin.toHex());
    channel.managers = changetype<Bytes[]>(event.params.managers);

    if (event.params.transportConfig.length == 32) {

        /// decode the infinite transport layer
        let decoded = ethereum.decode('(uint40)', event.params.transportConfig);
        let tuple = decoded!.toTuple();

        transport.type = 'infinite';
        transport.saleDuration = tuple[0].toBigInt();
    } else {
        /// decode the finite transport layer
        let decoded = ethereum.decode('(uint80,uint80,uint80,(uint40[],uint256[],uint256,address))', event.params.transportConfig);



        let tuple = decoded!.toTuple();
        let rewardsTuple = tuple[3].toTuple();

        transport.type = 'finite';
        transport.createStart = tuple[0].toBigInt();
        transport.mintStart = tuple[1].toBigInt();
        transport.mintEnd = tuple[2].toBigInt();
        transport.ranks = rewardsTuple[0].toBigIntArray();
        transport.allocations = rewardsTuple[1].toBigIntArray();
        transport.totalAllocation = rewardsTuple[2].toBigInt();
        transport.token = rewardsTuple[3].toAddress();
    }

    channel.transportLayer = transport.id;


    transport.save();
    channel.save();

    ChannelTemplate.create(event.params.contractAddress);
}
