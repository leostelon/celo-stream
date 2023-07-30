import 'dart:convert';

import 'package:http/http.dart' as http;

Future getTransactionsByAccount(String add) async {
  try {
    http.Response response = await http.get(
      Uri.parse(
          "https://api.polygonscan.com/api?module=account&action=txlist&address=$add&sort=desc&apikey=8MZTGI8PHAA96KNYERZTSKXXYTFP44FFWQ"),
    );
    var fR = jsonDecode(response.body);
    return fR["result"];
  } catch (e) {
    //
  }
}
