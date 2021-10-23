import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justorderuser/screens/explore/restaurant/cart.dart';
import 'package:justorderuser/screens/explore/restaurant/menu.dart';
import 'package:justorderuser/screens/explore/restaurant/restaurant_details_page.dart';
import 'package:justorderuser/screens/explore/restaurant/reviews.dart';
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
  }

  loadRestId() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      restId = _prefs.getString('restId').toString();
    });
  }

  var currentindex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      RestaurantDetailsPage(restId: restId),
      RestaurantMenuPage(),
      RestaurantReviews()
    ];
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => RestaurantCart()));
          },
          child: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
          )),
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            currentindex = value;
          });
        },
        currentIndex: currentindex,
        items: const [
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.file, color: Colors.black),
            title: Text(
              'Details',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, color: Colors.black),
            title: Text(
              'Menu',
              style: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rate_review_sharp,
              color: Colors.black,
            ),
            title: Text(
              'Reviews',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
