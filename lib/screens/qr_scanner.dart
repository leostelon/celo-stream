import 'dart:convert';
import 'dart:io';

import 'package:fantom/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;

  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text(
                      'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
                  : const Text('Scan a Fraxpay QR code'),
            ),
          )
        ],
      ),
    );
  }

  _onQRViewCreated(QRViewController controller) {
    this.controller = controller;

    controller.scannedDataStream.listen((scanData) {
      HapticFeedback.vibrate();
      if (scanData.code == null ||
          scanData.code == "" ||
          !scanData.code!.contains("address")) {
        Get.snackbar(
            "Invalid QR code.", "try scanning a QR code from Fraxpay App",
            backgroundColor: primaryColor, snackPosition: SnackPosition.BOTTOM);
      } else {
        try {
          Map data = jsonDecode(scanData.code!);
          if (data['address'].length != 42) {
            Get.snackbar(
                "Invalid QR code.", "try scanning a QR code from Fraxpay App",
                backgroundColor: primaryColor,
                snackPosition: SnackPosition.BOTTOM);
          } else {
            Get.offNamedUntil("/send", ModalRoute.withName('/index'),
                arguments: data['address']);
          }
        } catch (e) {
          Get.snackbar(
              "Invalid QR code.", "try scanning a QR code from Fraxpay App",
              backgroundColor: primaryColor,
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
