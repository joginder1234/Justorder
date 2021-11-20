import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/screens/base_widget.dart';
import 'package:justorderuser/screens/explore/booking/add_card.dart';

class BookingReview extends StatefulWidget {
  final String hoteId;
  final String imageUrl;
  final String hotelName;
  final double price;
  final String roomType;
  final int kids;
  final int adults;
  BookingReview(this.hoteId, this.imageUrl, this.hotelName, this.price,
      this.roomType, this.kids, this.adults);

  @override
  _BookingReviewState createState() => _BookingReviewState();
}

class _BookingReviewState extends State<BookingReview> {
  Map<String, dynamic> currentUser = {};
  @override
  void initState() {
    super.initState();

    loadUserDetails();
  }

  loadUserDetails() async {
    try {
      HttpWrapper.sendGetRequest(url: CURRENT_USER_DETAILS).then((value) {
        print(value['user']);
        Map<String, dynamic> user = {
          'name': '${value['user']['firstName']} ${value['user']['lastName']}',
          'userId': value['user']['_id']
        };
        setState(() {
          currentUser = user;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  DateTime checkinDate = DateTime.now();
  DateTime checkoutDate = DateTime.now().add(Duration(days: 1));
  int rooms = 1;
  int adults = 1;
  int children = 0;
  bool _isCouponApplied = false;

  @override
  Widget build(BuildContext context) {
    double adultRatio = adults / widget.adults;
    double childRatio = children / widget.kids;
    rooms = adults > widget.adults && children < widget.kids
        ? adultRatio.ceil()
        : adults < widget.adults && children > widget.kids
            ? childRatio.ceil()
            : adults > widget.adults && children > widget.kids
                ? (adultRatio.floor() + childRatio.floor() + 1)
                : adults == widget.adults || children == widget.kids
                    ? adultRatio.ceil() + childRatio.ceil()
                    : adults == widget.adults && children < widget.kids
                        ? 2
                        : adults == widget.adults && children > widget.kids
                            ? 1 + childRatio.ceil()
                            : adults > widget.adults && children == widget.kids
                                ? 1 + adultRatio.ceil()
                                : adults < widget.adults &&
                                        children == widget.kids
                                    ? 2
                                    : adults < widget.adults / 2.ceil() &&
                                            children < widget.kids / 2.ceil()
                                        ? 1
                                        : adults > widget.adults / 2.ceil() &&
                                                children >
                                                    widget.kids / 2.ceil()
                                            ? 2
                                            : 1;
    double total = (widget.price *
        ((checkoutDate
                .difference(checkinDate.isBefore(checkoutDate)
                    ? checkinDate
                    : checkoutDate)
                .inDays) +
            (checkinDate == checkoutDate ? 0 : 1)) *
        rooms);
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
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (rooms < 2) {
                                  } else {
                                    rooms--;
                                  }
                                });
                              },
                              icon: Icon(Icons.remove)),
                          Text(rooms.toString(),
                              style: TextStyle(fontSize: 18)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  rooms++;
                                });
                              },
                              icon: Icon(Icons.add)),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Adults',
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (adults < 2) {
                                  } else {
                                    adults--;
                                  }
                                });
                              },
                              icon: Icon(Icons.remove)),
                          Text(adults.toString(),
                              style: TextStyle(fontSize: 18)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  adults++;
                                });
                              },
                              icon: Icon(Icons.add)),
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Children',
                        style: TextStyle(fontSize: 18),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  if (children < 1) {
                                  } else {
                                    children--;
                                  }
                                });
                              },
                              icon: Icon(Icons.remove)),
                          Text(children.toString(),
                              style: TextStyle(fontSize: 18)),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  children++;
                                });
                              },
                              icon: Icon(Icons.add)),
                        ],
                      )
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
                        '\$${widget.price} x ${(checkoutDate.difference(checkinDate.isBefore(checkoutDate) ? checkinDate : checkoutDate).inDays) + (checkinDate == checkoutDate ? 0 : 1)} nights x $rooms rooms',
                        style: GoogleFonts.robotoCondensed(fontSize: 20),
                      ),
                      Text(
                        '\$$total',
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
                            Text('(-) \$${total * 10 / 100}',
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
                      '${total - (_isCouponApplied ? total * 10 / 100 : 0.00)}',
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
                    onPressed: () {
                      createOrder(total, true);
                    },
                    child: Text('Confirm and Pay',
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

  createOrder(double total, bool status) async {
    Map<String, dynamic> order = {
      'hotelName': widget.hotelName,
      'hotelId': widget.hoteId,
      'name': currentUser['name'],
      'userId': currentUser['userId'],
      'checkin': checkinDate.toString(),
      'checkout': checkoutDate.toString(),
      'roomtype': widget.roomType,
      'quantity': rooms.toString(),
      'adults': adults.toString(),
      'paymentStatus': status.toString(),
      'children': children.toString(),
      'discount': (_isCouponApplied ? total * 10 / 100 : 0.00).toString(),
      'charges':
          (total - (_isCouponApplied ? total * 10 / 100 : 0.00)).toString(),
    };

    try {
      await HttpWrapper.sendPostRequest(url: ADD_HOTEL_BOOKING, body: order)
          .then((value) {
        print('New Booking :: $value');
        CustomToast.showToast(value['message']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => BaseWidget()), (route) => false);
      });
    } catch (e) {
      print(e);
    }
  }
}
