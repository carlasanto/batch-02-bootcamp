// scripts/deployAirdrop.js

var { ethers } = require("hardhat");

async function main() {
  // Verifica si estás en la red correcta (Mumbai)
  if (network.name !== "mumbai") {
    console.error("Este script debe ejecutarse en la red Mumbai.");
    return;
  }
  const AirdropOneCrossChain = await ethers.getContractFactory("AirdropOneCrossChain", // Agrega la ruta completa al contrato
  // Reemplaza con la ruta exacta de tu contrato
);

  const airdrop = await AirdropOneCrossChain.deploy();
  await airdrop.deploy();
  console.log("Airdrop contract deployed to:", airdrop.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
