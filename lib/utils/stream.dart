import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/services.dart' show rootBundle;

const rpcUrl =
    "https://polygon-mumbai.infura.io/v3/c731d68b09e6477fa3c86fa92380133e";
const rpcWssUrl =
    "wss://polygon-mumbai.infura.io/ws/v3/c731d68b09e6477fa3c86fa92380133e";

final client = Web3Client(rpcUrl, Client(), socketConnector: () {
  return IOWebSocketChannel.connect(rpcWssUrl).cast<String>();
});

Future<String> getAbi() async {
  String abiStringFile = await rootBundle.loadString('lib/utils/stream.json');
  var jsonAbi = jsonDecode(abiStringFile), abiCode = jsonEncode(jsonAbi);
  return abiCode;
}

Future<DeployedContract> getContract(contractAddress) async {
  String abi = await getAbi();
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'MetaCoin'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

createStream(num flowRate, String receiver, String contractAddress) async {
  try {
    List<int> list = '0x'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    String address = GetStorage().read("address");

    final contract =
        await getContract("0xcfA132E353cB4E398080B9700609bb008eceB125");

    final fn = contract.function('createFlow');

    final credentials = EthPrivateKey.fromHex(GetStorage().read("privateKey"));

    final txid = await client.sendTransaction(
      credentials,
      Transaction.callContract(contract: contract, function: fn, parameters: [
        EthereumAddress.fromHex(contractAddress),
        EthereumAddress.fromHex(address),
        EthereumAddress.fromHex(receiver),
        BigInt.from(flowRate * pow(10, 18) / (30 * 24 * 60 * 60)),
        bytes,
      ]),
      chainId: 80001,
    );
    print(txid);
  } catch (e) {
    print(e);
  }
}

cancelStream() async {
  try {
    List<int> list = '0x'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);

    final contract =
        await getContract("0xcfA132E353cB4E398080B9700609bb008eceB125");

    final fn = contract.function('deleteFlow');

    final credentials = EthPrivateKey.fromHex(GetStorage().read("privateKey"));

    final txid = await client.sendTransaction(
      credentials,
      Transaction.callContract(contract: contract, function: fn, parameters: [
        EthereumAddress.fromHex("0x5D8B4C2554aeB7e86F387B4d6c00Ac33499Ed01f"),
        EthereumAddress.fromHex("0x4977f6e179901109b3075aedb9bfa08fd8d9ea8f"),
        EthereumAddress.fromHex("0xda2ee9b29a77977b89b6c0b0c1aeb8d9d9372c1a"),
        bytes,
      ]),
      chainId: 80001,
    );
    print(txid);
  } catch (e) {
    print(e);
  }
}


// fDAIx = 0x070f601eEe8fA4DF3c66EaEB16Ca0c0D8a9a0164
//flowRate, String receiver, String contractAddress