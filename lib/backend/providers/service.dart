import 'package:http/http.dart' as http;
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';

class ServiceProvider {
  static otherServiceList() async {
    try {
      var response = await HttpWrapper.sendGetRequest(url: SERVICE_LISTS);
      return response;
    } catch (e) {
      print(e);
      return [];
    }
  }

  static otherServiceSublist() async {
    try {
      var response = await HttpWrapper.sendGetRequest(url: SERVICE_SUBLISTS);
      return response;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
