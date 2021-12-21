import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlutterStripePayment {
  static Future createPaymentIntent(double amount, String currency, String name,
      String line1, String postal, String phone, String country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const url = PAYMENT_INTENT;
    var headers = {
      'x-access-token': prefs.getString('x-access-token') == null
          ? ''
          : prefs.getString('x-access-token') as String,
    };

    http.Response response =
        await http.post(Uri.parse(url), headers: headers, body: {
      "amount": amount.toString(),
      "currency": currency,
      "description": "JustOrder $name $phone $postal",
      "name": name,
      "line1": line1,
      "postal_code": postal,
      "country": country,
      "phone": phone
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('Response Body success :: $data');
      return data['paymentIntent'];
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception(json.decode(response.body)['message'].toString());
    }
  }

  static Future getTransactions(dynamic data1) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    const url = GET_TRANSACTION;

    var headers = {
      'x-access-token': prefs.getString('x-access-token') == null
          ? ''
          : prefs.getString('x-access-token') as String,
    };
    http.Response response = await http
        .post(Uri.parse(url), headers: headers, body: {'data': data1});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    }
    var data = json.decode(response.body);
    return data;
  }
}
