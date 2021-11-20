import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/screens/base_widget.dart';
import 'package:justorderuser/screens/explore/booking/review_booking.dart';
import 'package:provider/provider.dart';

class BookingHistoryDetails extends StatefulWidget {
  BookingHistoryDetails({Key? key}) : super(key: key);
  static const bookingHistoryRoute = '/BookingHistory';

  @override
  _BookingHistoryDetailsState createState() => _BookingHistoryDetailsState();
}

class _BookingHistoryDetailsState extends State<BookingHistoryDetails> {
  @override
  Widget build(BuildContext context) {
    var bookingId = ModalRoute.of(context)?.settings.arguments;
    var bookingDetail = Provider.of<HotelDataProvider>(context)
        .hotelBookings
        .firstWhere((element) => element.bookingId == bookingId);
    var hotel = Provider.of<HotelDataProvider>(context)
        .hotelData
        .firstWhere((element) => element.id == bookingDetail.hotelId);
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                hotel.hotelDetail.hotelImage,
                fit: BoxFit.cover,
              )),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 3, spreadRadius: 5)
                  ],
                  shape: BoxShape.circle),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
          ),
          Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.fromLTRB(
                  15, MediaQuery.of(context).size.height * 0.35, 15, 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              hotel.hotelDetail.hotelName,
                              style: GoogleFonts.anton(fontSize: 25),
                            ),
                            Text(
                              'Date of booking : ${DateFormat('yMMMd').format(bookingDetail.dateOfBooking)}',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              '** ${bookingDetail.roomtype} **',
                              style: TextStyle(fontSize: 17.5),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 7,
                                    )
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Check-In',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(DateFormat('yMMMd')
                                          .format(bookingDetail.checkin)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Check-Out',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(DateFormat('yMMMd')
                                          .format(bookingDetail.checkout)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildChip(
                                      'Rooms : ${bookingDetail.totalRooms}'),
                                  buildChip('Adults : ${bookingDetail.adults}'),
                                  buildChip('Children : ${bookingDetail.kids}'),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 7,
                                    )
                                  ]),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment Details',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Room Charge (per night)\nNumber of Nights\nRooms Booked\n\nSubtotal\nDiscount\nTotal Bill Amount\n\nBooking ID :\nPayment txn ID :\nPayment Status :',
                                      ),
                                      Text(
                                        '${bookingDetail.roomCharge}\n${bookingDetail.checkout.difference(bookingDetail.checkin).inDays} nights\n${bookingDetail.totalRooms}\n\n\$ ${bookingDetail.totalCharge - bookingDetail.discount}\n(-) \$ ${bookingDetail.discount}\n\$ ${bookingDetail.totalCharge}\n\n${bookingDetail.bookingId}\n \nPaid',
                                        textAlign: TextAlign.right,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => BaseWidget()),
                                (route) => false);
                          },
                          child: Text(
                            'Back to Home',
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget buildChip(String label) {
    return Chip(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        elevation: 2,
        backgroundColor: Colors.white,
        label: Text(label));
  }
}
