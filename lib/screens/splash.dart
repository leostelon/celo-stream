import 'package:fantom/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final isUndefinedOrNull = null;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      String address = GetStorage().read("address") ?? "";
      await Future.delayed(const Duration(seconds: 2));
      if (address != isUndefinedOrNull && address != "") {
        Get.offAndToNamed("/index");
      } else {
        Get.offAndToNamed("/welcome");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("assets/logo.png"),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(
              width: (MediaQuery.sizeOf(context).width / 100) * 25,
              child: const Center(
                  child: LinearProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.white60,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
