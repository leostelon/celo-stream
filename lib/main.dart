import 'package:fantom/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'themes.dart' as k;
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // transparent status bar
    systemNavigationBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App',
      initialRoute: '/',
      theme: k.themeData(),
      getPages: Routers.getRouters,
      unknownRoute: Routers.defaultPage,
    );
  }
}
