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
  final argsLength = arguments.length;
  if (argsLength != 1) {
    print("Usage: dart bin/any_monic.dart '<mnemonic>'");
    return;
  }

  final mnemonic = arguments[0];

  final derivationPath = "m/44'/60'/0'/0/0"; // Ethereum
  // final derivationPath = "m/44'/137'/0'/0/0"; // RSK

  print("Deriving for path: $derivationPath\n");

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
