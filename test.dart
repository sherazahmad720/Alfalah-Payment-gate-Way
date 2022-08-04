import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;

class WebPage extends StatefulWidget {
  const WebPage({Key? key}) : super(key: key);

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  String authToken = '';
  bool isLoading = false;
  bool success = true;
  String refNo = "1122";
  String amount = "1000";
  String channelId = "1001";
  String merchantId = "16775";
  String returnUrl = "www.yzsync.com";
  String storeId = "022189";
  String merchantUsername = "qupyhy";
  String merchantPassword = "M/lPD/8mB1ZvFzk4yqF7CA==";
  String merchatHash = "+Mw1zSDT/m2omh6lfqRgHOr8Y0rZmmpv";

  @override
  void initState() {
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
      body: Container(
          // child: isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     : !success
          //         ? const Center(child: Text('Something went wrong'))
          //         : InAppWebView(
          //             initialUrlRequest: URLRequest(
          //               url: Uri.parse(
          //                   "https://sandbox.bankalfalah.com/SSO/SSO/SSO"),
          //               method: 'POST',
          //               body: pageRedirectionData(),
          //               headers: {
          //                 'Content-Type': 'application/x-www-form-urlencoded',
          //                 'Host': 'sandbox.bankalfalah.com',
          //                 'Content-Length': '727',
          //               },
          //             ),
          //             onWebViewCreated: (controller) {},
          //             onLoadStart: (controller, url) {
          //               print('onLoadStart: $url');
          //             },
          //           ),
          ),
    );
  }

  Map getHandshakeData() {
    Map data = {
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

  Uint8List pageRedirectionData() {
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

    // var hash = makeHash(convertMapIntoStringForHash(data));
    // data['RequestHash'] = hash;
    print(data.toString());
    var dataForWeb = convertMapIntoStringForHash(data);
    print(dataForWeb);
    Uint8List encodedData = Uint8List.fromList(utf8.encode(dataForWeb));
    print(encodedData);
    return encodedData;
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
      // authToken = json['AuthToken'];
      print(authToken);
      setState(() {
        getRedirect();
        success = true;
        isLoading = false;
      });
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
    if (res.statusCode == 200) {
      var json = jsonDecode(res.body);
      // authToken = json['AuthToken'];
      print(authToken);
      setState(() {
        success = true;
        isLoading = false;
      });
    }
  }
}
