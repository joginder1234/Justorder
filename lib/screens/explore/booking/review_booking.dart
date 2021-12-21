import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/services/paymentservice.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/address.dart';
import 'package:justorderuser/modals/hotel_detail.dart';
import 'package:justorderuser/screens/base_widget.dart';
import 'package:justorderuser/screens/explore/booking/add_card.dart';
import 'package:justorderuser/screens/order_history/booking_history_details.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class BookingReview extends StatefulWidget {
  final String hoteId;
  final String hotelName;
  final double price;
  final String roomType;
  final int kids;
  final int adults;
  BookingReview(this.hoteId, this.hotelName, this.price, this.roomType,
      this.kids, this.adults);

  @override
  _BookingReviewState createState() => _BookingReviewState();
}

class _BookingReviewState extends State<BookingReview> {
  Map<String, dynamic> currentUser = {};
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  Map<String, dynamic> addressOfUser = {};

  String line1 = '';
  String city = '';
  String state = '';
  String contact = '';
  String postal = '';
  String country = '';

  int val = 1;

  String transactionId = '';
  int retryTime = 3;

  String id = '';

  bool loading = false;

  @override
  void initState() {
    super.initState();
    getUserAddress();
    loadUserDetails();
  }

  loadUserDetails() async {
    try {
      HttpWrapper.sendGetRequest(url: CURRENT_USER_DETAILS).then((value) {
        print(value['user']);
        Map<String, dynamic> user = {
          'name': '${value['user']['firstName']} ${value['user']['lastName']}',
          'address': value['user']['address'],
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

  addUserAddress() async {
    try {
      Map<String, dynamic> userAddress = {
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'postcode': _postalController.text.trim(),
        'country': _countryController.text.trim(),
      };
      var response = await HttpWrapper.sendPostRequest(
          url: ADD_USER_ADDRESS, body: userAddress);
      if (response['success'] == true) {
        await getUserAddress();
        setState(() {
          loading = false;
        });
        Navigator.of(context).pop();
      } else {
        CustomToast.showToast('Unable to add address, try again!');
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  getUserAddress() async {
    try {
      await HttpWrapper.sendGetRequest(url: GET_USER_ADDRESS).then((address) {
        if (address['success'] == true) {
          print('MyAddress :: $address');
          var ad = address['detailRes'][0];
          print(ad);
          Map<String, dynamic> data = {
            'address': ad['address'],
            'city': ad['city'],
            'postcode': ad['postcode'],
            'country': ad['country'],
          };
          setState(() {
            addressOfUser = data;
            _addressController.text = ad['address'];
            _cityController.text = ad['city'];
            _postalController.text = ad['postcode'];
            _countryController.text = ad['country'];
          });
        }
      });
    } catch (e) {
      CustomToast.showToast(e.toString());
    }
  }

  updateAddress() async {
    try {
      Map<String, dynamic> userAddress = {
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'postcode': _postalController.text.trim(),
        'country': _countryController.text.trim(),
      };
      var response = await HttpWrapper.sendPostRequest(
          url: UPDATE_USER_ADDRESS, body: userAddress);
      if (response['success'] == true) {
        getUserAddress();
        setState(() {
          loading = false;
        });
        Navigator.of(context).pop();
      } else {
        CustomToast.showToast('Unable to Update your request, try again!');
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      setState(() {
        loading = false;
      });
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
    // double adultRatio = adults / widget.adults;
    // double childRatio = children / widget.kids;
    // rooms = adults > widget.adults && children < widget.kids
    //     ? adultRatio.ceil()
    //     : adults < widget.adults && children > widget.kids
    //         ? childRatio.ceil()
    //         : adults > widget.adults && children > widget.kids
    //             ? (adultRatio.floor() + childRatio.floor() + 1)
    //             : adults == widget.adults || children == widget.kids
    //                 ? adultRatio.ceil() + childRatio.ceil()
    //                 : adults == widget.adults && children < widget.kids
    //                     ? 2
    //                     : adults == widget.adults && children > widget.kids
    //                         ? 1 + childRatio.ceil()
    //                         : adults > widget.adults && children == widget.kids
    //                             ? 1 + adultRatio.ceil()
    //                             : adults < widget.adults &&
    //                                     children == widget.kids
    //                                 ? 2
    //                                 : adults < widget.adults / 2.ceil() &&
    //                                         children < widget.kids / 2.ceil()
    //                                     ? 1
    //                                     : adults > widget.adults / 2.ceil() &&
    //                                             children >
    //                                                 widget.kids / 2.ceil()
    //                                         ? 2
    //                                         : 1;
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
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text(widget.hotelName,
                              style: GoogleFonts.italianno(
                                  color: Color(0XFF0F2C67),
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
                                    color: Color(0XFF0F2C67),
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
                                    color: Color(0XFF0F2C67),
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                color: Colors.grey.shade100,
                width: MediaQuery.of(context).size.width,
                height: 130,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Address :',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        addressOfUser.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Text('No Address Added')],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addressOfUser['address'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade900),
                                  ),
                                  Text(
                                    addressOfUser['city'] +
                                        ' ${addressOfUser['postcode']}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade900),
                                  ),
                                  Text(
                                    addressOfUser['country'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.grey.shade900),
                                  ),
                                ],
                              )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              addressOfUser.isEmpty
                                  ? showAddressDialog(context)
                                  : null;
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(
                                  color: addressOfUser.isEmpty
                                      ? Colors.blue
                                      : Colors.grey.shade500),
                            )),
                        TextButton(
                            onPressed: () {
                              addressOfUser.isEmpty
                                  ? null
                                  : showAddressDialog(context);
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                  color: addressOfUser.isNotEmpty
                                      ? Colors.blue
                                      : Colors.grey.shade500),
                            )),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.grey.shade200, blurRadius: 10)
                ]),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: (MediaQuery.of(context).size.width - 50) * 0.5,
                      child: RadioListTile(
                          activeColor: Theme.of(context).buttonColor,
                          title: Text('COD'),
                          value: 1,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = int.parse('$value').toInt();
                            });
                          }),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: (MediaQuery.of(context).size.width - 50) * 0.5,
                      child: RadioListTile(
                          activeColor: Theme.of(context).buttonColor,
                          title: Text('Card'),
                          value: 2,
                          groupValue: val,
                          onChanged: (value) {
                            setState(() {
                              val = int.parse('$value').toInt();
                            });
                          }),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
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
                            style: GoogleFonts.robotoCondensed(
                                fontSize: 18, color: Colors.red),
                          ))
                ],
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).buttonColor),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 15))),
            onPressed: () async {
              setState(() {
                loading = true;
              });
              if (addressOfUser.isEmpty) {
                CustomToast.showToast('Please add your address to continue');
                setState(() {
                  loading = false;
                });
              } else if (val == 1) {
                createOrder(total, true);
              } else {
                try {
                  var paymentResponse =
                      await FlutterStripePayment.createPaymentIntent(
                          (total -
                              (_isCouponApplied ? total * 10 / 100 : 0.00)),
                          'INR',
                          'Joginder',
                          '$line1, $city, $state',
                          postal,
                          contact,
                          country);
                  await initPaymentSheet(paymentResponse);
                  await Stripe.instance.presentPaymentSheet();
                  await getTransactionResponse(context, paymentResponse)
                      .then((value) {
                    if (value) {
                      createOrder(total, true);
                    }
                  });
                } catch (e) {
                  print('error :: ${e}');
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    loading = false;
                  });
                }
              }
            },
            child: loading
                ? Container(
                    height: 21,
                    width: 21,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                    ),
                  )
                : Text(
                    'CONFIRM AND PAY (\$${total - (_isCouponApplied ? total * 10 / 100 : 0.00)})',
                    style: GoogleFonts.robotoCondensed(
                        fontSize: 20, fontWeight: FontWeight.w500))),
      ),
    );
  }

  TextField buildtextField(String hint, TextEditingController cont) {
    return TextField(
      controller: cont,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          fillColor: Colors.grey.shade200,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(20)),
          hintText: hint),
    );
  }

  Future<dynamic> showAddressDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) => SimpleDialog(
              contentPadding: EdgeInsets.all(15),
              title: Text('Choose your address'),
              children: [
                buildtextField('Address', _addressController),
                const SizedBox(
                  height: 10,
                ),
                buildtextField('City', _cityController),
                const SizedBox(
                  height: 10,
                ),
                buildtextField('PostalCode', _postalController),
                const SizedBox(
                  height: 10,
                ),
                buildtextField('Country', _countryController),
                const SizedBox(
                  height: 20,
                ),
                loading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).buttonColor,
                            backgroundColor: Colors.transparent),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton(
                              style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.all(Size(110, 40))),
                              onPressed: () {
                                setState(() {
                                  TextEditingController().clear();
                                });
                              },
                              child: Text(
                                'CANCEL',
                                style: TextStyle(fontSize: 18),
                              )),
                          ElevatedButton(
                              style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.all(Size(110, 40))),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });

                                addressOfUser.isEmpty
                                    ? addUserAddress()
                                    : updateAddress();
                              },
                              child: Text(
                                'SAVE',
                                style: TextStyle(fontSize: 18),
                              ))
                        ],
                      )
              ],
            ));
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

  Future initPaymentSheet(dynamic _paymentSheetData) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      applePay: true,
      googlePay: true,
      style: ThemeMode.dark,
      testEnv: true,
      merchantCountryCode: 'IN',
      merchantDisplayName: 'Royal Dhaba',
      customerId: _paymentSheetData['customer'],
      paymentIntentClientSecret: _paymentSheetData['client_secret'],
      customerEphemeralKeySecret: _paymentSheetData['ephemeralKey'],
    ));
  }

  Future<bool> getTransactionResponse(
      BuildContext context, dynamic _paymentSheetData) async {
    var value =
        await FlutterStripePayment.getTransactions(_paymentSheetData['id']);
    if (value['success'] == true) {
      setState(() {
        transactionId = value['paymentIntents']['id'];
      });
      print('transaction Value :: $transactionId');

      return true;
    } else {
      if (retryTime == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: const Text(
            'Unable to preocess your payment! Please make a fresh payment',
          ),
          action: SnackBarAction(
              label: 'OK',
              onPressed: () {
                setState(() {
                  loading = false;
                });
              }),
        ));
      } else {
        setState(() {
          retryTime--;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            value['message'].toString(),
          ),
          action: SnackBarAction(
              label: 'Try Again!',
              onPressed: () {
                getTransactionResponse(context, _paymentSheetData);
              }),
        ));
      }
      return false;
    }
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

  loadBookingHistory() async {
    try {
      await HttpWrapper.sendGetRequest(url: GET_HOTEL_BOOKING).then((value) {
        print('Data Fatched :: $value');
        setState(() {
          Provider.of<HotelDataProvider>(context, listen: false).hotelBookings =
              (value['bookings'] as List)
                  .map((e) => HotelBookingHistoryModel.fromJson(e))
                  .toList();
          Navigator.of(context).pushNamedAndRemoveUntil(
              BookingHistoryDetails.bookingHistoryRoute, (route) => false,
              arguments: id);
        });
      });
    } catch (e) {
      CustomToast.showToast(e.toString());
    }
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
      'roomsCharge': widget.price.toString(),
      'paymentStatus': status.toString(),
      'children': children.toString(),
      'txnId': transactionId.toString(),
      'discount': (_isCouponApplied ? total * 10 / 100 : 0.00).toString(),
      'charges':
          (total - (_isCouponApplied ? total * 10 / 100 : 0.00)).toString(),
    };

    try {
      await HttpWrapper.sendPostRequest(url: ADD_HOTEL_BOOKING, body: order)
          .then((value) {
        print('New Booking :: $value');
        CustomToast.showToast(value['message']);
        id = value['booking']['_id'];
        loadBookingHistory();
      });
    } catch (e) {
      print(e);
    }
  }
}
