var { encryptWithPublicKey, decryptWithPublicKey } = require("eth-crypto");
var { ec } = require("elliptic");

//Juan needs to have credentials
const curve = new ec("secp256k1");
const juanKeyPair = curve.genKeyPair(); //Public and private key

// console.log(juanKeyPair.getPublic("hex"));
// console.log(juanKeyPair.getPrivate("hex"));

async function encrypt() {
    // Sent by Juan
    const message = "Hello Juan. This is a secret message";
  
    const mensajeEncriptado = await encryptWithPublicKey(
      juanKeyPair.getPublic("hex"),
      message
    );
  
    console.log("Sending the encrypted message over the Internet...");
  
    // Juan
    const mensajeDesencriptado = await decryptWithPrivateKey(
      juanKeyPair.getPrivate("hex"),
      mensajeEncriptado
    );
  
    console.log("Secret message from Maria", mensajeDesencriptado);
  }
  
  encrypt();