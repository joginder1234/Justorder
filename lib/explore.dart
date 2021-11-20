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
import 'package:justorderuser/screens/explore/hotels/hotel_screen.dart';
import 'package:justorderuser/screens/explore/restaurant/cart.dart';
import 'package:justorderuser/screens/explore/restaurant/restaurant_screen.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  Explore({Key? key}) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List serviceList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    getHotelsList();
    getRestaurants();
    // loadServiceList();
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
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.transparent),
              automaticallyImplyLeading: false,
              title: Text("Explore", style: TextStyle(color: Colors.black)),
              iconTheme: IconThemeData(color: Colors.black),
              actions: [
                IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => RestaurantCart()));
                    },
                    icon: Icon(Icons.shopping_cart)),
              ],
              bottom: TabBar(
                  indicatorColor: Colors.green,
                  labelColor: Colors.green,
                  labelStyle: TextStyle(fontSize: 18),
                  unselectedLabelColor: Colors.grey,
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

  loadServiceList() async {
    try {
      var data = await ServiceProvider.otherServiceList();
      print(data);
      if (data['success'] == true) {
        setState(() {
          serviceList.addAll(data['items']);
          loading = false;
        });
      } else {
        CustomToast.showToast(data['message']);
        setState(() {
          serviceList.addAll([]);
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      CustomToast.showToast("Something went wrong");
    }
  }

  getHotelsList() async {
    try {
      var hotelData = await HttpWrapper.sendGetRequest(url: HOTEL_LISTS);
      if (hotelData['success'] == true) {
        var response = (hotelData['hotels'] as List);

        setState(() {
          Provider.of<HotelDataProvider>(context, listen: false).hotelData =
              response.map((e) => Hotel.fromJson(e)).toList();
          loading = false;
        });
      } else {
        CustomToast.showToast(hotelData['message']);
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print('Hotel Function Error : $e');
    }
  }

  getRestaurants() async {
    try {
      var restaurantData =
          await HttpWrapper.sendGetRequest(url: RESTAURANT_LISTS);
      if (restaurantData['success'] == true) {
        var response = restaurantData['restaurants'] as List;
        var data = response.map((e) => Restaurant.fromJson(e)).toList();
        setState(() {
          Provider.of<ResaurantsDataProvider>(context, listen: false)
              .allRestaurants = data;
        });
      } else {
        CustomToast.showToast(restaurantData['message']);
      }
    } catch (e) {
      print('Restaurant Function Error : $e');
    }
  }
}
