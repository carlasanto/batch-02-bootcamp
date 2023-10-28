// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;



contract Desafio_1 {
    // Mapping simple
    mapping(address => uint256) public activosSimple;

    function guardarActivoSimple(
        address cuenta, 
        uint256 activo) 
        public {
            require(cuenta != address(0), "El address no puede ser 0x00");
            activosSimple[cuenta] = activo;
    }

    // Mapping double
    mapping(address => mapping(uint256 => uint256)) public activosDouble;

    function guardarActivoDoble(
        address usuario, 
        uint256 activoId, 
        uint256 cantidad) 
        public {
            require(usuario != address(0), "El address no puede ser 0x00");
            require(activoId >= 1 && activoId <= 999999, "Codigo de activo invalido");
            activosDouble[usuario][activoId] = cantidad;
    }

    // Custom error for invalid city code
    error CiudadInvalidaError(uint256 ciudadId);

    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) public activosTriple;

    function guardarActivoTriple(
    uint256 ciudadId,
    address usuario, 
    uint256 activoId, 
    uint256 cantidad) 
    public {
        require(usuario != address(0), "El address no puede ser 0x00");
        require(activoId >= 1 && activoId <= 999999, "Codigo de activo invalido");
        
        if (ciudadId < 1 || ciudadId > 999999) {
            revert CiudadInvalidaError(ciudadId);
    }
        activosTriple[ciudadId][usuario][activoId] = cantidad;
    }
}
