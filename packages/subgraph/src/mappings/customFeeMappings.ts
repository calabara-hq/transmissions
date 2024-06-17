import { FeeConfigSet } from "../generated/CustomFeesV1/CustomFees"
import { getOrCreateCustomFees } from '../utils/helpers';
import { Bytes, BigInt, log } from '@graphprotocol/graph-ts';

export function handleUpdateCustomFees(event: FeeConfigSet): void {
    let channelId = event.params.channel.toHexString();
    let customFees = getOrCreateCustomFees(channelId);

    let fees = event.params.feeconfig;

    customFees.channelTreasury = Bytes.fromHexString(fees.channelTreasury.toHexString());
    customFees.uplinkBps = BigInt.fromI32(fees.uplinkBps);
    customFees.channelBps = BigInt.fromI32(fees.channelBps);
    customFees.creatorBps = BigInt.fromI32(fees.creatorBps);
    customFees.mintReferralBps = BigInt.fromI32(fees.mintReferralBps);
    customFees.sponsorBps = BigInt.fromI32(fees.sponsorBps);
    customFees.ethMintPrice = fees.ethMintPrice;
    customFees.erc20MintPrice = fees.erc20MintPrice;
    customFees.erc20Contract = Bytes.fromHexString(fees.erc20Contract.toHexString());

    customFees.save();

}