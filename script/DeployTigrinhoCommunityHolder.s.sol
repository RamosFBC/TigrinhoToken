// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {TigrinhoCommunityHolder} from "../src/TigrinhoCommunityHolder.sol";

contract DeployTigrinhoCommunityHolder is Script {

    address public tigrinhoAddress;
    address public tigrinhoFundAdress;

    constructor(address _tigrinhoAddress, address _tigrinhoFundAddress) {
        tigrinhoAddress = _tigrinhoAddress;
        tigrinhoFundAdress = _tigrinhoFundAddress;
    }

    function run() external returns (TigrinhoCommunityHolder) {
        vm.startBroadcast();
        TigrinhoCommunityHolder tigrinhoCommunityHolder = new TigrinhoCommunityHolder(tigrinhoAddress, tigrinhoFundAdress);
        vm.stopBroadcast();
        return tigrinhoCommunityHolder;
    }
}