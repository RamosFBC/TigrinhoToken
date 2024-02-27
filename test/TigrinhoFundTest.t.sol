// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {TigrinhoFund} from "../src/TigrinhoFund.sol";
import {DeployTigrinhoFund} from "../script/DeployTigrinhoFund.s.sol";
import {Tigrinho} from "../src/Tigrinho.sol";
import {DeployTigrinho} from "../script/DeployTigrinho.s.sol";


contract TigrinhoFundTest is Test {
    TigrinhoFund public tigrinhoFund;
    DeployTigrinhoFund public deployer;

    Tigrinho public tigrinho;
    DeployTigrinho public deployerTigrinho;

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

        deployerTigrinho = new DeployTigrinho();
        tigrinho = deployerTigrinho.run();

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
        assertEq(joao, tigrinhoFund.contribuidores(0));
        assertEq(maria, tigrinhoFund.contribuidores(1));
        assertEq(douglas, tigrinhoFund.contribuidores(2));
        assertEq(marcelo, tigrinhoFund.contribuidores(3));
        assertEq(lucas, tigrinhoFund.contribuidores(4));
    }

    function testRetirar() public {
        uint256 initialBalance = tigrinhoFund.totalContribuido();
        console.log("Saldo Inicial do TigrinhoFund Salvo: ", initialBalance);
        uint256 contractBalanceBefore = address(tigrinhoFund).balance;
        console.log("Saldo Inicial TigrinhoFund Direto", contractBalanceBefore);

        uint256 ownerBalanceBefore = tigrinhoFund.owner().balance;
        console.log("saldo dono antes retirada: ", ownerBalanceBefore);

        vm.prank(msg.sender);
        tigrinhoFund.retirar();

        console.log("saldo dono apos retirada: ", tigrinhoFund.owner().balance);

        uint256 contractBalanceAfter = address(tigrinhoFund).balance;
        console.log("Saldo contrato apos: ", contractBalanceAfter);
        uint256 ownerBalanceAfter = tigrinhoFund.owner().balance;

        // Check that the contract's balance has decreased by the right amount
        assertEq(contractBalanceBefore - initialBalance, contractBalanceAfter);

        // Check that the owner's balance has increased by the right amount
        assertEq(initialBalance, ownerBalanceAfter - ownerBalanceBefore);

        // Check that the total contributed amount is now 0
        assertEq(0, tigrinhoFund.totalContribuido());
    }
}