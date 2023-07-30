import 'dart:math';

import 'package:fantom/api/tokens.dart';
import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

List<Map> nftList = [
  {
    "image": "assets/binance.png",
    "name": "Binance",
    "url": "https://www.binance.com/"
  },
  {
    "image": "assets/coinbase.jpg",
    "name": "Coinbase",
    "url": "https://www.coinbase.com/"
  },
];

class ERC20 extends StatefulWidget {
  const ERC20({super.key});

  @override
  State<ERC20> createState() => _ERC20State();
}

class _ERC20State extends State<ERC20> {
  String address = GetStorage().read("address");
  bool loading = true;
  List tokens = [];
  Future<void> gT() async {
    List t = await getTokenByAddress(address);
    if (!mounted) return;
    setState(() {
      tokens = t;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    gT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Tokens"),
          backgroundColor: const Color.fromARGB(255, 27, 27, 27)),
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      body: loading
          ? const SizedBox(height: 3, child: LinearProgressIndicator())
          : tokens.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          "You don't own any Frax 🥲",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Buy tokens at",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.count(
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              crossAxisCount: 2,
                              children: List.generate(nftList.length, (ind) {
                                return GestureDetector(
                                  onTap: () async {
                                    if (!await launchUrl(
                                        Uri.parse(nftList[ind]["url"]),
                                        mode: LaunchMode.externalApplication)) {
                                      Get.snackbar("Unable to open",
                                          "Could not launch ${nftList[ind]["url"]}",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: primaryColor);
                                    }
                                  },
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.asset(
                                              nftList[ind]["image"],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          nftList[ind]["name"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ]),
                                );
                              })),
                        )
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await gT();
                    return;
                  },
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tokens.length,
                      itemBuilder: (_, ind) {
                        return ListTile(
                          leading: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey.shade800,
                              child: Center(
                                child: tokens[ind]["possible_spam"]
                                    ? Icon(
                                        Icons.warning,
                                        color: Colors.grey.shade500,
                                      )
                                    : Text(
                                        "ERC20",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade400),
                                      ),
                              )),
                          title: Text(
                            tokens[ind]["name"],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "${EtherAmount.fromBigInt(EtherUnit.ether, BigInt.from(double.parse(tokens[ind]["balance"]) / (pow(10, tokens[ind]["decimals"])))).getInEther} ${tokens[ind]["symbol"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white54,
                            ),
                          ),
                        );
                      }),
                ),
    );
  }
}
