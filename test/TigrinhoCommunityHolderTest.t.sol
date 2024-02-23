// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {TigrinhoCommunityHolder} from "../src/TigrinhoCommunityHolder.sol";
import {TigrinhoFund} from "../src/TigrinhoFund.sol";
import {Tigrinho} from "../src/Tigrinho.sol";
import {DeployTigrinhoFund} from "../script/DeployTigrinhoFund.s.sol";
import {DeployTigrinho} from "../script/DeployTigrinho.s.sol";
import {DeployTigrinhoCommunityHolder} from "../script/DeployTigrinhoCommunityHolder.s.sol";


contract TigrinhoCommunityHolderTest is Test {
    TigrinhoCommunityHolder public tigrinhoCommunityHolder;
    TigrinhoFund public tigrinhoFund;
    Tigrinho public tigrinho;

    DeployTigrinhoFund public fundDeployer;
    DeployTigrinhoCommunityHolder public communityHolderDeployer;
    DeployTigrinho public tigrinhoDeployer;

    uint256 public constant INITIAL_SUPPLY = 69 * 1e9 ether;
    uint256 public constant COMMUNITY_SUPPLY = INITIAL_SUPPLY * 40 / 100;

    uint256 public constant INVESTMENT_1 = 100 * 1e18;
    uint256 public constant INVESTMENT_2 = 100 * 1e18;
    uint256 public constant INVESTMENT_3 = 333 * 1e18;
    uint256 public constant INVESTMENT_4 = 3057 * 1e18;
    uint256 public constant INVESTMENT_5 = 10000000 * 1e18;

    address joao = makeAddr("Joao");
    address maria = makeAddr("Maria");
    address douglas = makeAddr("Douglas");
    address marcelo = makeAddr("Marcelo");
    address lucas = makeAddr("Lucas");

    function setUp() public {
        fundDeployer = new DeployTigrinhoFund();
        tigrinhoFund = fundDeployer.run();

        tigrinhoDeployer = new DeployTigrinho();
        tigrinho = tigrinhoDeployer.run();

        communityHolderDeployer = new DeployTigrinhoCommunityHolder(address(tigrinho), address(tigrinhoFund));
        tigrinhoCommunityHolder = communityHolderDeployer.run();

        // vm.prank(msg.sender);
        // tigrinho.approve(address(tigrinhoCommunityHolder), COMMUNITY_SUPPLY);
        // tigrinhoCommunityHolder.depositar(COMMUNITY_SUPPLY);

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

    function testMsgSenderBalance() public {
        assertEq(INITIAL_SUPPLY, tigrinho.balanceOf(msg.sender));
    }

    function testMsgSenderIsOwner() public {
        assertEq(msg.sender, tigrinhoCommunityHolder.owner());
        assertEq(msg.sender, tigrinhoFund.owner());
    }

    function testInvestment() public {
        assertEq(INVESTMENT_1, tigrinhoFund.getValorContribuido(joao));
        assertEq(INVESTMENT_2, tigrinhoFund.getValorContribuido(maria));
        assertEq(INVESTMENT_3, tigrinhoFund.getValorContribuido(douglas));
        assertEq(INVESTMENT_4, tigrinhoFund.getValorContribuido(marcelo));
        assertEq(INVESTMENT_5, tigrinhoFund.getValorContribuido(lucas));
    }

    function testDepositar() public {
        vm.prank(msg.sender);
        tigrinho.approve(address(tigrinhoCommunityHolder), COMMUNITY_SUPPLY);
        tigrinhoCommunityHolder.depositar(COMMUNITY_SUPPLY);
        assertEq(COMMUNITY_SUPPLY, tigrinhoCommunityHolder.getSaldoTigrinho());
    }

    function testDistribution() public {
        uint256 expectedBalanceJoao = (COMMUNITY_SUPPLY * INVESTMENT_1) / tigrinhoFund.getTotalContribuido();
        // uint256 expectedBalanceMaria = (COMMUNITY_SUPPLY * INVESTMENT_2) / tigrinhoFund.getTotalContribuido();
        vm.prank(msg.sender);
        tigrinhoCommunityHolder.distribuirTokens();
        assertEq(expectedBalanceJoao, tigrinho.balanceOf(joao));
        // assertEq(expectedBalanceMaria / tigrinhoFund.getTotalContribuido(), tigrinho.balanceOf(maria));
        // assertEq((COMMUNITY_SUPPLY * INVESTMENT_3) / tigrinhoFund.getTotalContribuido(), tigrinho.balanceOf(douglas));
        // assertEq((COMMUNITY_SUPPLY * INVESTMENT_4) / tigrinhoFund.getTotalContribuido(), tigrinho.balanceOf(marcelo));
        // assertEq((COMMUNITY_SUPPLY * INVESTMENT_5) / tigrinhoFund.getTotalContribuido(), tigrinho.balanceOf(lucas));
    }

}