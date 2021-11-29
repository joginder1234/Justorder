import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/backend/providers/service.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/hotel_detail.dart';
import 'package:justorderuser/modals/restaurant_details.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_functions.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_screen.dart';
import 'package:justorderuser/screens/explore/restaurant/cart.dart';
import 'package:justorderuser/screens/explore/restaurant/restaurant_screen.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Explore extends StatefulWidget {
  Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List serviceList = [];
  List _cartItems = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    getHotelsList();
    getRestaurants();
    loadCartItems();
  }

  loadCartItems() async {
    var response = await FunctionsProvider.loadCartItems();
    setState(() {
      _cartItems = response;
    });
  }

  getHotelsList() async {
    var response = await FunctionsProvider.getHotelsList();
    setState(() {
      Provider.of<HotelDataProvider>(context, listen: false).hotelData =
          response.map((e) => Hotel.fromJson(e)).toList();
      loading = false;
    });
  }

  getRestaurants() async {
    var response = await FunctionsProvider.getRestaurants();
    var data = response.map((e) => Restaurant.fromJson(e)).toList();
    setState(() {
      Provider.of<ResaurantsDataProvider>(context, listen: false)
          .allRestaurants = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0XFF0F2C67),
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.light,
                  statusBarColor: Colors.transparent),
              automaticallyImplyLeading: false,
              title: Text("Explore",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23)),
              iconTheme: IconThemeData(color: Colors.black),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.notifications,
                      color: Colors.yellow,
                    )),
                Consumer<Quantity>(builder: (_, q, ch) {
                  return IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RestaurantCart()));
                    },
                    icon: q.orderQuantity == 0
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
                              q.orderQuantity.toString(),
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
                            ),
                            position: BadgePosition(top: -15, end: -5),
                          ),
                  );
                }),
                const SizedBox(
                  width: 10,
                )
              ],
              bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  labelStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  unselectedLabelColor: Colors.white,
                  unselectedLabelStyle: TextStyle(fontSize: 16),
                  isScrollable: true,
                  tabs: [
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Center(child: Text('Hotels')),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Center(child: Text('Restaurants')),
                      ),
                    ),
                  ]),
            ),
            resizeToAvoidBottomInset: false,
            body: TabBarView(
              children: <Widget>[HotelsExplore(), RestaurantExplore()],
            )));
  }
}
