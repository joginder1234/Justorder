import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/widgets/restaurant_tile.dart';
import 'package:provider/provider.dart';

class RestaurantExplore extends StatefulWidget {
  RestaurantExplore({Key? key}) : super(key: key);

  @override
  _RestaurantExploreState createState() => _RestaurantExploreState();
}

class _RestaurantExploreState extends State<RestaurantExplore> {
  @override
  Widget build(BuildContext context) {
    var restaurantsList =
        Provider.of<ResaurantsDataProvider>(context, listen: false)
            .restaurantsList;

    print("Restaurants Data List :: $restaurantsList");

    return Scaffold(
      body: restaurantsList == null || restaurantsList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Search Restaurants...'),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.75),
                    itemCount: restaurantsList.length,
                    itemBuilder: (BuildContext context, int i) {
                      return RestaurantTile(
                          restaurantsList[i].id,
                          restaurantsList[i].image,
                          restaurantsList[i].restaurantName,
                          restaurantsList[i].restaurantAddress,
                          3.2);
                    },
                  ),
                )
              ],
            ),
    );
  }
}
