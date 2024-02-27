// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {TigrinhoFund} from "./TigrinhoFund.sol";

contract TigrinhoCommunityHolder is Ownable {
    // Interface para interagir com o contrato Tigrinho
    IERC20 public tigrinho;
    // Referência para o contrato TigrinhoFund que gerencia as contribuicoes
    TigrinhoFund public tigrinhoFund;

    // saldoComunidadeInicial é o saldo inicial depositado no contrato
    // para distribuir para a comunidade
    uint256 public saldoTigrinhoContrato;

    // Eventos para notificar as ações do contrato
    event TokensDistribuidos(address destinatario, uint256 quantidade);
    event SaldoTigrinhoAntesDaDistribuicao(uint256 saldo);
    event SaldoTigrinhoDepoisDaDistribuicao(uint256 saldo);

    constructor(address enderecoTigrinho, address enderecoFund) Ownable(msg.sender) {
        tigrinho = IERC20(enderecoTigrinho);
        tigrinhoFund = TigrinhoFund(enderecoFund);
    }

        function getSaldoTigrinho() public view returns (uint256) {
            return tigrinho.balanceOf(address(this));
        }

        // Distribui os tokens para os contribuidores do TigrinhoFund
        function distribuirTokens() external onlyOwner {
            // Pega o total valor contribuido no contrato TigrinhoFund
            uint256 totalDepositado = tigrinhoFund.totalContribuido();
            // Verifica se existe algum valor para ser distribuído
            require(totalDepositado > 0, "TigrinhoFund deve ter valor depositado para Distribuicao de tokens.");

            saldoTigrinhoContrato = tigrinho.balanceOf(address(this));

            // Pega a quantidade de contribuidores e a lista de contribuidores
            uint256 quantidadeContribuidores = tigrinhoFund.getQuantidadeContribuidores();
            // Verifica se existe contribuidores para distribuir os tokens
            require(quantidadeContribuidores > 0, "TigrinhoFund deve ter contribuidores para Distribuicao de tokens.");

            emit SaldoTigrinhoAntesDaDistribuicao(getSaldoTigrinho());

            // Calcula as quantidades de tokens a serem transferidos para cada contribuidor
            for (uint256 i = 0; i < quantidadeContribuidores; i++) {
                address contribuidor = tigrinhoFund.contribuidores(i);

                uint256 valorContribuido = tigrinhoFund.getValorContribuido(contribuidor);

                uint256 quantidadeTokens = (valorContribuido * saldoTigrinhoContrato) / totalDepositado;
                
                // Transfere os tokens para o contribuidor
                require(tigrinho.balanceOf(address(this)) >= quantidadeTokens, "O saldo do contrato em Tigrinhos deve ser maior ou igual o valor a ser transferido");
                tigrinho.transfer(contribuidor, quantidadeTokens);
                emit TokensDistribuidos(contribuidor, quantidadeTokens);
            }
            emit SaldoTigrinhoDepoisDaDistribuicao(getSaldoTigrinho());
        }


}