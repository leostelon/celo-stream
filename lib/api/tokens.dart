import 'dart:convert';

import 'package:http/http.dart' as http;

Future getTokens(String address) async {
  try {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.thegraph.com/subgraphs/name/superfluid-finance/protocol-v1-celo-mainnet'));
    request.body =
        '''{"query":"query MyQuery {\\r\\n  accountTokenSnapshots(\\r\\n    where: {account: \\"$address\\", totalNetFlowRate_not: \\"0\\"}\\r\\n  ) {\\r\\n    id\\r\\n    token {\\r\\n      id\\r\\n      name\\r\\n      symbol\\r\\n      underlyingAddress\\r\\n      createdAtTimestamp\\r\\n      decimals\\r\\n    }\\r\\n    totalNetFlowRate\\r\\n  }\\r\\n}","variables":{}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      return jsonDecode(result)['data']['accountTokenSnapshots'];
    } else {
      // print(response.reasonPhrase);
    }
  } catch (error) {
    //
  }
}

Future getSenderStreamingTokens(String address) async {
  try {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.thegraph.com/subgraphs/name/superfluid-finance/protocol-v1-celo-mainnet'));
    request.body =
        '''{"query":"query MyQuery {\\r\\n  streams(\\r\\n    where: {receiver: \\"$address\\", currentFlowRate_gt: \\"0\\"}\\r\\n  ) {\\r\\n    currentFlowRate\\r\\n    token {\\r\\n      symbol\\r\\n      decimals\\r\\n      name\\r\\n      id\\r\\n    }\\r\\n    sender {\\r\\n      id\\r\\n    }\\r\\n    receiver {\\r\\n      id\\r\\n    }\\r\\n    createdAtTimestamp\\r\\n  }\\r\\n}","variables":{}}''';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      return jsonDecode(result)['data']['streams'];
    } else {
      // print(response.reasonPhrase);
    }
  } catch (error) {
    //
  }
}

Future getRecieverStreamingTokens(String address) async {
  try {
    var headers = {
      'Content-Type': 'application/json',
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.thegraph.com/subgraphs/name/superfluid-finance/protocol-v1-celo-mainnet'));
    request.body =
        '''{"query":"query MyQuery {\\r\\n  streams(\\r\\n    where: {sender: \\"$address\\", currentFlowRate_gt: \\"0\\"}\\r\\n  ) {\\r\\n    currentFlowRate\\r\\n    token {\\r\\n      symbol\\r\\n      decimals\\r\\n      name\\r\\n      id\\r\\n    }\\r\\n    sender {\\r\\n      id\\r\\n    }\\r\\n    receiver {\\r\\n      id\\r\\n    }\\r\\n    createdAtTimestamp\\r\\n  }\\r\\n}","variables":{}}''';
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      return jsonDecode(result)['data']['streams'];
    } else {
      // print(response.reasonPhrase);
    }
  } catch (error) {
    //
  }
}
