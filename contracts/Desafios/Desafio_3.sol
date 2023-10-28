// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/**
 * Ejercicio integrador 3
 *
 * Vamos a crear un contrato que se comporte como un cajero automático o ATM.
 * Mediente este contrato, el usuario puede depositar y retirar fondos.
 * Así también el usuario puede transferir fondos a otro usuario.
 *
 * Tendrá las siguientes características:
 *  - Permite depositar fondos en el contrato mediante el método 'depositar'.
 *  - Permite retirar fondos del contrato mediante el método 'retirar'.
 *  - Permite transferir fondos a otro usuario mediante el método 'transferir'.
 *  - Permite consultar el saldo del usuario. Hacer la estructura de datos 'public'
 *  - Permite consultar el saldo del ATM. Hacer la variable 'public'
 *  - modifier de pausa: verifica si el boolean 'pausado' es true o false
 *  - modifier de admin: verifica que el msg.sender sea el admin
 *  - Permite cambiar el boolean 'pausado' mediante el método 'cambiarPausado' y verifica que solo es llamado por el admin
 *
 * Notas:
 *  - para guardar y actualizar los balances de un usuario, se utilizará un diccionario
 *  - el modifier protector usa un booleano para saber si está activo o no
 *  - este booleano solo puede ser modificado por una cuenta admin definida previamente
 *
 * Testing: Ejecutar el siguiente comando:
 * - npx hardhat test test/DesafioTesting_3.js
 */

contract Desafio_3 {
    // definir address 'admin' con valor de 0x08Fb288FcC281969A0BBE6773857F99360f2Ca06
    // address public admin = 0x08Fb288FcC281969A0BBE6773857F99360f2Ca06;
    // definir boolean public 'pausado' con valor de false
    // bool public pausado;
    address public admin = 0x08Fb288FcC281969A0BBE6773857F99360f2Ca06;
    bool public pausado = false;

    // 7 - definición de modifier 'soloAdmin'
    // verificar que el msg.sender sea el admin
    // poner el comodín fusión al final del método
    // modifier soloAdmin() {
    //     // ...logica
    // }
    modifier soloAdmin() {
        require(msg.sender == admin, "Solo el admin puede ejecutar esta funcion");
        _;
    }

    // 8 - definir modifier 'cuandoPausado'
    // modifier cuandoNoPausado
    // verificar que el boolean 'pausado' sea false
    modifier cuandoPausado() {
        require(!pausado, "El contrato esta pausado");
        _;
    }
    // 1 - definición de variables locales
    // definir variable que almacena el balance total del cajero automático (e.g. balanceTotal)
    // definir mapping que almacena el balance de cada usuario (e.g. balances)
    // balanceTotal;
    // mapping()balances;
    mapping(address => uint256) public balances;
    uint256 public balanceTotal;
    // 2 - definición de eventos importantes
    // definir eventos 'Deposit', 'Transfer' y 'Withdraw'
    // - Deposit tiene dos parámetros: address y uint256 que son (from, value)
    // - Transfer tiene tres parámetros: address, address y uint256 que son (from, to, value)
    // - Withdraw tiene dos parámetros: address y uint256 que son (to, value)
    // event Deposit (...);
    // event Transfer (...);
    // event Withdraw (...);
    event Deposit(address indexed from, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Withdraw(address indexed to, uint256 value);
    // 5 - definición de error personalizado 'SaldoInsuficiente'
    // SaldoInsuficiente
    error SaldoInsuficiente(address account, uint256 balance);///
    // 3 - definición de método 'depositar'
    // definir función 'depositar' que recibe un parámetro uint256 '_cantidad' y es 'public'
    // - aumentar el balance del usuario en '_cantidad'
    // - aumentar el balance total del cajero automático en '_cantidad'
    // - emitir evento 'Deposit'
    function depositar(uint256 _cantidad) public cuandoPausado {
        //require(_cantidad > 0, "La cantidad debe ser mayor que cero");
        balances[msg.sender] += _cantidad;
        balanceTotal += _cantidad;
        emit Deposit(msg.sender, _cantidad);
    }

    // 4 - definición de método 'retirar'
    // definir función 'retirar' que recibe un parámetro uint256 '_cantidad' y es 'public'
    // - verificar que el balance del usuario sea mayor o igual a '_cantidad'
    // - disminuir el balance del usuario en '_cantidad'
    // - disminuir el balance total del cajero automático en '_cantidad'
    // - emitir evento 'Withdraw'
    function retirar(uint256 _cantidad) public cuandoPausado {
        require(balances[msg.sender] >= _cantidad, "Saldo insuficiente");
        //require(!pausado, "El contrato esta pausado");
        //balanceTotal = balanceTotal - _cantidad;//
        balanceTotal -= _cantidad;
        balances[msg.sender] -= _cantidad;
        //balances[msg.sender] = balances[msg.sender] - _cantidad;
        emit Withdraw(msg.sender, _cantidad);
    }
    // 6 - definición de método 'transferir'
    // definir función 'transferir' que recibe dos parámetros: address '_destinatario' y uint256 '_cantidad' y es 'public'
    // - verificar que el balance del usuario sea mayor o igual a '_cantidad'. Si no lo es, disparar error 'SaldoInsuficiente'
    // - disminuir el balance del usuario en '_cantidad'
    // - aumentar el balance del destinatario en '_cantidad'
    // - emitir evento 'Transfer'
    function transferir(address _destinatario, uint256 _cantidad ) public cuandoPausado{
        //require(balances[msg.sender] >= _cantidad, "SaldoInsuficiente");
            if (balances[msg.sender] >= _cantidad) {
                balances[msg.sender] -= _cantidad;
                balances[_destinatario] += _cantidad;
                emit Transfer(msg.sender, _destinatario, _cantidad);
            } else {
                revert SaldoInsuficiente(msg.sender, balances[msg.sender]);
            }
    }
    // 8 - definición de método 'cambiarPausado'
    // definir función 'cambiarPausado' que es 'public' y solo puede ser llamada por el admin (usar modifier)
    // - cambiar el boolean 'pausado' a su valor contrario
    // - emitir
    // function cambiarPausado() public soloAdmin {
    //     pausado = !pausado;
    // }

    function estaPausado() public view returns (bool) {
        return pausado;
    }
    function cambiarPausado() public soloAdmin {
       
        pausado = !pausado;
    }
}