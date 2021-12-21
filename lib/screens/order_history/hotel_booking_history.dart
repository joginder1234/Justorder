import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/hotel_detail.dart';
import 'package:justorderuser/widgets/hotel_history_tile.dart';
import 'package:provider/provider.dart';

class HotelBookingHistory extends StatefulWidget {
  HotelBookingHistory({Key? key}) : super(key: key);

  @override
  _HotelBookingHistoryState createState() => _HotelBookingHistoryState();
}

class _HotelBookingHistoryState extends State<HotelBookingHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBookingHistory();
  }

  loadBookingHistory() async {
    try {
      HttpWrapper.sendGetRequest(url: GET_HOTEL_BOOKING).then((value) {
        setState(() {
          Provider.of<HotelDataProvider>(context, listen: false).hotelBookings =
              (value['bookings'] as List)
                  .map((e) => HotelBookingHistoryModel.fromJson(e))
                  .toList();
        });
      });
    } catch (e) {
      CustomToast.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var hotelBookings = Provider.of<HotelDataProvider>(context).hotelBookings;
    print(hotelBookings.length);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text('BOOKING HISTORY'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100,
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: hotelBookings.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (ctx, i) => HotelHistoryTile(
                  txnId: hotelBookings[i].txnId,
                  roomsCharge: hotelBookings[i].roomCharge,
                  bookingId: hotelBookings[i].bookingId,
                  hotelName: hotelBookings[i].name,
                  city: 'Hisar',
                  rooms: hotelBookings[i].totalRooms,
                  price: hotelBookings[i].roomCharge,
                  adults: hotelBookings[i].adults,
                  kids: hotelBookings[i].kids,
                  checkin: hotelBookings[i].checkin,
                  checkout: hotelBookings[i].checkout,
                )),
      ),
    );
  }
}
