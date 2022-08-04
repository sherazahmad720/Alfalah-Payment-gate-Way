import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:jazz_cash_payment/web_page.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _refNoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]'),
                  ),
                ],
                controller: _amountController,
                decoration: const InputDecoration(
                  hintText: 'Enter amount',
                  labelText: 'Amount',
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _refNoController,
                      decoration: const InputDecoration(
                        hintText: 'Enter reference number',
                        labelText: 'Reference number',
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        _refNoController.text =
                            DateTime.now().millisecondsSinceEpoch.toString();
                      },
                      child: const Text('Auto Generate')),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: Text('Pay'),
                onPressed: () {
                  if (_amountController.text.isEmpty ||
                      _refNoController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all fields'),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebPage(
                            amount: _amountController.text,
                            refNo: _refNoController.text),
                      ),
                    );
                  }
                },
              ),
              // ElevatedButton(
              //     child: Text('tet'),
              //     onPressed: () {
              //       String key1 = 'W2U3KpprE9WvrC6r';
              //       String key2 = '6934608181191010';

              //       final key = encrypt.Key.fromUtf8(key1);
              //       final iv = encrypt.IV.fromUtf8(key2);
              //       final encrypter = encrypt.Encrypter(encrypt.AES(key,
              //           mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

              //       final data = encrypt.Encrypted(base64Decode(
              //           '91m4OUFkqkZDwovnZlM0NylVkHpRmziFfyHGpMrTEweo97m3sOibsvGEF3CnXsAkUq4P+VaQBPCbUKe174cFzOS9etnyinRB/v+6GlmcghCc1H0Rnt9I5tR9lK38S2OYN2pODa4XdIJJ8Njpgs4+BFZhfHztu4M+yUn/G8EgwmYdvN8HMreHXTpjyGa64+h2M27IXb8LvhXFKJnwWS09bnkS6iOkiIP8UX+dzl1lG5MICR3zNhAs+Br9GJjAVijESJwu04tmgXTL9BvUtcfVhg7YdzcHg6Fgm1vgasWkldO1JmWiWz431GZC8+wMrnkuNpGnbT8lWWkOst9EGsHlLn3cfFI6PJT7KY94q8B2zOSMGYe4H++xHxnYj6Y2Pf38l/AiXfVrL2Cd7UPKx4Y1REV8VIaaz6t+lS8ysnQTOIbGxDUgA+GNoKVVaJ9h6CfO75xfPmbj3w90U8PMjMURX3CIBmKHmbl7u6xUcQQMM7yW1vWjfYiZ/Mihto9+oCUMfplmP2j/xM80hmzQQfEHZT6ozhhwT5ZXJoQls8cZiGySbSnV64MWJaIKI2pJYaRE70Lft6OdEz6+tloWuvNmw5To31lKdGQL8J0YJOVIF/o='));
              //       final decrypted = encrypter.decrypt(data, iv: iv);

              //       print(decrypted.toString());
              //     }),
            ],
          ),
        ),
      ),
    );
  }

  void start() async {
    const platform = MethodChannel('com.flutter.payment');
    Map<String, String> data = {
      "price": "400000",
      "Jazz_MerchantID": "your merchant id",
      "Jazz_Password": "password",
      "Jazz_IntegritySalt": "Jazz_IntegritySalt",
      "paymentReturnUrl": "Jazz_IntegritySalt"
    };
    String value = "";

    try {
      value = await platform.invokeMethod("Print", data);
    } catch (e) {
      print(e);
    }

    print(value.toString());
  }

  payment() async {
    var digest;
    String pp_IsRegisteredCustomer = "No";
    String pp_ShouldTokenizedCardNumber = "No";
    String pp_CustomerID = "test";
    String pp_CustomerEmail = "test@test.com";
    String pp_CustomerMobile = "03222852628";

    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.now().add(Duration(days: 1)));
    String tre = "T" + dateandtime;
    String pp_Amount = "100";
    String pp_BillReference = "billRef";
    String pp_Description = "Description";
    String pp_CustomerCardNumber = "4111111111111111";
    String pp_CustomerCardExpiry = "52027";
    String pp_CustomerCardCVV = "123";
    String pp_Language = "EN";
    String pp_MerchantID = "MC46091";
    String pp_Password = "v1xzydw5x6";
    String pp_ReturnURL = "www.starshare.com/pay";
    String pp_ver = "1.1";
    String pp_TxnCurrency = "PKR";
    String pp_TxnDateTime = dateandtime.toString();
    String pp_TxnExpiryDateTime = dexpiredate.toString();
    String pp_TxnRefNo = tre.toString();
    String pp_TxnType = "MPAY";
    String ppmpf_1 = "03122036440";
    String IntegeritySalt = "uf9yx23ywd";
    String and = '&';
    // String superdata = IntegeritySalt +
    //     and +
    //     pp_Amount +
    //     and +
    //     pp_BillReference +
    //     and +
    //     pp_Description +
    //     and +
    //     pp_Language +
    //     and +
    //     pp_MerchantID +
    //     and +
    //     pp_Password +
    //     and +
    //     pp_ReturnURL +
    //     and +
    //     pp_TxnCurrency +
    //     and +
    //     pp_TxnDateTime +
    //     and +
    //     pp_TxnExpiryDateTime +
    //     and +
    //     pp_TxnRefNo +
    //     and +
    //     pp_TxnType +
    //     and +
    //     pp_ver +
    //     and +
    //     ppmpf_1;
    String superdata = pp_Amount +
        and +
        pp_BillReference +
        and +
        pp_CustomerCardCVV +
        and +
        pp_CustomerCardExpiry +
        and +
        pp_CustomerCardNumber +
        and +
        pp_CustomerEmail +
        and +
        pp_CustomerID +
        and +
        pp_CustomerMobile +
        and +
        pp_Description +
        and +
        pp_IsRegisteredCustomer +
        and +
        pp_MerchantID +
        and +
        pp_Password +
        and +
        pp_ShouldTokenizedCardNumber +
        and +
        pp_TxnCurrency +
        and +
        pp_TxnDateTime +
        and +
        pp_TxnExpiryDateTime +
        and +
        pp_TxnRefNo +
        and +
        pp_TxnType;
    var key = utf8.encode(IntegeritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = new Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    var url =
        // 'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction';
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/2.0/Purchase/PAY';

    var response = await http.post(Uri.parse(url), body: {
      "pp_IsRegisteredCustomer": pp_IsRegisteredCustomer,
      "pp_ShouldTokenizeCardNumber": pp_ShouldTokenizedCardNumber,
      "pp_CustomerID": pp_CustomerID,
      "pp_CustomerEmail": pp_CustomerEmail,
      "pp_CustomerMobile": pp_CustomerMobile,
      "pp_TxnType": pp_TxnType,
      "pp_TxnRefNo": pp_TxnRefNo,
      "pp_MerchantID": pp_MerchantID,
      "pp_Password": pp_Password,
      "pp_Amount": pp_Amount,
      "pp_TxnCurrency": pp_TxnCurrency,
      "pp_TxnDateTime": pp_TxnDateTime,
      "pp_TxnExpiryDateTime": pp_TxnExpiryDateTime,
      "pp_BillReference": pp_BillReference,
      "pp_Description": pp_Description,
      "pp_CustomerCardNumber": pp_CustomerCardNumber,
      "pp_CustomerCardExpiry": pp_CustomerCardExpiry,
      "pp_CustomerCardCvv": pp_CustomerCardCVV,
      "pp_SecureHash": sha256Result.toString(),
    });

    print("response=>");
    print(response.body);
    var jsonData = json.decode(response.body);
    print(jsonData);
  }
}
