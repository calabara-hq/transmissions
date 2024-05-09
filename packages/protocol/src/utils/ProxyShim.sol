// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UUPSUpgradeable} from "openzeppelin-contracts/proxy/utils/UUPSUpgradeable.sol";

contract ProxyShim is UUPSUpgradeable {
    address immutable canUpgrade;

    constructor(address _canUpgrade) {
        canUpgrade = _canUpgrade;
    }

    function _authorizeUpgrade(address) internal view override {
        require(msg.sender == canUpgrade, "not authorized");
    }
}
