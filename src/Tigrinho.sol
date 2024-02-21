// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tigrinho is ERC20 {
    constructor(uint256 initialSupply, address communityWallet, address liquidityWallet) ERC20("Tigrinho", "TIGR") {
        uint256 communitySupply = initialSupply * 55 / 100;  // 55% of initial supply to community
        uint256 liquiditySupply = initialSupply * 28 / 100;  // 28% of initial supply to liquidity

        // Remaining supply goes to the deployer
        uint256 deployerSupply = initialSupply - communitySupply - liquiditySupply;

        _mint(msg.sender, deployerSupply);
        _mint(communityWallet, communitySupply);
        _mint(liquidityWallet, liquiditySupply);
    }
}