import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class FlutterStripePayment {
  static Future createPaymentIntent(double amount, String currency, String name,
      String line1, String postal, String phone, String country) async {
    const url = "http://7e74-103-240-193-34.ngrok.io/create-payment-intent";
    http.Response response = await http.post(Uri.parse(url), body: {
      "amount": amount.toString(),
      "currency": currency,
      "description": "Royal Dhaba $name $phone $postal",
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
    const url = "http://7e74-103-240-193-34.ngrok.io/confirm-payment";

    http.Response response =
        await http.post(Uri.parse(url), body: {'data': data1});

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    }
    var data = json.decode(response.body);
    return data;
  }
}
