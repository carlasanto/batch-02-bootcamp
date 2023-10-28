// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUSDC {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function decimals() external view returns (uint8);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);
}

contract MiTokenCarla is ERC20, ERC20Burnable, Ownable {
    uint256 public ratio = 50; // 1 USDC = 50 MTC
    uint256 public impuesto = 30; // Impuesto del 30%

    address private contractOwner; // Cambiamos el nombre de la variable owner a contractOwner
    mapping(address => bool) private blacklist; // Lista negra de direcciones

    IUSDC public usdc;

    constructor(address usdcAddress) ERC20("Mi Token Carla", "MTC") {
        contractOwner = msg.sender;
        usdc = IUSDC(usdcAddress);
        _mint(msg.sender, 1000000 * 10 ** uint256(decimals()));
    }

    // Agrega una dirección a la lista negra (solo puede ser llamado por el owner)
    function addToBlacklist(address _address) public onlyOwner {
        blacklist[_address] = true;
    }

    // Quita una dirección de la lista negra (solo puede ser llamado por el owner)
    function removeFromBlacklist(address _address) public onlyOwner {
        blacklist[_address] = false;
    }

    function comprarTokensExactoPorUsdc(uint256 cantidadTokens) public returns (bool) {
        require(!blacklist[msg.sender], "Tu direccion esta en lista negra");
        // cantidadTokens viene con 18 decimales
        uint256 amountUsdc = cantidadTokens * ratio; // Aplica el ratio

        // Calcula el impuesto del 30%
        uint256 impuestoAmount = (amountUsdc * impuesto) / 100;
        uint256 cantidadUsdcNeta = amountUsdc - impuestoAmount; // Calcula la cantidad neta a convertir

        // le quitamos 12 decimales
        cantidadUsdcNeta = cantidadUsdcNeta / (10 ** (uint256(decimals()) - _getUSDCDecimals()));
        
        // Transfiere USDC desde el usuario al contrato
        bool usdcTransferSuccess = usdc.transferFrom(msg.sender, address(this), cantidadUsdcNeta);
        if (usdcTransferSuccess) {
            // Mint MTC al usuario
            _mint(msg.sender, cantidadTokens);
            return true;
        } else {
            return false;
        }
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        // Implementar la lógica para transferir tus tokens (MTC)
       
        return super.transfer(to, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        // Implementar la lógica para transferir tokens desde 'from' a 'to'
        
        return super.transferFrom(from, to, amount);
    }

    function _getUSDCDecimals() internal view returns (uint8) {
        // Obtiene la cantidad de decimales de USDC
        // Esta función llama a la función 'decimals' en el contrato USDC
        return usdc.decimals();
    }

    
}
