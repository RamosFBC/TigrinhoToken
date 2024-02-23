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

    // saldoComunidadeInicial é o saldo inicial que será depositado no contrato
    // para distribuir para a comunidade
    uint256 public saldoTigrinhoInicial;

    // Eventos para notificar as ações do contrato
    event DepositoRealizado(address indexed remetente, uint256 quantidade);
    event TokensDistribuidos(address[] destinatarios, uint256[] quantidades);

    constructor(address enderecoTigrinho, address enderecoFund) Ownable(msg.sender) {
        tigrinho = IERC20(enderecoTigrinho);
        tigrinhoFund = TigrinhoFund(enderecoFund);
    }

    // Função que será chamada após o mint dos tokens Tigrinho para
    // depositar os tokens que serão distribuidos para a comunidade 
    function depositar(uint256 quantidade) external onlyOwner{
        // Transfere os tokens para o contrato
        tigrinho.transferFrom(msg.sender, address(this), quantidade);

        saldoTigrinhoInicial = quantidade;

        emit DepositoRealizado(msg.sender, quantidade);
    }

        function getSaldoTigrinho() public view returns (uint256) {
            return tigrinho.balanceOf(address(this));
        }

        // Distribui os tokens para os contribuidores do TigrinhoFund
        function distribuirTokens() external onlyOwner {
            // Pega o total valor contribuido no contrato TigrinhoFund
            uint256 totalDepositado = tigrinhoFund.getTotalContribuido();
            // Verifica se existe algum valor para ser distribuído
            require(totalDepositado > 0, "TigrinhoFund deve ter valor depositado para Distribuicao de tokens.");

            // Pega a quantidade de contribuidores e a lista de contribuidores
            uint256 quantidadeContribuidores = tigrinhoFund.getQuantidadeContribuidores();
            address[] memory contribuidores = tigrinhoFund.getContribuidores();
            // Verifica se existe contribuidores para distribuir os tokens
            require(quantidadeContribuidores > 0, "TigrinhoFund deve ter contribuidores para Distribuicao de tokens.");

            // Cria um array para armazenar as quantidades de tokens a serem transferidos
            uint256[] memory quantidadesTokens = new uint256[](quantidadeContribuidores);

            // Calcula as quantidades de tokens a serem transferidos para cada contribuidor
            for (uint256 i = 0; i < quantidadeContribuidores; i++) {
                address contribuidor = contribuidores[i];
                uint256 valorContribuido = tigrinhoFund.getValorContribuido(contribuidor);
                uint256 quantidadeTokens = (valorContribuido * saldoTigrinhoInicial) / tigrinhoFund.getTotalContribuido();
                quantidadesTokens[i] = quantidadeTokens;
                
                // Transfere os tokens para o contribuidor
                tigrinho.transfer(contribuidor, quantidadeTokens);
            }
        }


}