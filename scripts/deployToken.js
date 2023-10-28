// scripts/deployToken.js

var { ethers } = require("hardhat");

async function main() {
  const name = "Mi Primer Token";
  const symbol = "MPRTKN";

  const MiPrimerTokenCrossChain = await ethers.getContractFactory("MiPrimerTokenCrossChain");
  const token = await MiPrimerTokenCrossChain.deploy(name, symbol);
  await token.deployed();
  
  console.log("Token contract deployed to:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
