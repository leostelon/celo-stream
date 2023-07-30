import 'dart:convert';

import 'package:fantom/api/tokens.dart';
import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

List<Map> nftList = [
  {
    "image": "assets/kradeum.png",
    "name": "Kredeum NFTs",
    "url": "https://app.kredeum.com/"
  },
  {
    "image": "assets/nftGardem.png",
    "name": "NFT Garden",
    "url": "https://nftgarden.app/"
  },
  {
    "image": "assets/nfts2me.jpeg",
    "name": "NFTs2Me",
    "url": "https://nfts2me.com/"
  }
];

class ERC721 extends StatefulWidget {
  const ERC721({super.key});

  @override
  State<ERC721> createState() => _ERC721State();
}

class _ERC721State extends State<ERC721> {
  List tokens = [];
  bool loading = true;
  String address = GetStorage().read("address");

  Future<void> gT() async {
    List t = await getNFTByAddress(address);
    if (!mounted) return;
    setState(() {
      tokens = t;
      loading = false;
    });
  }

  String getImage(String metadata) {
    if (metadata == "") metadata = "{}";
    Map r = jsonDecode(metadata);
    if (r.containsKey('image')) {
      if (r['image'].contains("ipfs://")) {
        r["image"] = r["image"].replaceAll("ipfs://", "https://ipfs.io/ipfs/");
      }
      return r['image'];
    } else {
      return "https://i.ibb.co/YtcDS7B/360-F-462936689-Bp-EEcxfg-Mu-YPf-Ta-IAOC1t-CDurmsno7-Sp.jpg";
    }
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
          title: const Text("NFTS"),
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
                          "You don't own any NFTs🥲",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Explore Fantom NFTs at",
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
                                        Uri.parse(nftList[ind]["url"]))) {
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
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(tokens.length, (ind) {
                      return Container(
                        alignment: Alignment.center,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    tokens[ind].containsKey('metadata')
                                        ? getImage(
                                            tokens[ind]['metadata'] ?? "")
                                        : "",
                                    // "https://ipfs.io/ipfs/QmY11put2PKM3mrKZnR7PiucKaaP5wb7ryse9NA3Ac6CLT",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tokens[ind]["name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${tokens[ind]["amount"]} ${tokens[ind]["symbol"]}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tokens[ind]["contract_type"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 12),
                              ),
                            ]),
                      );
                    }),
                  ),
                ),
    );
  }
}
