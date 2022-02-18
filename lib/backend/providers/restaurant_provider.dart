import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/restaurant_details.dart';

class ResaurantsDataProvider with ChangeNotifier {
  List<Restaurant> allRestaurants = [];

  List myOrders = [];
  List foodOptions = [];

  List restReviews = [];

  List category = [];
  List menuList = [];
  List filterMenu = [];
  List cartItems = [];

  loadCartItems() async {
    try {
      var cartData = await HttpWrapper.sendGetRequest(url: GET_CART_ITEM);
      if (cartData['success'] == true) {
        cartItems = cartData['carts'][0]['cartItems'];
      }
    } catch (e) {
      log(e.toString());
    }
  }

  getRestaurants() async {
    try {
      var restaurantData =
          await HttpWrapper.sendGetRequest(url: RESTAURANT_LISTS);
      if (restaurantData['success'] == true) {
        var response = restaurantData['restaurants'] as List;
        allRestaurants = response.map((e) => Restaurant.fromJson(e)).toList();
        notifyListeners();

        checkData();
      } else {
        CustomToast.showToast(restaurantData['message']);
      }
    } catch (e) {
      print('Restaurant Function Error : $e');
    }
  }

  void checkData() {}

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

  static Future addtoCart(String restId) async {
    try {
      await HttpWrapper.sendGetRequest(url: GET_CART_ITEM).then((value) {
        print('value retrived');
        if (value['success'] == true) {
          print('value success true');
          if ((value['carts'] as List).isNotEmpty) {
            print('cart is not empty');
            (value['carts'][0]['cartItems'] as List).firstWhere((element) {
              if (element['restaurantId'] == restId) {
                print(
                    'Rest ID :: ${element['restaurantId']} and outRestId :: $restId');
                return true;
              } else {
                print('id does not match');
                return false;
              }
            });
          } else {
            print('cart is empty');
            return true;
          }
        } else {
          print('success false');
        }
      });
      // return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
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
}

class Quantity with ChangeNotifier {
  int orderQuantity = 0;

  Quantity() {
    HttpWrapper.sendGetRequest(url: GET_CART_ITEM).then((cart) {
      this.orderQuantity = (cart['carts'] as List).isEmpty
          ? 0
          : (cart['carts'][0]['cartItems'] as List).length;
      notifyListeners();
    });
  }

  increaseQuantity() {
    this.orderQuantity++;
    notifyListeners();
  }

  decreaseQuantity() {
    this.orderQuantity--;
    notifyListeners();
  }

  setQuantity(int i) {
    this.orderQuantity = i;
    notifyListeners();
  }
}
