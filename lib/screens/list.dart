import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fantom/api/tokens.dart';
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
  List tokens = [];
  late Timer timer;

  List<Map> addressList = [
    {
      "name": "fDAIx",
      "address": "0x5D8B4C2554aeB7e86F387B4d6c00Ac33499Ed01f",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/celo_logo.png",
    },
    {
      "name": "fUSDCx",
      "address": "0x42bb40bf79730451b11f6de1cba222f17b87afd7",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/celo_logo.png",
    },
    {
      "name": "MATICx",
      "address": "0x96b82b65acf7072efeb00502f45757f254c2a0d4",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/cusd.png",
    }
  ];

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        for (var i = 0; i < addressList.length; i++) {
          setState(() {
            addressList[i]['balance'] -= addressList[i]['currentFlowRate'];
          });
        }
      },
    );
  }

  Future<void> gT() async {
    List b = await getTokens();
    if (!mounted) return;

    for (var i = 0; i < b.length; i++) {
      setState(() {
        final token = addressList
            .firstWhereOrNull((e) => e['address'] == b[i]['token']['id']);
        if (token == null) return;
        token['currentFlowRate'] = EtherAmount.inWei(
                BigInt.from(double.parse(b[i]['currentFlowRate'])))
            .getValueInUnit(EtherUnit.ether);
      });
      // final secondsElapsed = (DateTime.now().millisecondsSinceEpoch / 1000 -
      //     double.parse(b[i]['createdAtTimestamp']));
      // final ethPerSecond =
      //     EtherAmount.inWei(BigInt.from(int.parse(b[i]['currentFlowRate'])))
      //         .getValueInUnit(EtherUnit.ether);
      // final totalEthSinceCreated = ethPerSecond * secondsElapsed;
      // setState(() {
      //   final token = addressList
      //       .firstWhereOrNull((e) => e['address'] == b[i]['token']['id']);
      //   if (token == null) return;
      //   token['balance'] -= totalEthSinceCreated;
      //   token['currentFlowRate'] = EtherAmount.inWei(
      //           BigInt.from(double.parse(b[i]['currentFlowRate'])))
      //       .getValueInUnit(EtherUnit.ether);
      // });
      // print(EtherAmount.inWei(BigInt.from(int.parse(b[i]['currentFlowRate'])))
      //         .getValueInUnit(EtherUnit.ether) *
      //     31 *
      //     24 *
      //     60 *
      //     60);
    }
    startTimer();
  }

  Future gB() async {
    for (var i = 0; i < addressList.length; i++) {
      double b = await getBalance("0x3b18dCa02FA6945aCBbE2732D8942781B410E0F9",
          addressList[i]['address']);
      setState(() {
        addressList[i]['balance'] = b;
      });
    }
    gT();
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
                              onTap: () {},
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
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 48, 48, 48),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Center(
                                    child: ownAddress(addressList[ind]['to'])
                                        ? RotatedBox(
                                            quarterTurns: 2,
                                            child: Icon(
                                                Icons.arrow_outward_sharp,
                                                color: Colors.green.shade400))
                                        : Icon(Icons.arrow_outward_sharp,
                                            color: Colors.red.shade400),
                                  ),
                                ),
                                title: Text(
                                  "${addressList[ind]['name']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                trailing: AnimatedFlipCounter(
                                  duration: const Duration(seconds: 1),
                                  value: addressList[ind]['balance'],
                                  fractionDigits: 9,
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
                        child: addressList.isEmpty
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
                                itemCount: addressList.length,
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
                                          backgroundColor: Colors.white,
                                          child: Center(
                                            child: ownAddress(
                                                    addressList[ind]['to'])
                                                ? RotatedBox(
                                                    quarterTurns: 2,
                                                    child: Icon(
                                                        Icons
                                                            .arrow_outward_sharp,
                                                        color: Colors
                                                            .green.shade400))
                                                : Icon(
                                                    Icons.arrow_outward_sharp,
                                                    color: Colors.red.shade400),
                                          ),
                                        ),
                                        title: Text(
                                          "${addressList[ind]['name']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        trailing: AnimatedFlipCounter(
                                          duration: const Duration(seconds: 1),
                                          value: addressList[ind]['balance'],
                                          fractionDigits: 9,
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
