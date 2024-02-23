// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Tigrinho} from "../src/Tigrinho.sol";
import {DeployTigrinho} from "../script/DeployTigrinho.s.sol";

contract TigrinhoTest is Test {
    Tigrinho public tigrinho;
    DeployTigrinho public deployer;

    uint256 public constant STARTING_BALANCE = 1000000000 ether;
    uint256 public constant INITIAL_SUPPLY = 69 * 1e9 ether;

    address joao = makeAddr("Joao");
    address maria = makeAddr("Maria");

    function setUp() public {
        deployer = new DeployTigrinho();
        tigrinho = deployer.run();

        vm.prank(msg.sender);
        tigrinho.transfer(joao, STARTING_BALANCE);
    }

    function testJoaoBalance() public {
        assertEq(STARTING_BALANCE, tigrinho.balanceOf(joao));
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000000;

        // Joao apporoves Maria to spend 1 million TIG
        vm.prank(joao);
        tigrinho.approve(maria, initialAllowance);

        uint256 transferAmount = 500000;

        vm.prank(maria);
        tigrinho.transferFrom(joao, maria, transferAmount);
    }

    // Test Initial Supply 
    function testInitialSupply() public {
        assertEq(INITIAL_SUPPLY, tigrinho.totalSupply());
    }

    // Test if msg.sender balance is equal to initial supply
    function testMsgSenderBalance() public {
        assertEq(INITIAL_SUPPLY, tigrinho.balanceOf(msg.sender) + tigrinho.balanceOf(joao));
    }
}