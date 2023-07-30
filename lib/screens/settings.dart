import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(children: [
        ListTile(
          title: const Text("Copy Mnemonic"),
          subtitle: const Text("Copy mnemonic to clipboard."),
          trailing: const Icon(Icons.logout_outlined),
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: GetStorage().read("mnemonic")));
            Get.snackbar("Copied!", "Mnemonic copied to clipboard.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: primaryColor);
          },
        ),
        ListTile(
          title: const Text("Copy Private Key"),
          subtitle: const Text("Copy private key to clipboard."),
          trailing: const Icon(Icons.logout_outlined),
          onTap: () {
            Clipboard.setData(
                ClipboardData(text: GetStorage().read("privateKey")));
            Get.snackbar("Copied!", "Private key copied to clipboard.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: primaryColor);
          },
        ),
        ListTile(
          title: Text(
            "Logout",
            style: TextStyle(color: Colors.red.shade600),
          ),
          subtitle: const Text("Logs out from current account."),
          trailing: Icon(
            Icons.logout_outlined,
            color: Colors.red.shade600,
          ),
          onTap: () {
            GetStorage().erase();
            Get.offAllNamed("/welcome");
          },
        ),
      ]),
    );
  }
}
