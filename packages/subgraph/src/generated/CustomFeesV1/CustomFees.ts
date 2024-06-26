// THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.

import {
  ethereum,
  JSONValue,
  TypedMap,
  Entity,
  Bytes,
  Address,
  BigInt,
} from "@graphprotocol/graph-ts";

export class FeeConfigSet extends ethereum.Event {
  get params(): FeeConfigSet__Params {
    return new FeeConfigSet__Params(this);
  }
}

export class FeeConfigSet__Params {
  _event: FeeConfigSet;

  constructor(event: FeeConfigSet) {
    this._event = event;
  }

  get channel(): Address {
    return this._event.parameters[0].value.toAddress();
  }

  get feeconfig(): FeeConfigSetFeeconfigStruct {
    return changetype<FeeConfigSetFeeconfigStruct>(
      this._event.parameters[1].value.toTuple(),
    );
  }
}

export class FeeConfigSetFeeconfigStruct extends ethereum.Tuple {
  get channelTreasury(): Address {
    return this[0].toAddress();
  }

  get uplinkBps(): i32 {
    return this[1].toI32();
  }

  get channelBps(): i32 {
    return this[2].toI32();
  }

  get creatorBps(): i32 {
    return this[3].toI32();
  }

  get mintReferralBps(): i32 {
    return this[4].toI32();
  }

  get sponsorBps(): i32 {
    return this[5].toI32();
  }

  get ethMintPrice(): BigInt {
    return this[6].toBigInt();
  }

  get erc20MintPrice(): BigInt {
    return this[7].toBigInt();
  }

  get erc20Contract(): Address {
    return this[8].toAddress();
  }
}

export class CustomFees__channelFeesResult {
  value0: Address;
  value1: i32;
  value2: i32;
  value3: i32;
  value4: i32;
  value5: i32;
  value6: BigInt;
  value7: BigInt;
  value8: Address;

  constructor(
    value0: Address,
    value1: i32,
    value2: i32,
    value3: i32,
    value4: i32,
    value5: i32,
    value6: BigInt,
    value7: BigInt,
    value8: Address,
  ) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
    this.value3 = value3;
    this.value4 = value4;
    this.value5 = value5;
    this.value6 = value6;
    this.value7 = value7;
    this.value8 = value8;
  }

  toMap(): TypedMap<string, ethereum.Value> {
    let map = new TypedMap<string, ethereum.Value>();
    map.set("value0", ethereum.Value.fromAddress(this.value0));
    map.set(
      "value1",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value1)),
    );
    map.set(
      "value2",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value2)),
    );
    map.set(
      "value3",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value3)),
    );
    map.set(
      "value4",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value4)),
    );
    map.set(
      "value5",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value5)),
    );
    map.set("value6", ethereum.Value.fromUnsignedBigInt(this.value6));
    map.set("value7", ethereum.Value.fromUnsignedBigInt(this.value7));
    map.set("value8", ethereum.Value.fromAddress(this.value8));
    return map;
  }

  getChannelTreasury(): Address {
    return this.value0;
  }

  getUplinkBps(): i32 {
    return this.value1;
  }

  getChannelBps(): i32 {
    return this.value2;
  }

  getCreatorBps(): i32 {
    return this.value3;
  }

  getMintReferralBps(): i32 {
    return this.value4;
  }

  getSponsorBps(): i32 {
    return this.value5;
  }

  getEthMintPrice(): BigInt {
    return this.value6;
  }

  getErc20MintPrice(): BigInt {
    return this.value7;
  }

  getErc20Contract(): Address {
    return this.value8;
  }
}

export class CustomFees__getFeeBpsResult {
  value0: i32;
  value1: i32;
  value2: i32;
  value3: i32;
  value4: i32;

  constructor(value0: i32, value1: i32, value2: i32, value3: i32, value4: i32) {
    this.value0 = value0;
    this.value1 = value1;
    this.value2 = value2;
    this.value3 = value3;
    this.value4 = value4;
  }

  toMap(): TypedMap<string, ethereum.Value> {
    let map = new TypedMap<string, ethereum.Value>();
    map.set(
      "value0",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value0)),
    );
    map.set(
      "value1",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value1)),
    );
    map.set(
      "value2",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value2)),
    );
    map.set(
      "value3",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value3)),
    );
    map.set(
      "value4",
      ethereum.Value.fromUnsignedBigInt(BigInt.fromI32(this.value4)),
    );
    return map;
  }

  getValue0(): i32 {
    return this.value0;
  }

  getValue1(): i32 {
    return this.value1;
  }

  getValue2(): i32 {
    return this.value2;
  }

  getValue3(): i32 {
    return this.value3;
  }

  getValue4(): i32 {
    return this.value4;
  }
}

