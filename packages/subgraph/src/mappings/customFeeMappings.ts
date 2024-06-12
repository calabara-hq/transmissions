import { FeeConfigSet } from "../generated/CustomFeesV1/CustomFees"
import { getOrCreateCustomFees } from '../utils/helpers';
import { Bytes, BigInt, log } from '@graphprotocol/graph-ts';

export function handleUpdateCustomFees(event: FeeConfigSet): void {
    let channelId = event.params.channel.toHexString();
    let customFees = getOrCreateCustomFees(channelId);

    let feeConfig = event.params.feeconfig;

    customFees.channelTreasury = Bytes.fromHexString(feeConfig.channelTreasury.toHexString());
    customFees.uplinkBps = BigInt.fromI32(feeConfig.uplinkBps);
    customFees.channelBps = BigInt.fromI32(feeConfig.channelBps);
    customFees.creatorBps = BigInt.fromI32(feeConfig.creatorBps);
    customFees.mintReferralBps = BigInt.fromI32(feeConfig.mintReferralBps);
    customFees.sponsorBps = BigInt.fromI32(feeConfig.sponsorBps);
    customFees.ethMintPrice = feeConfig.ethMintPrice;
    customFees.erc20MintPrice = feeConfig.erc20MintPrice;
    customFees.erc20Contract = Bytes.fromHexString(feeConfig.erc20Contract.toHexString());

    customFees.save();

}