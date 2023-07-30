import 'dart:convert';

import 'package:fantom/components/button.dart';
import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:random_avatar/random_avatar.dart';

class SelectAddressModal extends StatefulWidget {
  const SelectAddressModal({super.key});

  @override
  State<SelectAddressModal> createState() => _SelectAddressModalState();
}

class _SelectAddressModalState extends State<SelectAddressModal> {
  String address = "";
  List contacts = [];

  void gC() {
    String? c = GetStorage().read("contacts");
    if (c == null || c == "") c = jsonEncode({'contacts': []});
    Map pC = jsonDecode(c);
    setState(() {
      contacts = pC["contacts"];
    });
  }

  @override
  void initState() {
    super.initState();
    gC();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 0),
          curve: Curves.decelerate,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Address",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24),
                ),
                const SizedBox(height: 24),
                const Row(
                  children: [
                    Text(
                      "Paste Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (String n) => address = n,
                  autofocus: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Wallet Address',
                  ),
                  style: const TextStyle(decoration: TextDecoration.none),
                ),
                const SizedBox(height: 8),
                Button(
                  title: "Continue",
                  backgroundColor: primaryColor,
                  fontColor: Colors.white,
                  onClick: () {
                    if (address.length != 42 || !address.contains("0x")) {
                      return Get.snackbar(
                          "Invalid Address", "Enter a valid wallet address",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: primaryColor);
                    }
                    Navigator.pop(context, address);
                  },
                ),
                const Divider(),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Text(
                      "Select Address",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 8),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (_, ind) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () =>
                              Navigator.pop(context, contacts[ind]['address']),
                          child: ListTile(
                            leading: RandomAvatar(contacts[ind]['address'],
                                height: 55, width: 55),
                            title: Text(contacts[ind]['name']),
                            subtitle: Text(contacts[ind]['address']),
                            trailing:
                                const Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          )),
    );
  }
}
