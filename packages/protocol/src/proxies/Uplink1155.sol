// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/// @author nick

contract Uplink1155 is ERC1967Proxy {
    constructor(address _logic) ERC1967Proxy(_logic, "") {}
}