export class CustomFees__requestErc20MintResultValue0Struct extends ethereum.Tuple {
  get recipients(): Array<Address> {
    return this[0].toAddressArray();
  }

  get allocations(): Array<BigInt> {
    return this[1].toBigIntArray();
  }

  get totalAllocation(): BigInt {
    return this[2].toBigInt();
  }

  get token(): Address {
    return this[3].toAddress();
  }
}

export class CustomFees__requestEthMintResultValue0Struct extends ethereum.Tuple {
  get recipients(): Array<Address> {
    return this[0].toAddressArray();
  }

  get allocations(): Array<BigInt> {
    return this[1].toBigIntArray();
  }

  get totalAllocation(): BigInt {
    return this[2].toBigInt();
  }

  get token(): Address {
    return this[3].toAddress();
  }
}

export class CustomFees extends ethereum.SmartContract {
  static bind(address: Address): CustomFees {
    return new CustomFees("CustomFees", address);
  }

  channelFees(param0: Address): CustomFees__channelFeesResult {
    let result = super.call(
      "channelFees",
      "channelFees(address):(address,uint16,uint16,uint16,uint16,uint16,uint256,uint256,address)",
      [ethereum.Value.fromAddress(param0)],
    );

    return new CustomFees__channelFeesResult(
      result[0].toAddress(),
      result[1].toI32(),
      result[2].toI32(),
      result[3].toI32(),
      result[4].toI32(),
      result[5].toI32(),
      result[6].toBigInt(),
      result[7].toBigInt(),
      result[8].toAddress(),
    );
  }

  try_channelFees(
    param0: Address,
  ): ethereum.CallResult<CustomFees__channelFeesResult> {
    let result = super.tryCall(
      "channelFees",
      "channelFees(address):(address,uint16,uint16,uint16,uint16,uint16,uint256,uint256,address)",
      [ethereum.Value.fromAddress(param0)],
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(
      new CustomFees__channelFeesResult(
        value[0].toAddress(),
        value[1].toI32(),
        value[2].toI32(),
        value[3].toI32(),
        value[4].toI32(),
        value[5].toI32(),
        value[6].toBigInt(),
        value[7].toBigInt(),
        value[8].toAddress(),
      ),
    );
  }

  codeRepository(): string {
    let result = super.call("codeRepository", "codeRepository():(string)", []);

    return result[0].toString();
  }

  try_codeRepository(): ethereum.CallResult<string> {
    let result = super.tryCall(
      "codeRepository",
      "codeRepository():(string)",
      [],
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toString());
  }

  contractName(): string {
    let result = super.call("contractName", "contractName():(string)", []);

    return result[0].toString();
  }

  try_contractName(): ethereum.CallResult<string> {
    let result = super.tryCall("contractName", "contractName():(string)", []);
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toString());
  }

  contractVersion(): string {
    let result = super.call(
      "contractVersion",
      "contractVersion():(string)",
      [],
    );

    return result[0].toString();
  }

  try_contractVersion(): ethereum.CallResult<string> {
    let result = super.tryCall(
      "contractVersion",
      "contractVersion():(string)",
      [],
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toString());
  }

  getErc20MintPrice(): BigInt {
    let result = super.call(
      "getErc20MintPrice",
      "getErc20MintPrice():(uint256)",
      [],
    );

    return result[0].toBigInt();
  }

  try_getErc20MintPrice(): ethereum.CallResult<BigInt> {
    let result = super.tryCall(
      "getErc20MintPrice",
      "getErc20MintPrice():(uint256)",
      [],
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toBigInt());
  }

  getEthMintPrice(): BigInt {
    let result = super.call(
      "getEthMintPrice",
      "getEthMintPrice():(uint256)",
      [],
    );

    return result[0].toBigInt();
  }

