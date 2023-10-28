var {
    hash,
    createIdentity,
    sign,
    recover, // you recover the ethereum address
    recoverPublicKey,
  } = require("eth-crypto");
  
  // Creating Maria's credentials
  const maria = createIdentity(); // Publica key + private key
  
  // Maria writes a message
  const mensaje = "Este mensaje fue escrito por Maria";
  const mensajeHasheado = hash.keccak256(mensaje);
  
  // Maria signs the hashed message
  const firmaDigital = sign(maria.privateKey, mensajeHasheado);
  console.log(firmaDigital);
  
  // Recovering public key
  var llavePublica = recoverPublicKey(firmaDigital, mensajeHasheado);
  console.log("Recover Public Key", llavePublica);
  console.log("Public Key Maria", maria.publicKey);