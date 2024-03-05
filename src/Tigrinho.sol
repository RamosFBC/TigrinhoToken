// SPDX-License-Identifier: The Unlicense

pragma solidity ^0.8.15;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tigrinho is ERC20 {
    constructor(uint256 initialSupply) ERC20("Tigrinho", "TIGR") {
        _mint(msg.sender, initialSupply);
    }
}