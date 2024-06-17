import { getOrCreateFiniteTransportConfig } from "../../../utils/helpers";
import { Settled } from "../../../generated/templates/FiniteChannel/FiniteChannel";

export function handleFiniteChannelSettled(event: Settled): void {
    let finiteTransportConfig = getOrCreateFiniteTransportConfig(event.address.toHexString());
    finiteTransportConfig.settled = true;
    finiteTransportConfig.settledBy = event.params.caller;
    finiteTransportConfig.settledAt = event.block.timestamp;
    finiteTransportConfig.save();
}