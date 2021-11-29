import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/hotel_detail.dart';
import 'package:justorderuser/modals/rooms_details.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_functions.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_rooms.dart';
import 'package:justorderuser/screens/explore/hotels/reviews_screen.dart';
import 'package:justorderuser/widgets/features.dart' as feature;
import 'package:justorderuser/widgets/review_tile.dart';
import 'package:provider/provider.dart';

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({Key? key}) : super(key: key);
  static const hotelDetailRoute = '/HotelDetailsPage';

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetailsScreen> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    final hotelId = ModalRoute.of(context)!.settings.arguments as String;
    final hotelDetailsData = Provider.of<HotelDataProvider>(context)
        .hotelData
        .firstWhere((element) => element.id == hotelId);
    final reviewsData = Provider.of<HotelDataProvider>(context).reviewsList;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                foregroundColor: Colors.white,
                systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarIconBrightness: Brightness.light),
                expandedHeight: MediaQuery.of(context).size.height * 0.4,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(hotelDetailsData.hotelDetail.hotelName,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 24, fontWeight: FontWeight.w600)),
                  background: Hero(
                    tag: hotelDetailsData.id,
                    child: Image(
                      image:
                          NetworkImage(hotelDetailsData.hotelDetail.hotelImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.home,
                                              size: 20, color: Colors.grey),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            '${hotelDetailsData.hotelDetail.city}, ${hotelDetailsData.hotelDetail.region}',
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0XFF0F2C67)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            roomPerNIghtWidget()
                          ],
                        ),
                      ),
                      feature.HotelFeatures(
                          parking: hotelDetailsData.services.parking,
                          balcony: hotelDetailsData.services.balcony,
                          bed: hotelDetailsData.services.bed,
                          breakfast: hotelDetailsData.services.breakfast),
                      SizedBox(
                        height: 10,
                      ),
                      Text('About Hotel',
                          style: GoogleFonts.robotoCondensed(
                              color: Color(0XFF0F2C67),
                              fontSize: 18,
                              fontWeight: FontWeight.w700)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          hotelDetailsData.hotelDetail.hotelDescription,
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Location Detail',
                                style: GoogleFonts.robotoCondensed(
                                    color: Color(0XFF0F2C67),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.home, size: 20, color: Colors.grey),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotelDetailsData.hotelDetail.hotelAddress,
                                      style: GoogleFonts.robotoCondensed(
                                          fontSize: 18,
                                          color: Colors.grey.shade800),
                                    ),
                                    Text(
                                      '${hotelDetailsData.hotelDetail.city}, ${hotelDetailsData.hotelDetail.region}',
                                      style: GoogleFonts.robotoCondensed(
                                          fontSize: 18,
                                          color: Colors.grey.shade800),
                                    ),
                                    Text(
                                      hotelDetailsData.hotelDetail.country,
                                      style: GoogleFonts.robotoCondensed(
                                          fontSize: 18,
                                          color: Colors.grey.shade800),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(hotelDetailsData.hotelDetail.phone,
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 18,
                                        color: Colors.grey.shade800))
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(hotelDetailsData.ownerDetail.email,
                                    style: GoogleFonts.robotoCondensed(
                                        fontSize: 18,
                                        color: Colors.grey.shade800))
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () {
                                  getRoomsList(hotelDetailsData.id);
                                  Navigator.of(context).pushNamed(
                                      HotelRooms.hotelRoomRoute,
                                      arguments: hotelDetailsData.id);
                                },
                                child: Text(
                                  'View Rooms',
                                  style: GoogleFonts.robotoCondensed(
                                      fontSize: 20, color: Color(0XFF0F2C67)),
                                ))
                          ],
                        ),
                      ),
                      Divider(),
                      reviewBarWidget(reviewsData, context, hotelDetailsData),
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount:
                            reviewsData.length > 3 ? 3 : reviewsData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ReviewTile(
                              reviewsData[index]['review'],
                              reviewsData[index]['image'],
                              reviewsData[index]['ratings'] + 0.0,
                              DateTime.parse(
                                  reviewsData[index]['createdAt'].toString()));
                        },
                      ),
                    ],
                  ),
                )
              ]))
            ],
          )),
    );
  }

  Column roomPerNIghtWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Rooms from',
          style: GoogleFonts.robotoCondensed(color: Colors.grey),
        ),
        Text(
          '\$ 160',
          style: GoogleFonts.robotoCondensed(
              color: Color(0XFF0F2C67),
              fontSize: 25,
              fontWeight: FontWeight.w700),
        ),
        Text(
          '/per night',
          style: GoogleFonts.robotoCondensed(fontSize: 18),
        ),
      ],
    );
  }

  SizedBox reviewBarWidget(
      List<dynamic> reviewsData, BuildContext context, Hotel hotelDetailsData) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Reviews',
                    style: GoogleFonts.robotoCondensed(
                        color: Color(0XFF0F2C67),
                        fontSize: 19,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '(${reviewsData.length})',
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return HotelReviewsScreen(
                          hotelDetailsData.services.rating + 0.0,
                          hotelDetailsData.id);
                    }));
                  },
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 18, color: Color(0XFF0F2C67)),
                      ),
                      Icon(
                        Icons.arrow_right_outlined,
                        color: Colors.red,
                        size: 25,
                      )
                    ],
                  ))
            ],
          ),
          Row(
            children: [
              ratingBar(hotelDetailsData.services.rating + 0.0),
              Text('(${hotelDetailsData.services.rating} / 5)')
            ],
          ),
        ],
      ),
    );
  }

  RatingBar ratingBar(double rating) {
    return RatingBar(
        initialRating: rating,
        allowHalfRating: true,
        itemSize: 25,
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
              Icons.star_outline,
              color: Colors.grey.shade800,
            )),
        ignoreGestures: true,
        onRatingUpdate: (_) {});
  }

  //// Getting List of related hotel
  getRoomsList(String hotelId) async {
    var response = await FunctionsProvider.getRoomsList(hotelId);
    log('Room Data :: $response');
    setState(() {
      Provider.of<HotelDataProvider>(context, listen: false)
          .setRoomsData(RoomsData.fromJson(response));
    });
  }
}
