import 'dart:convert';

import 'package:http/http.dart' as http;

Future getTokenByAddress(String address) async {
  try {
    http.Response response = await http.get(
        Uri.parse("https://fanpay-api.daggle.xyz/tokens/$address"),
        headers: {"Content-Type": "application/json"});
    var fR = jsonDecode(response.body);
    return fR;
  } catch (e) {
    //
  }
}

Future getNFTByAddress(String address) async {
  try {
    http.Response response = await http.get(
        Uri.parse("https://fanpay-api.daggle.xyz/nfts/$address"),
        headers: {"Content-Type": "application/json"});
    var fR = jsonDecode(response.body);
    return fR['result'];
  } catch (e) {
    //
  }
}

Future getTokens() async {
  try {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.thegraph.com/subgraphs/name/superfluid-finance/protocol-v1-mumbai'));
    request.body =
        '''{"query":"query MyQuery {\\r\\n  streams(\\r\\n    where: {receiver: \\"0x4977f6e179901109b3075aedb9bfa08fd8d9ea8f\\", currentFlowRate_gt: \\"0\\"}\\r\\n  ) {\\r\\n    currentFlowRate\\r\\n    token {\\r\\n      symbol\\r\\n      decimals\\r\\n      name\\r\\n      id\\r\\n    }\\r\\n    sender {\\r\\n      id\\r\\n    }\\r\\n    receiver {\\r\\n      id\\r\\n    }\\r\\n    createdAtTimestamp\\r\\n  }\\r\\n}","variables":{}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      return jsonDecode(result)['data']['streams'];
    } else {
      print(response.reasonPhrase);
    }
  } catch (error) {
    //
    print(error);
  }
}
