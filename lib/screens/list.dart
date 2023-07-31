import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fantom/api/tokens.dart';
import 'package:fantom/components/balance_modal_send.dart';
import 'package:fantom/components/token_dialog.dart';
import 'package:fantom/themes.dart';
import 'package:fantom/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:web3dart/web3dart.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  String address = GetStorage().read("address");
  String balance = "0";
  late Timer timer;
  late Timer streamTimer;

  List<Map> streamingTokens = [];
  List<Map> addressList = [
    {
      "name": "DAI Stable",
      "symbol": "fDAIx",
      "address": "0x5d8b4c2554aeb7e86f387b4d6c00ac33499ed01f",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/celo_logo.png",
    },
    {
      "name": "USDC",
      "symbol": "fUSDCx",
      "address": "0x42bb40bf79730451b11f6de1cba222f17b87afd7",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/celo_logo.png",
    },
    {
      "name": "MATIC",
      "symbol": "MATICx",
      "address": "0x96b82b65acf7072efeb00502f45757f254c2a0d4",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/cusd.png",
    }
  ];

  String getImage(String address) {
    switch (address) {
      case "0x42bb40bf79730451b11f6de1cba222f17b87afd7":
        return "assets/cusd.png";
      default:
        return "assets/celo_logo.png";
    }
  }

  void startTokenTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        for (var i = 0; i < addressList.length; i++) {
          setState(() {
            addressList[i]['balance'] += addressList[i]['currentFlowRate'];
          });
        }
      },
    );
  }

  void startStreamTimer() {
    streamTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        for (var i = 0; i < streamingTokens.length; i++) {
          setState(() {
            streamingTokens[i]['balance'] +=
                streamingTokens[i]['currentFlowRate'];
          });
        }
      },
    );
  }

  Future<void> gT() async {
    List b = await getTokens(address);
    if (!mounted) return;

    for (var i = 0; i < b.length; i++) {
      setState(() {
        final token = addressList
            .firstWhereOrNull((e) => e['address'] == b[i]['token']['id']);
        if (token == null) return;
        token['currentFlowRate'] = EtherAmount.inWei(
                BigInt.from(double.parse(b[i]['totalNetFlowRate'])))
            .getValueInUnit(EtherUnit.ether);
      });
    }
    startTokenTimer();
  }

  Future<void> gST() async {
    List a = await getRecieverStreamingTokens(address);
    List b = await getSenderStreamingTokens(address);
    a = a.map<dynamic>((e) {
      e['currentFlowRate'] = '-${e['currentFlowRate']}';
      return e;
    }).toList();
    b.addAll(a);
    if (!mounted) return;

    for (var i = 0; i < b.length; i++) {
      final token = b[i]['token'];
      token['currentFlowRate'] =
          EtherAmount.inWei(BigInt.from(double.parse(b[i]['currentFlowRate'])))
              .getValueInUnit(EtherUnit.ether);
      token['image'] = getImage(token['id']);
      final bT =
          addressList.firstWhereOrNull((e) => token['id'] == e['address']);
      if (bT == null) return;
      token['balance'] = bT['balance'];

      setState(() {
        streamingTokens.add(token);
      });
    }
    startStreamTimer();
  }

  Future gB() async {
    for (var i = 0; i < addressList.length; i++) {
      double b = await getBalance(address, addressList[i]['address']);
      setState(() {
        addressList[i]['balance'] = b;
      });
    }
    gT();
    gST();
  }

  bool ownAddress(add) {
    return address == add;
  }

  @override
  void initState() {
    super.initState();
    gB();
  }

  @override
  void dispose() {
    timer.cancel();
    streamTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: primaryColor,
        color: Colors.white,
        onRefresh: () async {
          await gB();
          return;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    // Navbar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            RandomAvatar(address, height: 55, width: 55),
                            const SizedBox(width: 16),
                            const Text(
                              "Morning, Ser!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed("/settings"),
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 47, 47, 47),
                            radius: 28,
                            child: Center(
                              child: Image.asset(
                                "assets/settings.png",
                                height: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Tokens
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Tokens",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 110,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: addressList.length,
                        itemBuilder: (_, ind) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: GestureDetector(
                              onTap: () async {
                                await showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    context: context,
                                    builder: (_) {
                                      return TokenDialog(
                                        token: addressList[ind],
                                      );
                                    });
                              },
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.grey.shade800,
                                    backgroundImage:
                                        AssetImage(addressList[ind]['image']),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    addressList[ind]['name'],
                                    style:
                                        const TextStyle(color: Colors.white54),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Balances
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Balances",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: addressList.length,
                        itemBuilder: (_, ind) {
                          return GestureDetector(
                            onTap: () async {
                              await showModalBottomSheet(
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  context: context,
                                  builder: (_) {
                                    return BalanceModalSend(token: addressList[ind]);
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 48, 48, 48),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage(addressList[ind]['image']),
                                    backgroundColor: Colors.white,
                                  ),
                                  title: Text(
                                    "${addressList[ind]['symbol']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "${addressList[ind]['name']}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      AnimatedFlipCounter(
                                        duration: const Duration(seconds: 1),
                                        value: addressList[ind]['balance'],
                                        fractionDigits: 9,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                          (addressList[ind]['currentFlowRate'] *
                                                      31 *
                                                      24 *
                                                      60 *
                                                      60)
                                                  .toStringAsFixed(2) +
                                              "/mo",
                                          style: TextStyle(
                                              color: addressList[ind]
                                                          ['currentFlowRate'] <
                                                      0
                                                  ? Colors.red
                                                  : Colors.green)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Streaming Tokens
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "Streaming Tokens",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: streamingTokens.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("You have zero streaming services📥",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: streamingTokens.length,
                                itemBuilder: (_, ind) {
                                  return Padding(
                                    padding: const EdgeInsets.all(4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 48, 48, 48),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: AssetImage(
                                              streamingTokens[ind]['image']),
                                          backgroundColor: Colors.white,
                                        ),
                                        title: Text(
                                          "${streamingTokens[ind]['symbol']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          "${streamingTokens[ind]['name']}",
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            AnimatedFlipCounter(
                                              duration:
                                                  const Duration(seconds: 1),
                                              value: streamingTokens[ind]
                                                  ['balance'],
                                              fractionDigits: 9,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              (streamingTokens[ind][
                                                              'currentFlowRate'] *
                                                          31 *
                                                          24 *
                                                          60 *
                                                          60)
                                                      .toStringAsFixed(2) +
                                                  "/mo",
                                              style: TextStyle(
                                                  color: streamingTokens[ind][
                                                              'currentFlowRate'] <
                                                          0
                                                      ? Colors.red
                                                      : Colors.green),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
