import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class RestaurantDetailsPage extends StatefulWidget {
  final String restId;
  const RestaurantDetailsPage({Key? key, required this.restId})
      : super(key: key);

  static const restDetailsScreen = '/restaurantdetailpage';

  @override
  State<RestaurantDetailsPage> createState() => _RestaurantDetailsPageState();
}

class _RestaurantDetailsPageState extends State<RestaurantDetailsPage> {
  double rating = 4.4;
  bool isFavt = false;
  @override
  Widget build(BuildContext context) {
    // var restId = ModalRoute.of(context)?.settings.arguments;
    var restaurantDetails = Provider.of<ResaurantsDataProvider>(context)
        .allRestaurants
        .firstWhere((element) => element.id == widget.restId);

    return Scaffold(
      backgroundColor: Colors.white,
      body: restaurantDetails == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        color: Colors.black,
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width * 1.0,
                        child: Hero(
                          tag: restaurantDetails.id,
                          child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(restaurantDetails.image),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                restaurantDetails.restaurantName,
                                style: TextStyle(
                                    color: Theme.of(context).buttonColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  restaurantDetails.restaurantAddress == '' ||
                                          restaurantDetails.restaurantAddress ==
                                              null
                                      ? Container()
                                      : Text(
                                          '${restaurantDetails.restaurantAddress}',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                  Row(
                                    children: [
                                      restaurantDetails.city == null ||
                                              restaurantDetails.city ==
                                                  'null' ||
                                              restaurantDetails.city == ''
                                          ? Container()
                                          : Text(
                                              '${restaurantDetails.city}. ',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                      restaurantDetails.region == '' ||
                                              restaurantDetails.region ==
                                                  'null' ||
                                              restaurantDetails.region == null
                                          ? Container()
                                          : Text(
                                              '${restaurantDetails.region}',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                    ],
                                  ),
                                  restaurantDetails.country == '' ||
                                          restaurantDetails.country == null
                                      ? Container()
                                      : Text(
                                          '${restaurantDetails.country}',
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 1.5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    FaIcon(FontAwesomeIcons.store,
                                        size: 25,
                                        color:
                                            restaurantDetails.isActive == true
                                                ? Colors.green
                                                : Colors.black),
                                    restaurantDetails.isActive == true
                                        ? Text('Open')
                                        : Text('Close')
                                  ],
                                ),
                                Column(
                                  children: [
                                    FaIcon(FontAwesomeIcons.shopify,
                                        size: 25,
                                        color:
                                            restaurantDetails.collectStatus ==
                                                    true
                                                ? Colors.green
                                                : Colors.black),
                                    Text('Collect')
                                  ],
                                ),
                                Column(
                                  children: [
                                    FaIcon(FontAwesomeIcons.creditCard,
                                        size: 25,
                                        color: restaurantDetails
                                                    .acceptCardStatus ==
                                                true
                                            ? Colors.green
                                            : Colors.black),
                                    Text('Accept Card')
                                  ],
                                ),
                                Column(
                                  children: [
                                    Image(
                                      image: restaurantDetails.deliveryStatus ==
                                              true
                                          ? AssetImage('assets/10244.png')
                                          : AssetImage('assets/1024.png'),
                                      width: 35,
                                    ),
                                    Text('Delivery')
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Divider(
                                thickness: 1.5,
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  restaurantActivityTile('Active Hour',
                                      '7 am - 6 pm', Colors.black),
                                  restaurantActivityTile('Phone', '8901111444',
                                      Theme.of(context).buttonColor),
                                  restaurantActivityTile(
                                      'Email',
                                      restaurantDetails.restaurantEmail,
                                      Theme.of(context).buttonColor),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: const Divider(
                                thickness: 1.5,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description :',
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    restaurantDetails.description,
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.45 - 45,
                    right: 25,
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(blurRadius: 3, color: Colors.black)
                          ],
                          color: Colors.white,
                        ),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                isFavt = !isFavt;
                              });
                            },
                            icon: isFavt
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  )
                                : Icon(Icons.favorite_border_outlined,
                                    color: Colors.black))),
                  ),
                ],
              ),
            ),
    );
  }

  Row restaurantActivityTile(String title, String subtitle, Color txtcolor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(subtitle,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: txtcolor))
      ],
    );
  }
}

class Offers extends StatefulWidget {
  String id;
  double discount;
  String code;
  Offers(
    this.id,
    this.discount,
    this.code,
  );

  @override
  State<Offers> createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  bool isCopy = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('Flat ${widget.discount}% off'),
          subtitle: Text('Short time offer'),
          leading: Container(
              padding: EdgeInsets.all(7),
              child: FittedBox(
                  child: Text('${widget.discount}%',
                      style: GoogleFonts.oswald(
                          fontWeight: FontWeight.w600, color: Colors.white))),
              height: 50,
              width: 50,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.orange)),
          trailing: isCopy
              ? Container(
                  width: 90,
                  height: 30,
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Center(child: Text(widget.code)))
              : TextButton(
                  onPressed: () {
                    setState(() {
                      isCopy = true;
                    });
                  },
                  child: Text('COPY CODE')),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Divider(),
        )
      ],
    );
  }
}
