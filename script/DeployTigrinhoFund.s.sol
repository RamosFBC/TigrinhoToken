// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {TigrinhoFund} from "../src/TigrinhoFund.sol";

contract DeployTigrinhoFund is Script {

    function run() external returns (TigrinhoFund) {
        vm.startBroadcast();
        TigrinhoFund tigrinhoFund = new TigrinhoFund();
        vm.stopBroadcast();
        return tigrinhoFund;
    }
}