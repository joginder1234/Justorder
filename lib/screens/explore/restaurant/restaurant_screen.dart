import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/modals/restaurant_details.dart';
import 'package:justorderuser/screens/explore/restaurant/bottomNavigation.dart';
import 'package:justorderuser/widgets/restaurant_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantExplore extends StatefulWidget {
  RestaurantExplore({Key? key}) : super(key: key);

  @override
  _RestaurantExploreState createState() => _RestaurantExploreState();
}

class _RestaurantExploreState extends State<RestaurantExplore> {
  List<Restaurant> _searchRestaurant = [];
  TextEditingController _searchController = TextEditingController();

  onSearching(String value, List<Restaurant> restList) {
    setState(() {
      _searchRestaurant = restList
          .where((element) => element.restaurantName
              .contains(value == '' ? 'abcdefghij' : value))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var restaurantsList =
        Provider.of<ResaurantsDataProvider>(context, listen: false)
            .allRestaurants;

    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
          _searchRestaurant.clear();
        });
      },
      child: Scaffold(
        body: restaurantsList == null || restaurantsList.isEmpty
            ? Center(
                child: Text('No Restaurant found in database'),
              )
            : Stack(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            // height:  0.7,
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: 'Search Restaurants...'),
                              onChanged: (v) => onSearching(v, restaurantsList),
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
                  ),
                ),
                _searchRestaurant.isEmpty
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 65, right: 15, left: 15),
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(color: Colors.grey.shade500, blurRadius: 3)
                        ]),
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height - 200,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height - 200),
                        child: ListView.builder(
                            itemCount: _searchRestaurant.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, i) => ListTile(
                                onTap: () async {
                                  SharedPreferences _prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    _prefs.setString(
                                        'restId', _searchRestaurant[i].id);
                                  });
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => RestaurantViewBar()));
                                  setState(() {
                                    _searchController.clear();
                                    FocusScope.of(context).unfocus();
                                    _searchRestaurant.clear();
                                  });
                                },
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: Image.network(
                                      _searchRestaurant[i].image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title:
                                    Text(_searchRestaurant[i].restaurantName),
                                subtitle: Text(
                                    _searchRestaurant[i].restaurantAddress),
                                trailing: Icon(
                                  Icons.navigate_next,
                                  color: Color(0XFF0F2C67),
                                ))),
                      )
              ]),
      ),
    );
  }
}
