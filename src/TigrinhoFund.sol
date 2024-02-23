// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


contract TigrinhoFund is Ownable {
    constructor() Ownable(msg.sender) {}
        address[] public contribuidores;
        uint256 public totalContribuido;
        // Mapeamento de quanto cada contribuidor contribuiu
        mapping(address => uint256) valorContribuido;

        // Eventos para sinalizar mudanças de estado importantes no contrato
        event ContribuicaoRealizada(address contribuidor, uint256 valor);
        event FundosRetirados(uint256 valor);
    
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
        emit ContribuicaoRealizada(msg.sender, msg.value);
    }

    // Função a ser chamada pelo Fundador para retirar os fundos a serem utilizados
    // na criação da liquidez no UNISWAP
    function retirar() external onlyOwner {
        // Cria variável com o saldo do contrato
        uint256 saldoContrato = address(this).balance;
        // Verifica se o valor contribuído é válido
        require(saldoContrato > 0, "Nenhum valor para ser retirado");
        // Transfere o saldo do contrato ao Fundador
        payable(owner()).transfer(saldoContrato);
        // Emite evento de Fundos Retirados
        emit FundosRetirados(saldoContrato);
    }

    function getQuantidadeContribuidores() external view returns (uint256) {
        return contribuidores.length;
    }

    function getContribuidores() external view returns (address[] memory) {
        return contribuidores;
    }

    function getValorContribuido(address contribuidor) external view returns (uint256) {
        return valorContribuido[contribuidor];
}

    function getTotalContribuido() external view returns (uint256) {
        return totalContribuido;
    }


}