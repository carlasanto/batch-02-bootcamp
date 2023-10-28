var { ethers } = require("hardat");
const Wallet = ethers.Wallet.createRandom();
console.log("Llave private Ethers.sj", Wallet.privatekey);

const mnemonic = ethers.Wallet.createRandom().mnemonic;
console.log(mnemonic.phrase);
const Wallet2 = ethers.Wallet.fromPhrase(mnemonic.phrase);
console.log("Llave privada (mnemonic)", Wallet2.privatekey);

// ec: elliptic curve
var { ec } = require("elliptic");
const curve = new ec("secp256k1");
const keyPair = curve.genKeyPair();
console.log("Llave privada (ec):", keyPair.getPrivate("hex"));
