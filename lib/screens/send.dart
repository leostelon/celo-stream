import 'dart:math';

import 'package:fantom/components/button.dart';
import 'package:fantom/components/select_address_modal.dart';
import 'package:fantom/themes.dart';
import 'package:fantom/utils/token.dart';
import 'package:fantom/utils/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:web3dart/web3dart.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  dynamic argumentData = Get.arguments;
  bool loading = false;
  late TextEditingController controller;
  String balance = "0";
  String frxBalance = "0";
  late String? address;
  late Map token;

  void gFRXB() async {
    String a = GetStorage().read("address");
    double b = await getBalance(a, token['address']);
    setState(() {
      frxBalance = b.toStringAsFixed(4);
    });
  }

  void gB() async {
    EtherAmount b = await ethClient
        .getBalance(EthereumAddress.fromHex(GetStorage().read("address")));
    setState(() {
      balance = b.getValueInUnit(EtherUnit.ether).toStringAsFixed(3).toString();
    });
  }

  void sc() async {
    if (address == null) {
      Get.snackbar("Enter Address", "Please select and add address",
          backgroundColor: primaryColor, snackPosition: SnackPosition.BOTTOM);
    } else {
      setState(() {
        loading = true;
      });
      await sendToken(
          address!,
          token['address'],
          BigInt.from(double.parse(
                  controller.text.replaceAll(" ${token['symbol']}", "")) *
              (pow(10, 18))));
      setState(() {
        loading = false;
      });
      Get.offNamed("/index");
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar("Successfully sent.",
          "${controller.text} has been sent successfully.",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: primaryColor);
    }
  }

  @override
  void initState() {
    super.initState();
    token = argumentData;
    controller = TextEditingController(text: "0 ${token['symbol']}");
    gB();
    gFRXB();
    address = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Send Crypto",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton.outlined(
              onPressed: () => Get.toNamed("/scanner"),
              icon: const Icon(Icons.qr_code))
        ],
      ),
      body: Column(children: [
        const Text("send"),
        ListTile(
          title: Text(address != null ? "Sending to" : "Select address"),
          subtitle: Text(address ?? "Tap to select or paste address"),
          leading: RandomAvatar(address ?? "0", height: 50, width: 50),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
          onTap: () async {
            String add = await showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                context: context,
                builder: (_) {
                  return const SelectAddressModal();
                });
            setState(() {
              address = add;
            });
          },
        ),
        const SizedBox(height: 32),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: controller,
                    onChanged: (v) {
                      controller.value = controller.value.copyWith(
                        text: "${controller.text} ${token['symbol']}",
                        selection: TextSelection.collapsed(
                          offset: "${controller.text} FTX".length - 4,
                        ),
                      );
                    },
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: 40,
                      decoration: TextDecoration.none,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,6}')),
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    cursorColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Your balance: $frxBalance ${token['symbol']}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
              ),
            ),
            Text(
              "Celo balance: $balance CELO",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button(
                title: "Send",
                backgroundColor: primaryColor,
                fontColor: Colors.white,
                onClick: () {
                  sc();
                },
                loading: loading,
              ),
            ],
          ),
        )
      ]),
    );
  }
}
