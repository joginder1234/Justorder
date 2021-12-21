import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/screens/order_history/booking_history_details.dart';

class HotelHistoryTile extends StatefulWidget {
  String bookingId;
  String hotelName;
  String city;
  int rooms;
  double price;
  int adults;
  int kids;
  DateTime checkin;
  double roomsCharge;
  String txnId;
  DateTime checkout;

  HotelHistoryTile(
      {Key? key,
      required this.bookingId,
      required this.hotelName,
      required this.city,
      required this.rooms,
      required this.price,
      required this.adults,
      required this.kids,
      required this.checkin,
      required this.roomsCharge,
      required this.txnId,
      required this.checkout})
      : super(key: key);

  @override
  _HotelHistoryTileState createState() => _HotelHistoryTileState();
}

class _HotelHistoryTileState extends State<HotelHistoryTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
            BookingHistoryDetails.bookingHistoryRoute,
            arguments: widget.bookingId);
      },
      child: Container(
        height: 180,
        child: Stack(
          children: [
            Card(
              margin: EdgeInsets.only(top: 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 35, 15, 10),
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.hotelName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          widget.city,
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bed,
                              color: Theme.of(context).buttonColor,
                            ),
                            Text('${widget.rooms} Rooms'),
                          ],
                        ),
                        Text(
                          '\$ ${widget.price}',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: Theme.of(context).buttonColor,
                            ),
                            Text('${widget.adults} Adults'),
                            Text('${widget.kids} Kids'),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                    side: BorderSide(color: Colors.grey.shade100, width: 10),
                    backgroundColor: Theme.of(context).buttonColor,
                    padding: EdgeInsets.all(10),
                    label: Text(
                      '${DateFormat('MMMd').format(widget.checkin)} - ${DateFormat('MMMd').format(widget.checkout)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
