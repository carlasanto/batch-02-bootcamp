// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Desafio_2 {
    address public admin = 0x08Fb288FcC281969A0BBE6773857F99360f2Ca06;

    modifier soloAdmin() {
        require(msg.sender == admin, "No eres el admin");
        _;
    }

    mapping(address => bool) public listaBlanca;

    modifier soloListaBlanca() {
        require(listaBlanca[msg.sender] || msg.sender == admin, "Fuera de la lista blanca");
        _;
    }

    function incluirEnListaBlanca(address cuenta) public soloAdmin {
        //admin = msg.sender; //    
        listaBlanca[cuenta] = true;
        
    }

    uint256 public tiempoLimite =block.timestamp + 30 days; 
    modifier soloEnTiempo() {
        require(block.timestamp <= tiempoLimite, "Fuera de tiempo");
        _;
    }

    function metodoTiempoProtegido() public soloEnTiempo {
        
        tiempoLimite = block.timestamp + 30 days;
        pausado = false;     
    }
    
    bool public pausado;

    modifier pausa() {
        require(!pausado || msg.sender == admin, "El metodo esta pausado");
        _;
    }

    function cambiarPausa() public soloAdmin {
        
        pausado = !pausado;
            
    }
    
    function metodoPausaProtegido() public cuandoPausado {
        //admin = msg.sender;//
        
    }


       

    

    
 
    

    modifier cuandoPausado() {
        require (!pausado || msg.sender == admin, "El metodo esta pausado");
        _;
    }

    modifier metodoPausa() {
        require(!pausado || msg.sender == admin, "El metodo esta pausado");
        _;
    }

    
    
    function cambiarEstadoPausado(bool estado) public soloAdmin {
        pausado = estado;
    }


    function metodoAccesoProtegido() public soloAdmin soloEnTiempo pausa{
        
        // Verifica que se llame dentro del rango de tiempo especificado
        tiempoLimite = block.timestamp + 30 days;
        pausado = false;
              
            
    }
        
    function metodoPermisoProtegido() public soloListaBlanca soloEnTiempo {
        
       tiempoLimite = block.timestamp + 30 days;
       pausado = false;
    }
    

    
    

    
    
    function verificarPausado() public view returns (bool) {
        return pausado;
            
    }
    
}

