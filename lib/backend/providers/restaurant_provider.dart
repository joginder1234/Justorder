import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/rest_menu.dart';
import 'package:justorderuser/modals/restaurant_details.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResaurantsDataProvider with ChangeNotifier {
  List<Restaurant> _allRestaurants = [];
  List<Restaurant> get restaurantsList => _allRestaurants;

  List restReviews = [];

  List category = [];
  List menuList = [];
  List filterMenu = [];

  getRestaurants() async {
    try {
      var restaurantData =
          await HttpWrapper.sendGetRequest(url: RESTAURANT_LISTS);
      if (restaurantData['success'] == true) {
        var response = restaurantData['restaurants'] as List;
        var data = response.map((e) => Restaurant.fromJson(e)).toList();
        _allRestaurants.addAll(data);
        notifyListeners();

        checkData();
      } else {
        CustomToast.showToast(restaurantData['message']);
      }
    } catch (e) {
      print('Restaurant Function Error : $e');
    }
  }

  void checkData() {
    print('Data Check :: $_allRestaurants');
    print('Single Restaurant :: ${_allRestaurants[0].restaurantName}');
  }

  loadMenuItems(String restId) async {
    try {
      var allMenu =
          await HttpWrapper.sendGetRequest(url: RESTAURANT_MENU + '/$restId');
      if (allMenu['success'] == true) {
        print('All Menu :: $allMenu');
      }
    } catch (e) {
      print(e);
    }
  }

  getallReviews(String restId) async {
    try {
      var reviews =
          await HttpWrapper.sendGetRequest(url: ALL_REVIEWS + '/$restId');

      if (reviews['success'] == true) {
        restReviews = reviews['reviews'];
        notifyListeners();
        print('Total Reviews Saved :: ${restReviews.length}');
      } else {
        CustomToast.showToast(reviews['message']);
      }
    } catch (e) {
      print('function Error : $e');
    }
  }

  loadMenuCategory(String restId) async {
    try {
      var categories = await HttpWrapper.sendGetRequest(
          url: RESTAURANT_MENU_CAT + '/$restId');
    } catch (e) {
      print('menu Error :: $e');
    }
  }

  Future<bool> addtoCart(String restId) async {
    try {
      var checkCartItems = await HttpWrapper.sendGetRequest(url: GET_CART_ITEM);
      if (checkCartItems['success'] == true) {
        print('Data Fatch Success');
        if ((checkCartItems['carts'] as List).length > 0) {
          print('Length > 0');
          (checkCartItems['carts'] as List).firstWhere((element) {
            print('check Element Id :: ${element['resturantId']} and $restId');
            if (element['resturantId'] == restId) {
              print('Id Match SuccessFull');
              return true;
            } else {
              print('Id Does Not Matched');
              return false;
            }
          });
        } else {
          print('Length = 0');
          return true;
        }
      }
    } catch (e) {}
    return false;
  }

  addItemToCart(Map<String, dynamic> dataMap, String restId) async {
    try {
      var checkCartItems = await HttpWrapper.sendGetRequest(url: GET_CART_ITEM);
      if (checkCartItems['success'] == true) {
        print('Item Fatch Complete');
        if ((checkCartItems['carts'] as List).length > 0) {
          print('Item Length Check Complete');
          (checkCartItems['carts'] as List).forEach((e) {
            print('match ID :: ${e['resturantId']} and $restId');
            if (e['resturantId'] == restId) {
              print('Id Matched and allowed');
              var cartResponse =
                  HttpWrapper.sendPostRequest(url: ADD_TO_CART, body: dataMap);
            } else {
              CustomToast.showToast('Please complete previous order first');
            }
          });
        } else {
          var cartResponse =
              HttpWrapper.sendPostRequest(url: ADD_TO_CART, body: dataMap);
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  // setRestaurantList(Restaurant data) {
  //   this.allRestaurants.add(data);
  //   notifyListeners();
  // }
}
