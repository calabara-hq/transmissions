import { UpgradeRegistered, UpgradeRemoved } from "../generated/UpgradePathV1/UpgradePath";
import { getOrCreateUpgrade } from "../utils/helpers";
import { store } from "@graphprotocol/graph-ts";

export function handleUpgradeRegistered(event: UpgradeRegistered): void {

    let baseImpl = event.params.baseImpl;
    let upgradeImpl = event.params.upgradeImpl;

    let id = baseImpl.toHexString() + "-" + upgradeImpl.toHexString();
    let upgrade = getOrCreateUpgrade(id);

    upgrade.baseImpl = event.params.baseImpl;
    upgrade.upgradeImpl = event.params.upgradeImpl;

    upgrade.blockNumber = event.block.number;
    upgrade.blockTimestamp = event.block.timestamp;

    upgrade.save();

}

export function handleUpgradeRemoved(event: UpgradeRemoved): void {

    let id = event.params.baseImpl.toHexString() + "-" + event.params.upgradeImpl.toHexString();
    store.remove('ChannelUpgradeRegisteredEvent', id);

}