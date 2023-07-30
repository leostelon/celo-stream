import 'package:fantom/components/Button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/logo.png"),
            ),
            const SizedBox(height: 40),
            const Text(
              "Welcome to FraxPay",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Fantom payments made easy⚡",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: [
                Button(
                  title: "Import Wallet",
                  onClick: () => Get.toNamed("/importwallet"),
                ),
                const SizedBox(height: 8),
                Button(
                  title: "Create Wallet",
                  backgroundColor: Colors.black87,
                  fontColor: Colors.white,
                  onClick: () => Get.toNamed("/createwallet"),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
