import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpWrapper {
  static Future sendGetRequest(
      {required String url, bool exemptHeader = false}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var headers = {
        'x-access-token': sharedPreferences.getString('x-access-token') == null
            ? ''
            : sharedPreferences.getString('x-access-token') as String,
      };
      http.Response response =
          await http.get(Uri.parse(url), headers: !exemptHeader ? headers : {});
      var responseData = json.decode(response.body);
      print(responseData);
      return responseData;
    } catch (e) {
      log(e.toString());
      print('http Wrapper Error : $e with URL :: $url');
      return e;
    }
  }

  static Future sendPostRequest(
      {required String url,
      required var body,
      bool exemptHeader = false}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var headers = {
        'x-access-token': sharedPreferences.getString('x-access-token') == null
            ? ''
            : sharedPreferences.getString('x-access-token') as String,
      };
      http.Response response = await http.post(Uri.parse(url),
          body: body, headers: !exemptHeader ? headers : {});
      var responseData = json.decode(response.body.toString());
      return responseData;
    } catch (e) {
      print('HTTP Error : $e');
      return e;
    }
  }

  static Future sendDeleteRequest(
      {required String url, bool exemptHeader = false}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var headers = {
        'x-access-token': sharedPreferences.getString('x-access-token') == null
            ? ''
            : sharedPreferences.getString('x-access-token') as String,
      };
      http.Response response = await http.delete(Uri.parse(url),
          headers: !exemptHeader ? headers : {});
      var responseData = json.decode(response.body.toString());
      return responseData;
    } catch (e) {
      print('HTTP Error of Delete :: $e');
      return e;
    }
  }
}
