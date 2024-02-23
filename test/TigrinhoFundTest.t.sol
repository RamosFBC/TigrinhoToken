// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {TigrinhoFund} from "../src/TigrinhoFund.sol";
import {DeployTigrinhoFund} from "../script/DeployTigrinhoFund.s.sol";

contract TigrinhoFundTest is Test {
    TigrinhoFund public tigrinhoFund;
    DeployTigrinhoFund public deployer;

    uint256 public constant INVESTMENT_1 = 100 * 1e18;
    uint256 public constant INVESTMENT_2 = 200 * 1e18;
    uint256 public constant INVESTMENT_3 = 333 * 1e18;
    uint256 public constant INVESTMENT_4 = 3057 * 1e18;
    uint256 public constant INVESTMENT_5 = 10000000 * 1e18;

    address joao = makeAddr("Joao");
    address maria = makeAddr("Maria");
    address douglas = makeAddr("Douglas");
    address marcelo = makeAddr("Marcelo");
    address lucas = makeAddr("Lucas");

    function setUp() public {
        deployer = new DeployTigrinhoFund();
        tigrinhoFund = deployer.run();

        vm.deal(joao, 100000000 * 1e18);
        vm.deal(maria, 100000000 * 1e18);
        vm.deal(douglas, 100000000 * 1e18);
        vm.deal(marcelo, 100000000 * 1e18);
        vm.deal(lucas, 100000000 * 1e18);

        vm.prank(joao);
        tigrinhoFund.contribuir{value: INVESTMENT_1}();

        vm.prank(maria);
        tigrinhoFund.contribuir{value: INVESTMENT_2}();

        vm.prank(douglas);
        tigrinhoFund.contribuir{value: INVESTMENT_3}();

        vm.prank(marcelo);
        tigrinhoFund.contribuir{value: INVESTMENT_4}();

        vm.prank(lucas);
        tigrinhoFund.contribuir{value: INVESTMENT_5}();
    }

    function testInvestment() public {
        assertEq(INVESTMENT_1, tigrinhoFund.getValorContribuido(joao));
        assertEq(INVESTMENT_2, tigrinhoFund.getValorContribuido(maria));
        assertEq(INVESTMENT_3, tigrinhoFund.getValorContribuido(douglas));
        assertEq(INVESTMENT_4, tigrinhoFund.getValorContribuido(marcelo));
        assertEq(INVESTMENT_5, tigrinhoFund.getValorContribuido(lucas));
    }

    function testTotalInvestment() public {
        assertEq(INVESTMENT_1 + INVESTMENT_2 + INVESTMENT_3 + INVESTMENT_4 + INVESTMENT_5, tigrinhoFund.totalContribuido());
    }

    function testTotalInvestors() public {
        assertEq(5, tigrinhoFund.getQuantidadeContribuidores());
    }

    function testContribuidoresArray() public {
        assertEq(joao, tigrinhoFund.getContribuidores()[0]);
        assertEq(maria, tigrinhoFund.getContribuidores()[1]);
        assertEq(douglas, tigrinhoFund.getContribuidores()[2]);
        assertEq(marcelo, tigrinhoFund.getContribuidores()[3]);
        assertEq(lucas, tigrinhoFund.getContribuidores()[4]);
    }

    // function testRetirar() public {
    //     uint256 initialBalance = tigrinhoFund.getTotalContribuido();
    //     uint256 contractBalanceBefore = address(tigrinhoFund).balance;

    //     vm.prank(tigrinhoFund.owner());
    //     tigrinhoFund.retirar();

    //     uint256 contractBalanceAfter = address(tigrinhoFund).balance;
    //     uint256 ownerBalanceAfter = tigrinhoFund.balanceOf(tigrinhoFund.owner());

    //     // Check that the contract's balance has decreased by the right amount
    //     assertEq(contractBalanceBefore - initialBalance, contractBalanceAfter);

    //     // Check that the owner's balance has increased by the right amount
    //     assertEq(initialBalance, ownerBalanceAfter);

    //     // Check that the total contributed amount is now 0
    //     assertEq(0, tigrinhoFund.getTotalContribuido());
    // }
}