import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/explore.dart';
import 'package:justorderuser/modals/restaurant_details.dart';
import 'package:justorderuser/screens/base_widget.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_functions.dart';
import 'package:justorderuser/screens/explore/restaurant/review_order_screen.dart';
import 'package:justorderuser/screens/order_history/restaurant_orders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantCart extends StatefulWidget {
  RestaurantCart({Key? key}) : super(key: key);

  @override
  _RestaurantCartState createState() => _RestaurantCartState();
}

class _RestaurantCartState extends State<RestaurantCart> {
  List _cartItems = [];
  bool _isLoading = false;
  bool _deleting = false;
  double serviceCharge = 0.0;
  bool addressValue = false;
  bool ordering = false;
  List<bool> addresValuechange = [true, false];

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  double deliveryCharge = 0.0;

  String cartId = '';
  String userId = '';
  String restId = '';

  bool _isExpanded = false;

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

  ///Getting total of all items in cart
  double getCartTotal() {
    double cartTotal = 0.0;
    _cartItems.forEach((element) {
      print('Price check :: ${element['price'].toString()}');
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
    // TODO: implement initState
    super.initState();
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

  deleteCartItems(String itemId, String cartId) async {
    setState(() {
      _deleting = true;
    });
    var response = await FunctionsProvider.deleteCartItems(itemId, cartId);

    if (response) {
      loadCartItems();
      Provider.of<Quantity>(context, listen: false).decreaseQuantity();
      setState(() {
        _deleting = false;
      });
    } else {
      setState(() {
        _deleting = false;
      });
    }
  }

  String getRestName() {
    String restName = '';
    var restaurant = Provider.of<ResaurantsDataProvider>(context, listen: false)
        .allRestaurants
        .firstWhere((element) => element.id == restId);
    restName = restaurant.restaurantName;
    return restName;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = false;
        });
      },
      child: Scaffold(
        backgroundColor: _cartItems == [] || _cartItems.isEmpty
            ? Colors.white
            : Colors.grey.shade100,
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            "Order Basket",
          ),
        ),
        body: Column(
          children: [
            _isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade100,
                    color: Colors.green,
                  )
                : Container(
                    height: 4,
                  ),
            Expanded(
              child: _cartItems.isEmpty || _cartItems == []
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('assets/empty.jpg'),
                            width: MediaQuery.of(context).size.width * 0.35,
                          ),
                          Text(
                            'No Items in cart....',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade600),
                          ),
                          Text(
                            'add some to continue',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade600),
                          )
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      itemCount: _cartItems.length,
                      itemBuilder: (ctx, i) {
                        return Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200, blurRadius: 10)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300)),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _cartItems[i]['name'] ?? '',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    '\$${_cartItems[i]['price'] + 0.0}',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              SizedBox(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                          // color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isLoading = true;
                                                  final newvalue = int.parse(
                                                          _cartItems[i]
                                                                  ['quantity']
                                                              .toString()) -
                                                      1;
                                                  _cartItems[i]['quantity'] =
                                                      newvalue.clamp(1, 100);
                                                });
                                                updateCart(
                                                    cartId,
                                                    _cartItems[i]['quantity']
                                                        .toString(),
                                                    _cartItems[i]['_id']);
                                              },
                                              icon: const Icon(Icons.remove)),
                                          Text(_cartItems[i]['quantity']
                                              .toString()),
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  final newvalue = int.parse(
                                                          _cartItems[i]
                                                                  ['quantity']
                                                              .toString()) +
                                                      1;
                                                  _cartItems[i]['quantity'] =
                                                      newvalue.clamp(1, 100);
                                                });

                                                updateCart(
                                                    cartId,
                                                    _cartItems[i]['quantity']
                                                        .toString(),
                                                    _cartItems[i]['_id']);
                                              },
                                              icon: const Icon(Icons.add))
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          deleteCartItems(
                                              _cartItems[i]['_id'], cartId);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
            ),
          ],
        ),
        bottomNavigationBar: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: _cartItems.isEmpty
              ? 0
              : _isExpanded
                  ? 370
                  : 180,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 15)],
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  child: Container(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: _isExpanded
                        ? Icon(Icons.arrow_drop_down)
                        : Icon(Icons.arrow_drop_up_outlined),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: _isExpanded ? 190 : 0,
                  child: _isExpanded
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Summary',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              buildCustomeTile(
                                  context, getCartTotal(), 'Subtotal'),
                              const Divider(
                                thickness: 1.1,
                              ),
                              buildCustomeTile(
                                  context, deliveryCharge, 'Delivery Charge'),
                              const Divider(
                                thickness: 1.1,
                              ),
                              buildCustomeTile(
                                  context, serviceCharge, 'Service Charge'),
                              const Divider(
                                thickness: 1.1,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: !_isExpanded
                      ? const Text(
                          'Tap for details',
                          style: TextStyle(fontSize: 13),
                        )
                      : Container(),
                  trailing: Text(
                    '\$${(getCartTotal() + deliveryCharge + serviceCharge)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).buttonColor),
                              fixedSize: MaterialStateProperty.all(
                                  Size(MediaQuery.of(context).size.width, 50))),
                          onPressed: () {
                            // showAddressDialog(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ReviewFoodOrder()));
                          },
                          child: const Text(
                            'Begin Chechout',
                            style: TextStyle(fontSize: 20),
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox buildCustomeTile(
      BuildContext context, double subtotal, String title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            '\$$subtotal',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  updateCart(String cartId, String quantity, String cartItemId) async {
    print(cartItemId);
    Map<String, dynamic> updatedData = {
      'quantity': quantity,
      'cartItemsId': cartItemId
    };
    try {
      var response = await HttpWrapper.sendPostRequest(
          url: UPDATE_CART + '/$cartId', body: updatedData);

      loadCartItems();

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      log('Update Response :: $response');
    } catch (e) {
      CustomToast.showToast(e.toString());
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  buildLoadingStatus(bool loading) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SimpleDialog(
            children: [
              Center(
                child: loading
                    ? CircularProgressIndicator(
                        color: Colors.green,
                        backgroundColor: Colors.transparent,
                      )
                    : Image.asset(
                        'assets/submit.gif',
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
              )
            ],
          );
        },
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
}
