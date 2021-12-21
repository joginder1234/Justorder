import 'dart:developer';

import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';

class FunctionsProvider {
  static Future<List<dynamic>> getRestaurants() async {
    try {
      var restaurantData =
          await HttpWrapper.sendGetRequest(url: RESTAURANT_LISTS);

      if (restaurantData['success'] == true) {
        return restaurantData['restaurants'] as List;
      } else {
        CustomToast.showToast(restaurantData['message']);
        return [];
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      return [];
    }
  }

  static Future<List<dynamic>> loadCartItems() async {
    try {
      var cartData = await HttpWrapper.sendGetRequest(url: GET_CART_ITEM);
      if (cartData['success'] == true) {
        return cartData['carts'][0]['cartItems'];
      } else {
        CustomToast.showToast('Unable to load cart items, Try again !');
        return [];
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      return [];
    }
  }

  static Future<bool> deleteCartItems(String itemId, String cartId) async {
    try {
      var deleteResponse = await HttpWrapper.sendPostRequest(
          url: DELETE_CART_ITEMS,
          body: {'cartId': cartId, 'cartItemsId': itemId});

      if (deleteResponse['success'] == true) {
        return true;
      } else {
        CustomToast.showToast('Unable to delete item. Please try again!');
        return false;
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      return false;
    }
  }

  static Future<List<dynamic>> getHotelsList() async {
    try {
      var hotelData = await HttpWrapper.sendGetRequest(url: HOTEL_LISTS);
      if (hotelData['success'] == true) {
        var response = (hotelData['hotels'] as List);
        return response;
      } else {
        CustomToast.showToast(hotelData['message']);
        return [];
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      return [];
    }
  }

  static getallReviews(String hotelId) async {
    try {
      var reviews =
          await HttpWrapper.sendGetRequest(url: ALL_REVIEWS + '/$hotelId');

      if (reviews['success'] == true) {
        return reviews['reviews'];
      } else {
        CustomToast.showToast(reviews['message']);
        return null;
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
    }
  }

  static getRoomsList(String hotelId) async {
    try {
      var hotelRoomsData =
          await HttpWrapper.sendGetRequest(url: HOTEL_ROOMS_LIST + '/$hotelId');
      if (hotelRoomsData['success'] == true) {
        log(hotelRoomsData.toString());
        return hotelRoomsData['rooms'];
      } else {
        CustomToast.showToast(hotelRoomsData['message']);
        return null;
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
    }
  }
}