  try_getEthMintPrice(): ethereum.CallResult<BigInt> {
    let result = super.tryCall(
      "getEthMintPrice",
      "getEthMintPrice():(uint256)",
      [],
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(value[0].toBigInt());
  }

  getFeeBps(): CustomFees__getFeeBpsResult {
    let result = super.call(
      "getFeeBps",
      "getFeeBps():(uint16,uint16,uint16,uint16,uint16)",
      [],
    );

    return new CustomFees__getFeeBpsResult(
      result[0].toI32(),
      result[1].toI32(),
      result[2].toI32(),
      result[3].toI32(),
      result[4].toI32(),
    );
  }

  try_getFeeBps(): ethereum.CallResult<CustomFees__getFeeBpsResult> {
    let result = super.tryCall(
      "getFeeBps",
      "getFeeBps():(uint16,uint16,uint16,uint16,uint16)",
      [],
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(
      new CustomFees__getFeeBpsResult(
        value[0].toI32(),
        value[1].toI32(),
        value[2].toI32(),
        value[3].toI32(),
        value[4].toI32(),
      ),
    );
  }

  requestErc20Mint(
    creators: Array<Address>,
    sponsors: Array<Address>,
    amounts: Array<BigInt>,
    mintReferral: Address,
  ): CustomFees__requestErc20MintResultValue0Struct {
    let result = super.call(
      "requestErc20Mint",
      "requestErc20Mint(address[],address[],uint256[],address):((address[],uint256[],uint256,address))",
      [
        ethereum.Value.fromAddressArray(creators),
        ethereum.Value.fromAddressArray(sponsors),
        ethereum.Value.fromUnsignedBigIntArray(amounts),
        ethereum.Value.fromAddress(mintReferral),
      ],
    );

    return changetype<CustomFees__requestErc20MintResultValue0Struct>(
      result[0].toTuple(),
    );
  }

  try_requestErc20Mint(
    creators: Array<Address>,
    sponsors: Array<Address>,
    amounts: Array<BigInt>,
    mintReferral: Address,
  ): ethereum.CallResult<CustomFees__requestErc20MintResultValue0Struct> {
    let result = super.tryCall(
      "requestErc20Mint",
      "requestErc20Mint(address[],address[],uint256[],address):((address[],uint256[],uint256,address))",
      [
        ethereum.Value.fromAddressArray(creators),
        ethereum.Value.fromAddressArray(sponsors),
        ethereum.Value.fromUnsignedBigIntArray(amounts),
        ethereum.Value.fromAddress(mintReferral),
      ],
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(
      changetype<CustomFees__requestErc20MintResultValue0Struct>(
        value[0].toTuple(),
      ),
    );
  }

  requestEthMint(
    creators: Array<Address>,
    sponsors: Array<Address>,
    amounts: Array<BigInt>,
    mintReferral: Address,
  ): CustomFees__requestEthMintResultValue0Struct {
    let result = super.call(
      "requestEthMint",
      "requestEthMint(address[],address[],uint256[],address):((address[],uint256[],uint256,address))",
      [
        ethereum.Value.fromAddressArray(creators),
        ethereum.Value.fromAddressArray(sponsors),
        ethereum.Value.fromUnsignedBigIntArray(amounts),
        ethereum.Value.fromAddress(mintReferral),
      ],
    );

    return changetype<CustomFees__requestEthMintResultValue0Struct>(
      result[0].toTuple(),
    );
  }

  try_requestEthMint(
    creators: Array<Address>,
    sponsors: Array<Address>,
    amounts: Array<BigInt>,
    mintReferral: Address,
  ): ethereum.CallResult<CustomFees__requestEthMintResultValue0Struct> {
    let result = super.tryCall(
      "requestEthMint",
      "requestEthMint(address[],address[],uint256[],address):((address[],uint256[],uint256,address))",
      [
        ethereum.Value.fromAddressArray(creators),
        ethereum.Value.fromAddressArray(sponsors),
        ethereum.Value.fromUnsignedBigIntArray(amounts),
        ethereum.Value.fromAddress(mintReferral),
      ],
    );
    if (result.reverted) {
      return new ethereum.CallResult();
    }
    let value = result.value;
    return ethereum.CallResult.fromValue(
      changetype<CustomFees__requestEthMintResultValue0Struct>(
        value[0].toTuple(),
      ),
    );
  }
}

export class ConstructorCall extends ethereum.Call {
  get inputs(): ConstructorCall__Inputs {
    return new ConstructorCall__Inputs(this);
  }

  get outputs(): ConstructorCall__Outputs {
    return new ConstructorCall__Outputs(this);
  }
}

export class ConstructorCall__Inputs {
  _call: ConstructorCall;

  constructor(call: ConstructorCall) {
    this._call = call;
  }

  get _uplinkRewardsAddress(): Address {
    return this._call.inputValues[0].value.toAddress();
  }
}

export class ConstructorCall__Outputs {
  _call: ConstructorCall;

  constructor(call: ConstructorCall) {
    this._call = call;
  }
}

export class SetChannelFeesCall extends ethereum.Call {
  get inputs(): SetChannelFeesCall__Inputs {
    return new SetChannelFeesCall__Inputs(this);
  }

  get outputs(): SetChannelFeesCall__Outputs {
    return new SetChannelFeesCall__Outputs(this);
  }
}

export class SetChannelFeesCall__Inputs {
  _call: SetChannelFeesCall;

  constructor(call: SetChannelFeesCall) {
    this._call = call;
  }

  get data(): Bytes {
    return this._call.inputValues[0].value.toBytes();
  }
}

export class SetChannelFeesCall__Outputs {
  _call: SetChannelFeesCall;

  constructor(call: SetChannelFeesCall) {
    this._call = call;
  }
}
