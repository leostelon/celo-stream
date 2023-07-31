import 'dart:convert';

import 'package:http/http.dart' as http;

Future getTransactionsByAccount(String add) async {
  try {
    http.Response response = await http.get(
      Uri.parse(
          "https://api.celoscan.io/api?module=account&action=txlist&address=$add&sort=desc&apikey=MZ78JFG7CT5UFGU9QKA2W65EJQVHT7B2NG"),
    );
    var fR = jsonDecode(response.body);
    return fR["result"];
  } catch (e) {
    //
  }
}
