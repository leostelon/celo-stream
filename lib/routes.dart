import 'package:fantom/screens/create_wallet.dart';
import 'package:fantom/screens/home.dart';
import 'package:fantom/screens/import_wallet.dart';
import 'package:fantom/screens/index.dart';
import 'package:fantom/screens/qr_scanner.dart';
import 'package:fantom/screens/recieve.dart';
import 'package:fantom/screens/send.dart';
import 'package:fantom/screens/settings.dart';
import 'package:fantom/screens/splash.dart';
import 'package:fantom/screens/transactions.dart';
import 'package:fantom/screens/welcome.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class Routers {
  static List<GetPage> getRouters = [
    GetPage(
      name: '/',
      page: () => const Splash(),
    ),
    GetPage(
      name: '/index',
      page: () => const IndexScreen(),
    ),
    GetPage(
      name: '/welcome',
      page: () => const Welcome(),
    ),
    GetPage(
      name: '/createwallet',
      page: () => const CreateWallet(),
    ),
    GetPage(
      name: '/importwallet',
      page: () => const ImportWallet(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/send',
      page: () => const SendScreen(),
    ),
    GetPage(
      name: '/recieve',
      page: () => const RecieveScreen(),
    ),
    GetPage(
      name: '/scanner',
      page: () => const QrScanner(),
    ),
    GetPage(
      name: '/transactions',
      page: () => const TransactionsScreen(),
    ),
    GetPage(
      name: '/settings',
      page: () => const Settings(),
    ),
  ];

  static final defaultPage = GetPage(
    name: '/notfound',
    page: () => const Scaffold(
      body: Center(
        child: Text('Check Route Name'),
      ),
    ),
  );
}
