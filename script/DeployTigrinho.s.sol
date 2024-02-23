// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Tigrinho} from "../src/Tigrinho.sol";

contract DeployTigrinho is Script {
    uint256 public constant INITIAL_SUPPLY = 69 * 1e9 ether;

    function run() external returns (Tigrinho) {
        vm.startBroadcast();
        Tigrinho tigrinho = new Tigrinho(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return tigrinho;
    }
}