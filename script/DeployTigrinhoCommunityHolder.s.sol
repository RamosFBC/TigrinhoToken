// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {TigrinhoCommunityHolder} from "../src/TigrinhoCommunityHolder.sol";

contract DeployTigrinhoCommunityHolder is Script {

    function run(address _tigrinhoAddress, address _tigrinhoFundAddress) external returns (TigrinhoCommunityHolder) {

        
        vm.startBroadcast();
        TigrinhoCommunityHolder tigrinhoCommunityHolder = new TigrinhoCommunityHolder(_tigrinhoAddress, _tigrinhoFundAddress);
        vm.stopBroadcast();
        return tigrinhoCommunityHolder;
    }
}