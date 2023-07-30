import 'dart:convert';

import 'package:fantom/api/ftmscan.dart';
import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:web3dart/web3dart.dart';
import "../utils/time.dart";

import '../components/add_contact_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = GetStorage().read("address");
  String balance = "0";
  List contacts = [];
  List transactions = [];

  Future<void> gB() async {
    // String b = await getBalance(address);
    // if (!mounted) return;
    // setState(() {
    //   balance = b;
    // });
  }

  void gC() {
    String? c = GetStorage().read("contacts");
    if (c == null || c == "") c = jsonEncode({'contacts': []});
    Map pC = jsonDecode(c);
    if (!mounted) return;
    setState(() {
      contacts = pC["contacts"];
    });
  }

  Future<void> gT() async {
    var t = await getTransactionsByAccount(address);
    if (!mounted) return;
    setState(() {
      transactions = t;
    });
  }

  Future<void> addContact() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (_) {
          return const AddContactModal();
        });
    gC();
  }

  bool ownAddress(add) {
    return address == add;
  }

  @override
  void initState() {
    super.initState();
    gB();
    gC();
    gT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: primaryColor,
        color: Colors.white,
        onRefresh: () async {
          gC();
          await gT();
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
                    // Balance Tile
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      height: (MediaQuery.of(context).size.height / 100) * 22.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: primaryColor,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Your Balance",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white70),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "$balance FRX",
                                    style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/frax-logo.png",
                                    height: 28,
                                    color: Colors.white,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: address));
                                      Get.snackbar("Copied!",
                                          "Address copied to clipboard.",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: primaryColor);
                                    },
                                    child: Text(
                                      "${address.substring(0, 6)} **** **** ${address.substring(38, 42)}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(height: 24),
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: GestureDetector(
                              onTap: () => Get.toNamed("/send"),
                              child: const Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor:
                                        Color.fromRGBO(253, 201, 46, 1),
                                    child: Icon(
                                      Icons.arrow_outward_sharp,
                                      size: 26,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Send",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: GestureDetector(
                              onTap: () => Get.toNamed("/recieve"),
                              child: const Row(
                                children: [
                                  CircleAvatar(
                                      radius: 22,
                                      backgroundColor:
                                          Color.fromRGBO(253, 201, 46, 1),
                                      child: RotatedBox(
                                        quarterTurns: 2,
                                        child: Icon(
                                          Icons.arrow_outward_sharp,
                                          size: 26,
                                          color: Colors.black,
                                        ),
                                      )),
                                  SizedBox(width: 12),
                                  Text(
                                    "Request",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Quick Send
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quick Send",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => addContact(),
                          child: const Text(
                            "Add new",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
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
                        itemCount: contacts.length + 1,
                        itemBuilder: (_, ind) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                if (ind == contacts.length) {
                                  addContact();
                                } else {
                                  Get.toNamed("/send",
                                      arguments: contacts[ind]['address']);
                                }
                              },
                              child: Column(
                                children: [
                                  (ind == contacts.length
                                      ? CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.grey.shade800,
                                          child: const Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        )
                                      : RandomAvatar(contacts[ind]['address'],
                                          height: 80, width: 80)),
                                  const SizedBox(height: 8),
                                  Text(
                                    ind == contacts.length
                                        ? "Add contact"
                                        : contacts[ind]['name'],
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
                    // Recent Activity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recent Activity",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed("/transactions"),
                          child: const Text(
                            "See all",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.only(top: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: transactions.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("You haven't made any transactions📥",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: transactions.isNotEmpty
                                    ? transactions.length >= 4
                                        ? 4
                                        : transactions.length
                                    : 0,
                                itemBuilder: (_, ind) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.grey.shade200))),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.grey.shade100,
                                          child: Center(
                                            child: ownAddress(
                                                    transactions[ind]['to'])
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
                                          "${ownAddress(transactions[ind]['to']) ? "Recieved from" : "Sent to"} ${(ownAddress(transactions[ind]['to']) ? transactions[ind]['from'] : transactions[ind]['to'])?.substring(37, 42)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade800),
                                        ),
                                        subtitle: Text(
                                          TimeFormatter.formattTime(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  int.parse(transactions[ind]
                                                          ['timeStamp']) *
                                                      1000)),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        trailing: Text(
                                          "${EtherAmount.fromBase10String(EtherUnit.wei, transactions[ind]['value']).getValueInUnit(EtherUnit.ether).toStringAsFixed(2)} FRAX USD",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ownAddress(
                                                    transactions[ind]['to'])
                                                ? Colors.green.shade400
                                                : Colors.grey.shade800,
                                            fontSize: 18,
                                          ),
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
