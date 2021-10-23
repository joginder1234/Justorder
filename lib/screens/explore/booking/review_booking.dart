import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/screens/explore/booking/add_card.dart';

class BookingReview extends StatefulWidget {
  final String imageUrl;
  final String hotelName;
  final double price;
  final String roomType;
  BookingReview(this.imageUrl, this.hotelName, this.price, this.roomType);

  @override
  _BookingReviewState createState() => _BookingReviewState();
}

class _BookingReviewState extends State<BookingReview> {
  DateTime checkinDate = DateTime.now();
  DateTime checkoutDate = DateTime.now().add(Duration(days: 1));
  int rooms = 1;
  int adults = 1;
  int children = 0;
  bool _isCouponApplied = false;

  increaseRooms() {
    setState(() {
      rooms++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Booking", style: TextStyle(color: Colors.black)),
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(widget.hotelName,
                              style: GoogleFonts.italianno(
                                  color: Colors.blueGrey,
                                  fontSize: 55,
                                  fontWeight: FontWeight.w500))),
                      Text(
                        widget.roomType,
                        style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.3,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        border:
                            Border.all(color: Colors.grey.shade200, width: 5),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade400, blurRadius: 5)
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 365)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 730)))
                              .then((value) {
                            setState(() {
                              checkinDate = value as DateTime;
                            });
                          });
                        },
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              children: [
                                Text(
                                  'Check-in',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  DateFormat('MMMd').format(checkinDate),
                                  style: GoogleFonts.anton(
                                    fontSize: 25,
                                  ),
                                )
                              ],
                            ))),
                    Container(
                      color: Colors.grey.shade500,
                      width: 2,
                      height: 50,
                    ),
                    GestureDetector(
                        onTap: () {
                          showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now()
                                      .subtract(Duration(days: 365)),
                                  lastDate:
                                      DateTime.now().add(Duration(days: 730)))
                              .then((value) {
                            setState(() {
                              checkoutDate = value as DateTime;
                            });
                          });
                        },
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: Column(
                              children: [
                                Text(
                                  'Check-out',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  DateFormat('MMMd').format(checkoutDate),
                                  style: GoogleFonts.anton(
                                    fontSize: 25,
                                  ),
                                )
                              ],
                            ))),
                  ],
                ),
              ),
              Wrap(
                runSpacing: 10,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Number of Rooms',
                        style: TextStyle(fontSize: 18),
                      ),
                      Chip(
                          backgroundColor: Colors.grey.shade200,
                          labelPadding: EdgeInsets.all(0),
                          label: Row(
                            children: [
                              roundButton(Icons.remove),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '$rooms',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    increaseRooms();
                                  },
                                  child: roundButton(Icons.add)),
                            ],
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Adults',
                        style: TextStyle(fontSize: 18),
                      ),
                      Chip(
                          backgroundColor: Colors.grey.shade200,
                          labelPadding: EdgeInsets.all(0),
                          label: Row(
                            children: [
                              roundButton(Icons.remove),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '0',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              roundButton(Icons.add),
                            ],
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Children',
                        style: TextStyle(fontSize: 18),
                      ),
                      Chip(
                          backgroundColor: Colors.grey.shade200,
                          labelPadding: EdgeInsets.all(0),
                          label: Row(
                            children: [
                              roundButton(Icons.remove),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '0',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              roundButton(Icons.add),
                            ],
                          )),
                    ],
                  )
                ],
              ),
              Divider(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Payment Method',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      TextButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => AddCardScreen()));
                          },
                          icon: Icon(Icons.add),
                          label: Text('Add', style: TextStyle(fontSize: 18)))
                    ],
                  ),
                  Container(
                    height: 50,
                    color: Colors.grey.shade100,
                    width: double.infinity,
                    child: Center(child: Text('No Payment Method added yet')),
                  )
                ],
              ),
              Divider(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.price} x ${(checkoutDate.difference(checkinDate.isBefore(checkoutDate) ? checkinDate : checkoutDate).inDays)} nights',
                        style: GoogleFonts.robotoCondensed(fontSize: 20),
                      ),
                      Text(
                        '\$${widget.price * (checkoutDate.difference(checkinDate.isBefore(checkoutDate) ? checkinDate : checkoutDate).inDays + (checkinDate == checkoutDate ? 1 : 0))}',
                        style: GoogleFonts.robotoCondensed(fontSize: 20),
                      )
                    ],
                  ),
                  _isCouponApplied
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _isCouponApplied = false;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade900,
                                    )),
                                Text('Applied Coupon\n10% Off')
                              ],
                            ),
                            Text(
                                '(-) \$${widget.price * (checkoutDate.difference(checkinDate.isBefore(checkoutDate) ? checkinDate : checkoutDate).inDays + (checkinDate == checkoutDate ? 1 : 0)) * 10 / 100}',
                                style:
                                    GoogleFonts.robotoCondensed(fontSize: 20))
                          ],
                        )
                      : TextButton(
                          onPressed: () {
                            setState(() {
                              _isCouponApplied = true;
                            });
                          },
                          child: Text(
                            'Add Coupon',
                            style: GoogleFonts.robotoCondensed(fontSize: 18),
                          ))
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Amount',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 25, fontWeight: FontWeight.w600)),
                  Text(
                      '\$${(widget.price * (checkoutDate.difference(checkinDate.isBefore(checkoutDate) ? checkinDate : checkoutDate).inDays + (checkinDate == checkoutDate ? 1 : 0)) - (_isCouponApplied ? widget.price * (checkoutDate.difference(checkinDate.isBefore(checkoutDate) ? checkinDate : checkoutDate).inDays + (checkinDate == checkoutDate ? 1 : 0)) * 10 / 100 : 0))}',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 25, fontWeight: FontWeight.w600)),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 15))),
                    onPressed: () {},
                    child: Text('Confirm Booking',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 18, fontWeight: FontWeight.w600))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container roundButton(IconData icon) {
    return Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(100)),
        child: Icon(icon, color: Colors.black, size: 20));
  }

  SizedBox dateBox(BuildContext context, String value, String date) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              date,
              style: GoogleFonts.anton(
                fontSize: 25,
              ),
            )
          ],
        ));
  }
}
