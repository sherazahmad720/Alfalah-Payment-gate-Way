import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class WebPage extends StatefulWidget {
  const WebPage({Key? key, required this.amount, required this.refNo})
      : super(key: key);
  final String amount;
  final String refNo;

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  String authToken = '';
  bool isLoading = false;
  bool success = true;
  String refNo = "";
  String amount = "";
  String channelId = "1001";
  String merchantId = "16775";
  String returnUrl = "www.yzsync.com";
  String storeId = "022189";
  String merchantUsername = "qupyhy";
  String merchantPassword = "M/lPD/8mB1ZvFzk4yqF7CA==";
  String merchatHash = "+Mw1zSDT/m2omh6lfqRgHOr8Y0rZmmpv";
  String url = "https://sandbox.bankalfalah.com/SSO/SSO/SSO";
  bool isWebLoading = false;
  bool PaymentDone = false;
  bool paymentSuccess = false;

  @override
  void initState() {
    refNo = widget.refNo;
    amount = widget.amount;
    super.initState();
    isLoading = true;
    getAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Page'),
      ),
      body: Stack(
        children: [
          Container(
            child: PaymentDone
                ? const Center(
                    child: Text('Payment confirming\nPlease wait...'))
                : isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : !success
                        ? const Center(child: Text('Something went wrong'))
                        : InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: Uri.parse(url),
                              // method: 'POST',
                              // body:
                              //     Uint8List.fromList((pageRedirectionData()).codeUnits),
                              // body: pageRedirectionData(),
                              // headers: {
                              //   'Content-Type': 'application/x-www-form-urlencoded',
                              //   'Host': 'sandbox.bankalfalah.com',
                              //   'Content-Length': '727',
                              // },
                            ),
                            onWebViewCreated: (controller) {},
                            onLoadStart: (controller, url) {
                              setState(() {
                                isWebLoading = true;
                              });
                              print('onLoadStart: $url');
                            },
                            onLoadStop: (controller, url) {
                              if (url!.pathSegments
                                  .contains('www.yzsync.com')) {
                                setState(() {
                                  PaymentDone = true;
                                });
                              }
                              setState(() {
                                isWebLoading = false;
                              });
                              print('onLoadStop: $url');
                            },
                            onLoadError: (controller, url, val, error) {
                              setState(() {
                                isWebLoading = false;
                              });
                              print('onLoadError: $url, $error');
                            },
                          ),
          ),
          if (isWebLoading)
            const Center(
              child: Text('Payment is processing\nPlease wait...'),
            ),
        ],
      ),
    );
  }

  Map getHandshakeData() {
    Map data = {
      "HS_RequestHash": '',
      "HS_IsRedirectionRequest": "0",
      "HS_ChannelId": channelId,
      "HS_ReturnURL": returnUrl,
      "HS_MerchantId": merchantId,
      "HS_StoreId": storeId,
      "HS_MerchantHash": merchatHash,
      "HS_MerchantUsername": merchantUsername,
      "HS_MerchantPassword": merchantPassword,
      "HS_TransactionReferenceNumber": refNo,
    };
    var hash = makeHash(convertMapIntoStringForHash(data));
    data['HS_RequestHash'] = hash;
    return data;
  }

  Map pageRedirectionData2() {
    Map data = {
      "AuthToken": authToken,
      "RequestHash": '',
      "ChannelId": channelId,
      "Currency": "PKR",
      "IsBIN": "0",
      "ReturnURL": returnUrl,
      "MerchantId": merchantId,
      "StoreId": storeId,
      "MerchantHash": merchatHash,
      "MerchantUsername": merchantUsername,
      "MerchantPassword": merchantPassword,
      "TransactionTypeId": "3",
      "TransactionReferenceNumber": refNo,
      "TransactionAmount": amount,
    };

    var hash = makeHash(convertMapIntoStringForHash(data));
    data['RequestHash'] = hash;
    return data;
  }

  pageRedirectionData() {
    Map data = {
      "AuthToken": authToken,
      "RequestHash": '',
      "ChannelId": channelId,
      "Currency": "PKR",
      "IsBIN": "0",
      "ReturnURL": returnUrl,
      "MerchantId": merchantId,
      "StoreId": storeId,
      "MerchantHash": merchatHash,
      "MerchantUsername": merchantUsername,
      "MerchantPassword": merchantPassword,
      "TransactionTypeId": "3",
      "TransactionReferenceNumber": refNo,
      "TransactionAmount": amount,
    };

    var hash = makeHash(convertMapIntoStringForHash(data));
    data['RequestHash'] = hash;
    print(data.toString());
    var dataForWeb = convertMapIntoStringForHash(data);
    print(dataForWeb);
    // Uint8List encodedData = Uint8List.fromList(utf8.encode(dataForWeb));
    // print(encodedData);
    // return encodedData;
    return dataForWeb;
  }

  String convertMapIntoStringForHash(Map map) {
    String data = '';
    map.forEach((key, value) {
      data += key + '=' + value + '&';
    });
    List data2 = data.split('');
    data2.removeLast();
    String data3 = data2.join();
    return data3;
  }

  String makeHash(String data) {
    String key1 = 'W2U3KpprE9WvrC6r';
    String key2 = '6934608181191010';

    final key = encrypt.Key.fromUtf8(key1);
    final iv = encrypt.IV.fromUtf8(key2);
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
    // return 'M4M+gedhnifrwXAZFZm/NibI98PcaqCx8q6S7YCGvpmNBT/tPQgaxuRpb50AB5uJnzaS7vEL77lKaq4oz6oKFh1oYKryQr26f1DBKbAgxTKprStTgs/hEp06c44x89MD54/22kzPD67M/RS/18CZ7Zc78DUS75Iq7wERax/47UpO2bkMmHoLEne5o0N4OdmrvG50UIYUsTCnE2h5JbKJjEHB0hUKv3cuHM+AeIYZqz5iJ7jnA9Mc2nk3jEoTRBRwUkm8UIHtgaCfybm3kYAremBxWhKimu2QG4c9XvEZeG3sVd2N88zYzSF6G6TmIGRw7qSoaDC8GNYVIl4VhI3wVEkj4u8obqL1Gb/8UdacLiaeVED4fzJtaIXzReL/5WgsnYKZHE/fxJAwXXKf3LjEAg==';
  }

  getAuthToken() async {
    var res =
        await http.post(Uri.parse("https://sandbox.bankalfalah.com/HS/HS/HS"),
            body: getHandshakeData(),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
            },
            encoding: Encoding.getByName('utf-8'));
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      authToken = json['AuthToken'];
      print(authToken);
      if (authToken.isNotEmpty) getRedirect();
    }
  }

  getRedirect() async {
    var res = await http.post(
        Uri.parse("https://sandbox.bankalfalah.com/SSO/SSO/SSO"),
        body: pageRedirectionData2(),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        encoding: Encoding.getByName('utf-8'));
    print(res.body);
    getLink(res.body);
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      // authToken = json['AuthToken'];
      print(authToken);
      setState(() {
        success = true;
        isLoading = false;
        isWebLoading = true;
      });
    }
  }

  getLink(String body) {
    RegExp exp = RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

    Iterable<RegExpMatch> matches = exp.allMatches(body);

    matches.forEach((match) {
      print(body.substring(match.start, match.end));
      url = body.substring(match.start, match.end);
    });
    setState(() {
      success = true;
      isLoading = false;
    });
  }
}
