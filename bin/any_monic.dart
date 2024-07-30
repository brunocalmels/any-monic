// @dart=2.9

import 'dart:typed_data';
import 'package:bitcoin_flutter/bitcoin_flutter.dart' hide NetworkType;
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/ecc/curves/secp256k1.dart';
import 'package:web3dart/crypto.dart';

BIP32 generateRootNode(
  String mnemonic, [
  NetworkType networkType,
]) {
  var seed = bip39.mnemonicToSeed(mnemonic);
  var master = BIP32.fromSeed(seed);
  return master;
}

Uint8List _decompressPublicKey(Uint8List compressedPubKey) {
  final ECDomainParameters _params = ECCurve_secp256k1();
  return Uint8List.view(
    _params.curve.decodePoint(compressedPubKey).getEncoded(false).buffer,
  );
}

Uint8List _decompressPubkey(pubkeyComp) {
  final pubkeyDecomp = _decompressPublicKey(pubkeyComp);
  final pubkeyDecompSliced = pubkeyDecomp.sublist(1);

  return pubkeyDecompSliced;
}

String _getAddress(pubKey, networkId) {
  final bufAddress = publicKeyToAddress(pubKey);
  final address = bytesToHex(bufAddress);
  return address;
}

void main(List<String> arguments) {
  var mnemonic = arguments[0];
  print("Mnemonic: ${mnemonic}");

  // final derivationPath = "m/44'/60'/0'/0/0"; // Ethereum
  final derivationPath = "m/44'/137'/0'/0/0"; // RKS

  

  print("Derivating for derivation path: $derivationPath");

  final chainId = 1;
  final rootNode = generateRootNode(mnemonic);
  final addressNode = rootNode.derivePath(derivationPath);
  final pubKeyComp = addressNode.publicKey;
  final pubKey = _decompressPubkey(pubKeyComp);

  final address = _getAddress(pubKey, chainId);
  final privateKey = bytesToHex(addressNode.privateKey);

  print("Address: 0x${address}");
  print("Private key: ${privateKey}");
}
