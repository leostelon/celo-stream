import 'dart:convert';

import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RecieveScreen extends StatefulWidget {
  const RecieveScreen({super.key});

  @override
  State<RecieveScreen> createState() => _RecieveScreenState();
}

class _RecieveScreenState extends State<RecieveScreen> {
  final address = GetStorage().read("address");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
        "Recieve Payment",
        style: TextStyle(color: Colors.black87),
      )),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Scan using Fraxpay App",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 24),
              QrImageView(
                data: jsonEncode({"address": address}),
                version: QrVersions.auto,
                size: 250.0,
              ),
              const SizedBox(height: 24),
              const Text(
                "Wallet Address",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: address));
                  Get.snackbar("Copied!", "Address copied to clipboard.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: primaryColor);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${address.substring(0, 6)} **** **** ${address.substring(38, 42)}",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.copy,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
