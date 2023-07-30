import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import "../components/button.dart";
import 'package:web3dart/credentials.dart';

class ImportWallet extends StatefulWidget {
  const ImportWallet({super.key});

  @override
  State<ImportWallet> createState() => _ImportWalletState();
}

class _ImportWalletState extends State<ImportWallet> {
  String pK = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Import Account",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    "Import private key",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Please paste your private key in the below input box.",
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    autocorrect: false,
                    obscureText: true,
                    onChanged: (String v) {
                      setState(() {
                        pK = v;
                      });
                    },
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      title: "Import Wallet",
                      backgroundColor: primaryColor,
                      fontColor: Colors.white,
                      onClick: () {
                        if (pK == "" || !(pK.length == 64 || pK.length == 66)) {
                          return Get.snackbar("Invalid private key!",
                              "Please enter a valid private key!",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: primaryColor);
                        }
                        Credentials credentials = EthPrivateKey.fromHex(pK);
                        GetStorage().write("privateKey", pK);
                        GetStorage()
                            .write("address", credentials.address.toString());
                        Get.toNamed("/index");
                      },
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
