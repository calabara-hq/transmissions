import { getOrCreateInfiniteTransportConfig, getOrCreateTransportLayer } from "../../../utils/helpers";
import { InfiniteTransportConfigSet } from "../../../generated/templates/InfiniteChannel/InfiniteChannel";

export function handleInfiniteTransportConfigSet(event: InfiniteTransportConfigSet): void {
    let infiniteTransportConfig = getOrCreateInfiniteTransportConfig(event.address.toHexString());
    let transportLayer = getOrCreateTransportLayer(event.address.toHexString());

    infiniteTransportConfig.saleDuration = event.params.saleDuration;

    infiniteTransportConfig.save();

    transportLayer.infiniteTransportConfig = infiniteTransportConfig.id;
    transportLayer.type = 'finite';
    transportLayer.blockNumber = event.block.number;
    transportLayer.blockTimestamp = event.block.timestamp;

    transportLayer.save();

}