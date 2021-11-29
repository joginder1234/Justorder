import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/screens/explore/restaurant/cart.dart';
import 'package:justorderuser/screens/explore/restaurant/menu.dart';
import 'package:justorderuser/screens/explore/restaurant/restaurant_details_page.dart';
import 'package:justorderuser/screens/explore/restaurant/reviews.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantViewBar extends StatefulWidget {
  RestaurantViewBar({
    Key? key,
  }) : super(key: key);

  @override
  State<RestaurantViewBar> createState() => _HomePageRestaurantState();
}

class _HomePageRestaurantState extends State<RestaurantViewBar> {
  String restId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRestId();
    loadCart();
  }

  loadRestId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      restId = _prefs.getString('restId').toString();
    });
  }

  loadCart() {
    setState(() {
      Provider.of<ResaurantsDataProvider>(context, listen: false)
          .loadCartItems();
    });
  }

  var currentindex = 0;

  @override
  Widget build(BuildContext context) {
    var _cartItems = Provider.of<ResaurantsDataProvider>(context).cartItems;
    print(_cartItems);
    final screens = [
      RestaurantDetailsPage(restId: restId),
      RestaurantMenuPage(),
      RestaurantReviews()
    ];
    return Scaffold(
      floatingActionButton: Consumer<Quantity>(builder: (_, b, ch) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).buttonColor,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => RestaurantCart()));
          },
          child: b.orderQuantity == 0
              ? Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                )
              : Badge(
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  badgeColor: Colors.red,
                  badgeContent: Text(
                    b.orderQuantity.toString(),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  position: BadgePosition(top: -17, end: -10),
                ),
        );
      }),
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).buttonColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 16,
        unselectedFontSize: 13,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        elevation: 10,
        onTap: (value) {
          setState(() {
            currentindex = value;
          });
        },
        currentIndex: currentindex,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.file),
            title: Text(
              'Details',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu,
            ),
            title: Text(
              'Menu',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rate_review_sharp,
            ),
            title: Text(
              'Reviews',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
