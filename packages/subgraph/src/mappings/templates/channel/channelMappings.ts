import { Channel } from "../../../generated/schema";
import { Bytes, log, Address } from '@graphprotocol/graph-ts';
import { getOrCreateChannel } from "../../../utils/helpers";

import { ManagersUpdated } from "../../../generated/templates/Channel/Channel";

export function handleUpdateManagers(event: ManagersUpdated): void {
    let channel = getOrCreateChannel(event.address.toHexString());

    channel.managers = changetype<Bytes[]>(event.params.managers);

    channel.save();
}