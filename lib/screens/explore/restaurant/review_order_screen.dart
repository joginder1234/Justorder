import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/services/paymentservice.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_functions.dart';
import 'package:justorderuser/screens/order_history/restaurant_orders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewFoodOrder extends StatefulWidget {
  ReviewFoodOrder({Key? key}) : super(key: key);

  @override
  _ReviewFoodOrderState createState() => _ReviewFoodOrderState();
}

// bool onTap = false;

int val = 1;
bool loading = false;
// double deliveryCharge = 0.0;
// String restId = '';

class _ReviewFoodOrderState extends State<ReviewFoodOrder> {
  List _cartItems = [];
  bool _isLoading = false;
  bool _deleting = false;
  double serviceCharge = 0.0;
  double discount = 10.0;
  bool addressValue = false;
  bool ordering = false;
  List<bool> addresValuechange = [true, false];

  String transactionId = '';

  int retryTime = 3;

  Map<String, dynamic> currentUser = {};
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  double deliveryCharge = 0.0;

  String cartId = '';
  String userId = '';
  String restId = '';

  bool _isExpanded = false;
  bool _loadingAddress = false;

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  /// Getting quantity of each item
  int getQuantity() {
    int quantity = 0;
    _cartItems.forEach((element) {
      quantity += int.parse(element['quantity'].toString());
    });
    return quantity;
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

  bool addressOfUser = false;

  getUserAddress() async {
    setState(() {
      _loadingAddress = true;
    });
    try {
      var address = await HttpWrapper.sendGetRequest(url: GET_USER_ADDRESS);
      if (address['success'] == true) {
        var ad = address['detailRes'][0];

        setState(() {
          _loadingAddress = false;
          addressOfUser = true;
          _addressController.text = ad['address'];
          _cityController.text = ad['city'];
          _postalController.text = ad['postcode'];
          _countryController.text = ad['country'];
        });
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      if (mounted) {
        setState(() {
          _loadingAddress = false;
        });
      }
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

  ///Getting total of all items in cart
  double getCartTotal() {
    double cartTotal = 0.0;
    _cartItems.forEach((element) {
      cartTotal += double.parse(element['price'].toString()) *
          double.parse(element['quantity'].toString());

      if (cartTotal > 0) {
        setState(() {
          deliveryCharge = 15.0;
        });
      }
    });

    return cartTotal;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    setState(() {
      val = 1;
    });
    getUserAddress();
    loadCartItems();
  }

  loadCartItems() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    try {
      var cartData = await HttpWrapper.sendGetRequest(url: GET_CART_ITEM);
      print("Cart Data :: $cartData");
      if (cartData['success'] == true && mounted) {
        setState(() {
          cartId = cartData['carts'][0]['_id'];
          userId = cartData['carts'][0]['userId'];
          restId = cartData['carts'][0]['restaurantId'];
        });
        var _restaurantDetails =
            (cartData['carts'][0]['cartItems'] as List).length <= 0
                ? null
                : Provider.of<ResaurantsDataProvider>(context, listen: false)
                    .allRestaurants
                    .firstWhere((element) =>
                        element.id == cartData['carts'][0]['restaurantId']);
        setState(() {
          _cartItems = cartData['carts'][0]['cartItems'];
          _isLoading = false;
          deliveryCharge =
              (cartData['carts'][0]['cartItems'] as List).length <= 0
                  ? 0.0
                  : _restaurantDetails!.deliveryCharge;
          serviceCharge =
              (cartData['carts'][0]['cartItems'] as List).length <= 0
                  ? 0.0
                  : _restaurantDetails!.serviceCharge;
        });
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // var cartofList = Provider.of<>(context).
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Order Review',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height - 270,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Deliver to',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).buttonColor),
                ),
              ),
              _loadingAddress
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).buttonColor,
                        backgroundColor: Colors.transparent,
                      ),
                    )
                  : Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                      ]),
                      child: ListTile(
                          tileColor: Colors.white,
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: Theme.of(context).buttonColor,
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                showAddressDialog(context);
                              },
                              icon: Icon(Icons.edit)),
                          title: !addressOfUser
                              ? Text('No Address Added')
                              : Wrap(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    _addressController.text.isEmpty
                                        ? SizedBox()
                                        : Text(_addressController.text + ', '),
                                    _cityController.text.isEmpty
                                        ? SizedBox()
                                        : Text(_cityController.text + ', '),
                                    _postalController.text.isEmpty
                                        ? SizedBox()
                                        : Text(_postalController.text + ', '),
                                    _countryController.text.isEmpty
                                        ? SizedBox()
                                        : Text(_countryController.text)
                                  ],
                                )),
                    ),
              buildHeadTitle('Order Items'),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).buttonColor,
                          backgroundColor: Colors.transparent),
                    )
                  : Column(
                      children: _cartItems
                          .map((e) => Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 10)
                                    ]),
                                margin: const EdgeInsets.only(bottom: 5),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  title: Text(e['name'] ?? '',
                                      style: GoogleFonts.notoSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                  subtitle: Text(e['size']),
                                  trailing: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Qty - ${e['quantity'].toString()}'),
                                          Text('\$${e['price'] + 0.0}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold))
                                        ]),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
              buildHeadTitle('Payment Method'),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                ]),
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: (MediaQuery.of(context).size.width - 40) * 0.5,
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
                      width: (MediaQuery.of(context).size.width - 40) * 0.5,
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
              buildHeadTitle('Comments'),
              Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 10)
                ]),
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      hintText: 'Comments'),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 10)],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            buildPriceTile('Order Price', '\$${getCartTotal().toString()}'),
            buildPriceTile('Delivery Charge', '\$$deliveryCharge'),
            buildPriceTile('Service Charge', '\$$serviceCharge'),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 15)),
                        backgroundColor: _isLoading || _loadingAddress
                            ? MaterialStateProperty.all(
                                Colors.blueGrey.shade500)
                            :
                            // ignore: deprecated_member_use
                            MaterialStateProperty.all(
                                Theme.of(context).buttonColor)),
                    onPressed: () async {
                      if (_isLoading || _loadingAddress) {
                        return;
                      } else {
                        setState(() {
                          loading = true;
                        });
                        if (!addressOfUser) {
                          CustomToast.showToast('Please add delivery address');
                          setState(() {
                            loading = false;
                          });
                        } else if (val == 1) {
                          sendOrder();
                        } else {
                          try {
                            var paymentResponse =
                                await FlutterStripePayment.createPaymentIntent(
                                    (getCartTotal() +
                                        deliveryCharge +
                                        serviceCharge),
                                    'INR',
                                    'Joginder',
                                    '${_addressController.text}, ${_cityController.text}',
                                    _postalController.text,
                                    8901111444.toString(),
                                    _countryController.text);
                            await initPaymentSheet(paymentResponse);
                            await Stripe.instance.presentPaymentSheet();
                            await getTransactionResponse(
                                    context, paymentResponse)
                                .then((value) {
                              if (value) {
                                sendOrder();

                                setState(() {
                                  loading = false;
                                });
                              }
                            });
                          } catch (e) {
                            CustomToast.showToast(e.toString());
                            setState(() {
                              loading = false;
                            });
                          }
                        }
                      }
                    },
                    child: loading
                        ? SizedBox(
                            height: 18,
                            width: 18,
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: Colors.white,
                                  backgroundColor: Colors.transparent),
                            ),
                          )
                        : Text(
                            'Make Payment (\$${getCartTotal() + deliveryCharge + serviceCharge})',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
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

  Widget buildPriceTile(String title, String trailing) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width - 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(trailing,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget buildHeadTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).buttonColor),
      ),
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
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'CANCEL',
                                style: TextStyle(fontSize: 16),
                              )),
                          ElevatedButton(
                              style: ButtonStyle(
                                  fixedSize:
                                      MaterialStateProperty.all(Size(110, 40))),
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });

                                !addressOfUser
                                    ? addUserAddress()
                                    : updateAddress();
                              },
                              child: Text(
                                'SAVE',
                                style: TextStyle(fontSize: 16),
                              ))
                        ],
                      )
              ],
            ));
  }

  Future initPaymentSheet(dynamic _paymentSheetData) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      applePay: true,
      googlePay: true,
      style: ThemeMode.dark,
      testEnv: true,
      merchantCountryCode: 'IN',
      merchantDisplayName: 'Just Order',
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

  sendOrder() async {
    setState(() {
      ordering = true;
    });
    try {
      Map<String, dynamic> _order = {
        'orderDate': DateFormat('yMMMd').format(DateTime.now()),
        'orderTime': TimeOfDay.now().format(context),
        'restaurantId': restId,
        'restaurantName': '',
        'cartId': cartId,
        'userId': userId,
        'status': 'preparing',
        'paymentMethod': val == 1 ? 'Cash' : 'card',
        'totalPrice':
            (getCartTotal() + deliveryCharge + serviceCharge).toString(),
        'transaction_id': '',
        'transaction_status': true,
        'line1': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'phone': _contactController.text.trim()
      };

      // Provider.of<ResaurantsDataProvider>(context, listen: false)
      //     .myOrders
      //     .add(_order);

      await HttpWrapper.sendPostRequest(url: ORDER_FOOD, body: _order)
          .then((value) {
        print(value);
        print('Order Submitted');
        emptyCart();
        setState(() {
          deliveryCharge = 0.0;
          ordering = false;
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => RestaurantOrders()),
            (route) => false);
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        ordering = false;
      });
    }
  }

  emptyCart() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var dltResponse = await HttpWrapper.sendDeleteRequest(url: EMPTY_CART);
      if (dltResponse['success'] == true) {
        if (!mounted) {
          return;
        }
        setState(() {
          Provider.of<Quantity>(context, listen: false).setQuantity(0);
        });
      }
    } catch (e) {
      log(e.toString());
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
