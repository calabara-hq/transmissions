import { Address, BigInt, Bytes, ethereum } from "@graphprotocol/graph-ts";
import { Channel, TransportLayer } from "../generated/schema";

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

