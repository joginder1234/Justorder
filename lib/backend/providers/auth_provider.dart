import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  static getCurrentUser() async {
    try {
      var data = await HttpWrapper.sendGetRequest(url: CURRENT_USER_DETAILS);
      if (data['success'] == true) {
        return data['user'];
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future setToken(String token) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('x-access-token', token);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future removeToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('x-access-token');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> logIn(String email, String password) async {
    try {
      var data = await HttpWrapper.sendPostRequest(
        url: LOGIN,
        body: {"email": email, "password": password},
      );
      CustomToast.showToast(data['message']);
      if (data['success']) {
        await setToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      CustomToast.showToast(e.toString());
      return false;
    }
  }

  static Future<bool> singUp(var body) async {
    try {
      var data = await HttpWrapper.sendPostRequest(url: SIGNUP, body: body);
      CustomToast.showToast(data['message']);
      if (data['success']) {
        await setToken(data['token']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Function Error : $e');
      CustomToast.showToast(e.toString());
      return false;
    }
  }

  static Future<bool> currentUser() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    try {
      var data = await HttpWrapper.sendGetRequest(url: CURRENT_USER);
      if (data['success'] == true) {
        await setToken(data['token']);
        _preferences.setString('CurrentUserId', data['decoded']['_id']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future userDetails() async {
    try {
      var data = await HttpWrapper.sendGetRequest(url: CURRENT_USER_DETAILS);
      return data['user'];
    } catch (e) {
      return e;
    }
  }

  static Future updateUserDetails(var body) async {
    var data =
        await HttpWrapper.sendPostRequest(url: UPDATE_USER_DETAILS, body: body);
    return data['success'];
  }

  static changePasswords(var body) async {
    return HttpWrapper.sendPostRequest(url: CHANGE_PASSWORD, body: body);
  }
}
