import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';

var client = http.Client();
var ethClient = Web3Client(
    "https://polygon-mainnet.infura.io/v3/c731d68b09e6477fa3c86fa92380133e",
    client);

String generateMnemonic() {
  return bip39.generateMnemonic();
}

Future<String> getPrivateKey(mnemonic) async {
  final seed = bip39.mnemonicToSeed(mnemonic);
  final master = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
  final privateKey = HEX.encode(master.key);
  return privateKey;
}
