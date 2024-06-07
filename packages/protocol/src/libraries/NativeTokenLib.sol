// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library NativeTokenLib {
  address constant NATIVE_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

  function isNativeToken(address token) internal pure returns (bool) {
    return token == NATIVE_TOKEN;
  }
}
