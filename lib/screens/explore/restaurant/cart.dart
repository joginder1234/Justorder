import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/explore.dart';
import 'package:justorderuser/modals/restaurant_details.dart';
import 'package:justorderuser/screens/base_widget.dart';
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

  double deliveryCharge = 0.0;

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
    // TODO: implement initState
    super.initState();
    loadCartItems();
  }

  emptyCart() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var dltResponse = await HttpWrapper.sendDeleteRequest(url: EMPTY_CART);
      if (dltResponse['success'] == true) {
        print(dltResponse);
        loadCartItems();
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  loadCartItems() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    try {
      var cartData = await HttpWrapper.sendGetRequest(url: GET_CART_ITEM);
      print("Cart Data :: $cartData");
      if (cartData['success'] == true) {
        var _restaurantDetails = (cartData['carts'] as List).length <= 0
            ? null
            : Provider.of<ResaurantsDataProvider>(context, listen: false)
                .allRestaurants
                .firstWhere((element) =>
                    element.id == cartData['carts'][0]['resturantId']);
        setState(() {
          _cartItems = cartData['carts'];
          _isLoading = false;
          deliveryCharge = (cartData['carts'] as List).length <= 0
              ? 0.0
              : _restaurantDetails!.deliveryCharge;
          serviceCharge = (cartData['carts'] as List).length <= 0
              ? 0.0
              : _restaurantDetails!.serviceCharge;
        });
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  deleteCartItems(String itemId) async {
    print('Cart Id :: $itemId');
    setState(() {
      _deleting = true;
    });
    try {
      var deleteResponse = await HttpWrapper.sendDeleteRequest(
          url: DELETE_CART_ITEMS + '/$itemId');
      print('URL :: ${DELETE_CART_ITEMS + '/$itemId'}');
      if (deleteResponse['success'] == true) {
        print(deleteResponse);
        loadCartItems();
        setState(() {
          _deleting = false;
        });
      } else {
        print(deleteResponse);
      }
    } catch (e) {
      log(e.toString());
      setState(() {
        _deleting = false;
      });
    }
  }

  // sendOrder() async {
  //   Map<String, dynamic> _order = {
  //     'restaurantId': _cartItems[0]['resturantId'],
  //     'cartId': _cartItems
  //     'userId' :
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _cartItems == [] || _cartItems.isEmpty
          ? Colors.white
          : Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Order Basket", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => BaseWidget()),
                    (route) => false);
              },
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ))
        ],
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
            child: _isLoading
                ? Container(
                    color: Colors.white,
                  )
                : _cartItems.isEmpty || _cartItems == []
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
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              onTap: () {},
                              tileColor: Colors.white,
                              title: Text(
                                _cartItems[i]['name'] ?? '',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                  '\$${_cartItems[i]['price'] + 0.0}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600)),
                              trailing: Container(
                                constraints: BoxConstraints(
                                    minWidth: 130, maxWidth: 160),
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElegantNumberButton(
                                        color: Colors.grey,
                                        initialValue: int.parse(_cartItems[i]
                                                ['quantity']
                                            .toString()),
                                        minValue: 1,
                                        maxValue: 100,
                                        onChanged: (value) {
                                          setState(() {
                                            _cartItems[i]['quantity'] =
                                                value.toString();
                                          });
                                        },
                                        decimalPlaces: 1),
                                    _deleting
                                        ? IconButton(
                                            onPressed: null,
                                            icon: Icon(Icons.delete,
                                                color: Colors.grey.shade300))
                                        : IconButton(
                                            onPressed: () {
                                              deleteCartItems(
                                                  _cartItems[i]['_id']);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red.shade800,
                                            ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
          ),
          _cartItems.isEmpty
              ? Container()
              : Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cart Total',
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '\$' + getCartTotal().toString(),
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Delivery Charge',
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '(+) \$$deliveryCharge',
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Service Charge',
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '(+) \$$serviceCharge',
                              style: GoogleFonts.robotoCondensed(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              constraints:
                                  BoxConstraints(minWidth: 130, maxWidth: 170),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Grand Total',
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '\$' +
                                        (getCartTotal() +
                                                deliveryCharge +
                                                serviceCharge)
                                            .toString(),
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                constraints: BoxConstraints(
                                    maxWidth: 200, minWidth: 150),
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: !_isLoading
                                    ? ElevatedButton(
                                        onPressed: () {
                                          if (_cartItems.isEmpty) {
                                            return;
                                          } else {
                                            emptyCart();
                                            setState(() {
                                              deliveryCharge = 0.0;
                                            });
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            'ORDER NOW',
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ))
                                    : ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.grey)),
                                        onPressed: null,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Text(
                                            'ORDER NOW',
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        )))
                          ],
                        )
                      ],
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
