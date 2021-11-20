import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/hotel_detail.dart';
import 'package:justorderuser/modals/rooms_details.dart';

class HotelDataProvider with ChangeNotifier {
  List<Hotel> hotelData = [];

  List<RoomsData> roomsList = [];

  List reviewsList = [];

  List<HotelBookingHistoryModel> hotelBookings = [];

  getHotelsList() async {
    try {
      var hotelData = await HttpWrapper.sendGetRequest(url: HOTEL_LISTS);
      if (hotelData['success'] == true) {
        hotelData = (hotelData['hotels'] as List)
            .map((e) => Hotel.fromJson(e))
            .toList();
      } else {
        CustomToast.showToast(hotelData['message']);
      }
    } catch (e) {
      print('Hotel Function Error : $e');
    }
  }

  setHotelData(Hotel data) {
    this.hotelData.add(data);
    notifyListeners();
  }

  setRoomsData(RoomsData data) {
    roomsList.clear();
    this.roomsList.add(data);
    notifyListeners();
  }

  setreviewList(List reviews) {
    this.reviewsList = reviews;
    notifyListeners();
  }
}
