import 'dart:convert';

import 'package:fantom/components/button.dart';
import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddContactModal extends StatefulWidget {
  const AddContactModal({
    super.key,
  });

  @override
  State<AddContactModal> createState() => _AddContactModalState();
}

class _AddContactModalState extends State<AddContactModal> {
  bool loading = false;
  String name = "";
  String address = "";

  aC() async {
    if (name == "" || address == "") {
      return Get.snackbar("Fill details", "Please fill all the details!",
          backgroundColor: primaryColor, snackPosition: SnackPosition.BOTTOM);
    }
    if (!address.contains("0x") || address.length != 42) {
      return Get.snackbar("Invalid address", "Please add a valid address!",
          backgroundColor: primaryColor, snackPosition: SnackPosition.BOTTOM);
    }
    String? c = GetStorage().read("contacts");
    if (c == null || c == "") c = jsonEncode({'contacts': []});
    Map pC = jsonDecode(c);
    pC['contacts'].add({"name": name, "address": address});
    GetStorage().write("contacts", jsonEncode(pC));
    Navigator.pop(context);
    Get.snackbar("Added Contact", "Successfully added new contact🥳",
        backgroundColor: primaryColor, snackPosition: SnackPosition.BOTTOM);
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
                "Add Contact",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
              ),
              const SizedBox(height: 24),
              TextField(
                onChanged: (String n) => name = n,
                autofocus: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name',
                ),
                style: const TextStyle(decoration: TextDecoration.none),
              ),
              const SizedBox(height: 12),
              TextField(
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (String a) => address = a,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Wallet address',
                ),
                style: const TextStyle(decoration: TextDecoration.none),
              ),
              const SizedBox(height: 12),
              Button(
                title: "Add Contact",
                backgroundColor: primaryColor,
                fontColor: Colors.white,
                loading: loading,
                onClick: aC,
              )
            ],
          ),
        ),
      ),
    );
  }
}
