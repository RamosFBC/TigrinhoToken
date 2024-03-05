// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
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
    uint256 public constant INVESTMENT_2 = 200 * 1e18;
    uint256 public constant INVESTMENT_3 = 333 * 1e18;
    uint256 public constant INVESTMENT_4 = 3057 * 1e18;
    uint256 public constant INVESTMENT_5 = 10000000 * 1e18;
    uint256 public constant INVESTMENT_6 = 10000000000 * 1e18;

    address joao = makeAddr("Joao");
    address maria = makeAddr("Maria");
    address douglas = makeAddr("Douglas");
    address marcelo = makeAddr("Marcelo");
    address lucas = makeAddr("Lucas");
    address felipe = makeAddr("Felipe");

    function setUp() public {

        tigrinhoDeployer = new DeployTigrinho();
        tigrinho = tigrinhoDeployer.run();

        fundDeployer = new DeployTigrinhoFund();
        tigrinhoFund = fundDeployer.run();

        communityHolderDeployer = new DeployTigrinhoCommunityHolder();
        tigrinhoCommunityHolder = communityHolderDeployer.run(address(tigrinho), address(tigrinhoFund));

        // vm.prank(msg.sender);
        // tigrinho.approve(address(tigrinhoCommunityHolder), COMMUNITY_SUPPLY);
        // tigrinhoCommunityHolder.depositar(COMMUNITY_SUPPLY);

        vm.deal(joao, 100000000 * 1e18);
        vm.deal(maria, 100000000 * 1e18);
        vm.deal(douglas, 100000000 * 1e18);
        vm.deal(marcelo, 100000000 * 1e18);
        vm.deal(lucas, 100000000 * 1e18);
        vm.deal(felipe, 100000000000 * 1e18);

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

        vm.prank(felipe);
        tigrinhoFund.contribuir{value: INVESTMENT_6}();
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
        assertEq(INVESTMENT_6, tigrinhoFund.getValorContribuido(felipe));
    }

    function testDepositar() public {
        vm.prank(msg.sender);
        tigrinho.transfer(address(tigrinhoCommunityHolder), COMMUNITY_SUPPLY);
        assertEq(COMMUNITY_SUPPLY, tigrinhoCommunityHolder.getSaldoTigrinho());
    }

    function testDistribution() public {
        vm.prank(msg.sender);
        tigrinho.transfer(address(tigrinhoCommunityHolder), COMMUNITY_SUPPLY);
        console.log("Balance Contrato ", tigrinho.balanceOf(address(tigrinhoCommunityHolder)));

        console.log("Total Contribuido: ", tigrinhoFund.totalContribuido());

        uint256 expectedBalanceJoao = (COMMUNITY_SUPPLY * INVESTMENT_1) / tigrinhoFund.totalContribuido();
        console.log("Expected Balance Joao: ", expectedBalanceJoao);
        uint256 expectedBalanceMaria = (COMMUNITY_SUPPLY * INVESTMENT_2) / tigrinhoFund.totalContribuido();
        console.log("Expected Balance Maria: ", expectedBalanceMaria);
        
        vm.prank(msg.sender);
        tigrinhoCommunityHolder.distribuirTokens();
        console.log("Balance Contrato ", tigrinho.balanceOf(address(tigrinhoCommunityHolder)));

        console.log("Balance Joao: ", tigrinho.balanceOf(joao));
        uint256 balanceJoao = tigrinho.balanceOf(joao);
        assertEq(expectedBalanceJoao, balanceJoao);

        console.log("Balance Maria: ", tigrinho.balanceOf(maria));
        uint256 balanceMaria = tigrinho.balanceOf(maria);
        assertEq(expectedBalanceMaria, balanceMaria);

        console.log("Balance Douglas: ", tigrinho.balanceOf(douglas));
        uint256 balanceDouglas = tigrinho.balanceOf(douglas);
        assertEq((COMMUNITY_SUPPLY * INVESTMENT_3) / tigrinhoFund.totalContribuido(), balanceDouglas);

        console.log("Balance Marcelo: ", tigrinho.balanceOf(marcelo));
        uint256 balanceMarcelo = tigrinho.balanceOf(marcelo);
        assertEq((COMMUNITY_SUPPLY * INVESTMENT_4) / tigrinhoFund.totalContribuido(), balanceMarcelo);

        console.log("Balance Lucas: ", tigrinho.balanceOf(lucas));
        uint256 balanceLucas = tigrinho.balanceOf(lucas);
        assertEq((COMMUNITY_SUPPLY * INVESTMENT_5) / tigrinhoFund.totalContribuido(), balanceLucas);

        console.log("Balance Felipe: ", tigrinho.balanceOf(felipe));
        uint256 balanceFelipe = tigrinho.balanceOf(felipe);
        assertEq((COMMUNITY_SUPPLY * INVESTMENT_6) / tigrinhoFund.totalContribuido(), balanceFelipe);
        

        console.log("Summed balances: ", balanceJoao + balanceMaria + balanceDouglas + balanceMarcelo + balanceLucas + balanceFelipe);
    }

}