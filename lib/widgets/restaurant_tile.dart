import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/screens/explore/restaurant/bottomNavigation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../backend/providers/source_provider.dart';

class RestaurantTile extends StatefulWidget {
  final String restId;
  final String restImage;
  final String restName;
  final String restAddress;
  final double restRatings;
  RestaurantTile(
    this.restId,
    this.restImage,
    this.restName,
    this.restAddress,
    this.restRatings,
  );

  @override
  _RestaurantTileState createState() => _RestaurantTileState();
}

class _RestaurantTileState extends State<RestaurantTile> {
  bool _isFavorite = false;

  // getallReviews(String hotelId) async {
  //   try {
  //     var reviews =
  //         await HttpWrapper.sendGetRequest(url: HOTEL_REVIEWS + '/$hotelId');

  //     print(reviews);

  //     print('API : ${HOTEL_REVIEWS + '/$hotelId'}');
  //     print('Hotel Id : $hotelId');
  //     print((reviews['reviews'] as List).map((e) => e['hotelId']));

  //     if (reviews['success'] == true) {
  //       setState(() {
  //         Provider.of<HotelDataProvider>(context, listen: false)
  //             .setreviewList((reviews['reviews']));
  //       });
  //     } else {
  //       CustomToast.showToast(reviews['message']);
  //     }
  //   } catch (e) {
  //     print('function Error : $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        setState(() {
          _prefs.setString('restId', widget.restId);
        });
        print('Restaurant Id :: ${widget.restId}');
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => RestaurantViewBar()));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 1,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child:
                        widget.restImage != null && widget.restImage.isNotEmpty
                            ? Hero(
                                tag: widget.restId,
                                child: Image(
                                  image: NetworkImage(widget.restImage),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Placeholder(),
                  ),
                ),
                Container(
                  height: 90,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.restName,
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 15,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.34,
                              child: Text(
                                widget.restAddress,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                      RatingBar(
                          initialRating: 4,
                          allowHalfRating: true,
                          itemSize: 20,
                          ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star,
                                color: Colors.green,
                              ),
                              half: Icon(
                                Icons.star_half,
                                color: Colors.green,
                              ),
                              empty: Icon(
                                Icons.star_border,
                                color: Colors.grey,
                              )),
                          ignoreGestures: true,
                          onRatingUpdate: (value) {})
                    ],
                  ),
                ),
              ],
            ),
            // Positioned(
            //     top: 5,
            //     right: 5,
            //     child: _isFavorite
            //         ? fvtIconBtn(
            //             Icon(
            //               Icons.favorite,
            //               size: 20,
            //               color: Colors.red,
            //             ),
            //             false)
            //         : fvtIconBtn(
            //             Icon(
            //               Icons.favorite_border,
            //               size: 20,
            //               color: Colors.red,
            //             ),
            //             true))
          ],
        ),
      ),
    );
  }

  Container fvtIconBtn(Icon icon, bool value) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      width: 35,
      decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.5),
          borderRadius: BorderRadius.circular(100)),
      child: IconButton(
          onPressed: () {
            setState(() {
              _isFavorite = value;
            });
          },
          icon: icon),
    );
    // };
  }
}
