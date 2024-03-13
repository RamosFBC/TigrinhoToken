// SPDX-License-Identifier: The Unlicense

pragma solidity ^0.8.18;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {TigrinhoCommunityHolder} from "./TigrinhoCommunityHolder.sol";


contract TigrinhoFund is Ownable {

        // Referencia do contrato TigrinhoCommunityHolder
        TigrinhoCommunityHolder public tigrinhoCommunityHolder;

        address[] public contribuidores;
        uint256 public totalContribuido;
        // Mapeamento de quanto cada contribuidor contribuiu
        mapping(address => uint256) valorContribuido;

        // Eventos para sinalizar mudanças de estado importantes no contrato
        event ContribuicaoRealizada(address contribuidor, uint256 valor);
        event FundosRetirados(uint256 valor);

    constructor() Ownable(msg.sender) {
        totalContribuido = 0;
    }
    
    // Função para contribuidores investirem no projeto
    function contribuir() external payable {
        require(msg.value > 0, "Valor investido deve ser maior que 0");
        // Verifica se o contribuidor já realizou contribuição prévia
        // então realiza a transferência para o contrato
        if (valorContribuido[msg.sender] == 0) {
            valorContribuido[msg.sender] = msg.value;
            contribuidores.push(msg.sender);
            totalContribuido += msg.value;
        } else {
            valorContribuido[msg.sender] += msg.value;
            totalContribuido += msg.value;
        }
        // Emite evento de Contribuição Realizada
        emit ContribuicaoRealizada(msg.sender, msg.value / 1e18);
    }

    // Função a ser chamada pelo Fundador para retirar os fundos a serem utilizados
    // na criação da liquidez no UNISWAP
    function retirar() external onlyOwner {
        // Cria variável com o saldo do contrato
        uint256 saldoContrato = address(this).balance;
        // Cria variável para saldo em TIGR de acordo com o contrato TigrinhoCommunityHolder
        uint256 saldoTigrinho = tigrinhoCommunityHolder.getSaldoTigrinho();
        // Verifica se o valor contribuído é válido e se existe saldo em TIGR para ser distribuído
        // no contrato TigrinhoCommunityHolder
        require(saldoContrato > 0, "Nenhum valor para ser retirado");
        require(saldoTigrinho < 10, "E necessario distribuir os tokens antes de realizar a retirada");
        // Transfere o saldo do contrato ao Fundador
        payable(owner()).transfer(saldoContrato);
        // Zera o total contribuido
        totalContribuido = 0;
        // Emite evento de Fundos Retirados
        emit FundosRetirados(saldoContrato);

        // Reinicia mapping Valor Contribuído
        for (uint256 i = 0; i < contribuidores.length; i++) {
            valorContribuido[contribuidores[i]] = 0;
        }
        // Reinicia contrubuidores do contrato
        delete contribuidores;
        // reinicia Total Contribuído
        totalContribuido = 0;

    }

    function setTigrinhoCommunityHolder(address endereco) external onlyOwner {
        tigrinhoCommunityHolder = TigrinhoCommunityHolder(endereco);
    }

    function getQuantidadeContribuidores() external view returns (uint256) {
        return contribuidores.length;
    }

    function getValorContribuido(address contribuidor) external view returns (uint256) {
        return valorContribuido[contribuidor];
}


}