import 'package:get/get.dart';
import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:fantom/utils/stream.dart';
import 'package:fantom/components/button.dart';

class BalanceModal extends StatefulWidget {
  final Map token;
  const BalanceModal({super.key, required this.token});

  @override
  State<BalanceModal> createState() => _BalanceModalState();
}

class _BalanceModalState extends State<BalanceModal> {
  String address = "";
  num rate = 0;
  List contacts = [];
  bool loading = false;

  cS() async {
    if (address == "" || rate <= 0) {
      return Get.snackbar("Fill details", "Please fill all the details",
          backgroundColor: primaryColor, snackPosition: SnackPosition.BOTTOM);
    }
    setState(() {
      loading = true;
    });
    await createStream(rate, address, widget.token['address']);
    setState(() {
      loading = false;
    });
    if (context.mounted) Navigator.of(context).pop();
    if (context.mounted) Navigator.of(context).pop();
    await Future.delayed(const Duration(seconds: 1));
    Get.snackbar(
        "Successfully created stream.", "It might take some time to reflect⏱️",
        snackPosition: SnackPosition.BOTTOM, backgroundColor: primaryColor);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: const Color.fromARGB(255, 27, 27, 27),
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
                    "Create Stream",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                  const SizedBox(height: 24),
                  // Address
                  const Row(
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
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
                    style: const TextStyle(
                        decoration: TextDecoration.none, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  // Flow Rate
                  const Row(
                    children: [
                      Text(
                        "Flow rate/day",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    onChanged: (String n) => rate = double.parse(n),
                    autofocus: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.token['symbol'],
                    ),
                    style: const TextStyle(
                        decoration: TextDecoration.none, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "Your balance: ${widget.token['balance'].toStringAsFixed(4)} ${widget.token['symbol']}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Button(
                    title: "Create",
                    backgroundColor: primaryColor,
                    fontColor: Colors.white,
                    onClick: () {
                      if (address.length != 42 || !address.contains("0x")) {
                        return Get.snackbar(
                            "Invalid Address", "Enter a valid wallet address",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: primaryColor);
                      }
                      cS();
                    },
                    loading: loading,
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            )),
      ),
    );
  }
}
