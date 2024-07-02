import { getOrCreateFiniteTransportConfig, getOrCreateTransportLayer } from "../../../utils/helpers";
import { FiniteTransportConfigSet, Settled } from "../../../generated/templates/FiniteChannel/FiniteChannel";
import { Address } from "@graphprotocol/graph-ts";
import { BIGINT_ZERO, ZERO_ADDRESS } from "../../../utils/constants";

export function handleFiniteChannelSettled(event: Settled): void {
    let finiteTransportConfig = getOrCreateFiniteTransportConfig(event.address.toHexString());
    finiteTransportConfig.settled = true;
    finiteTransportConfig.settledBy = event.params.caller;
    finiteTransportConfig.settledAt = event.block.timestamp;
    finiteTransportConfig.save();
}

export function handleFiniteTransportConfigSet(event: FiniteTransportConfigSet): void {
    let finiteTransportConfig = getOrCreateFiniteTransportConfig(event.address.toHexString());
    let transportLayer = getOrCreateTransportLayer(event.address.toHexString());

    finiteTransportConfig.createStart = event.params.createStart;
    finiteTransportConfig.mintStart = event.params.mintStart;
    finiteTransportConfig.mintEnd = event.params.mintEnd;
    finiteTransportConfig.ranks = event.params.ranks;
    finiteTransportConfig.allocations = event.params.allocations;
    finiteTransportConfig.totalAllocation = event.params.totalAllocation;
    finiteTransportConfig.token = event.params.token;

    finiteTransportConfig.settled = false;
    finiteTransportConfig.settledBy = Address.fromString(ZERO_ADDRESS);
    finiteTransportConfig.settledAt = BIGINT_ZERO;

    finiteTransportConfig.save();

    transportLayer.finiteTransportConfig = finiteTransportConfig.id;
    transportLayer.type = 'finite';
    transportLayer.blockNumber = event.block.number;
    transportLayer.blockTimestamp = event.block.timestamp;


    transportLayer.save();


}