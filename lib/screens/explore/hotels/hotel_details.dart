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
import 'package:url_launcher/url_launcher.dart';

class HotelDetailsScreen extends StatefulWidget {
  const HotelDetailsScreen({Key? key}) : super(key: key);
  static const hotelDetailRoute = '/HotelDetailsPage';

  @override
  State<HotelDetailsScreen> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetailsScreen> {
  bool _isFavorite = false;
  bool _hasCallSupport = false;
  String? phoneNumber;

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _writeEmail(String emailaddress) async {
    final Uri launchUri = Uri(scheme: 'mailto', path: emailaddress);
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    final hotelDataRef = Provider.of<HotelDataProvider>(context);

    final hotelPrice = hotelDataRef.hotelPrice;
    final hotelId = ModalRoute.of(context)!.settings.arguments as String;
    final hotelDetailsData =
        hotelDataRef.hotelData.firstWhere((element) => element.id == hotelId);
    phoneNumber = hotelDetailsData.hotelDetail.phone;
    final reviewsData = Provider.of<HotelDataProvider>(context).reviewsList;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.black26),
      child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).buttonColor)),
                onPressed: () {
                  getRoomsList(hotelDetailsData.id);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Select Room',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
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
                            roomPerNIghtWidget(hotelPrice)
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
                            ListTile(
                              leading: Icon(Icons.home,
                                  size: 20,
                                  color: Theme.of(context).buttonColor),
                              title: Wrap(
                                children: [
                                  hotelDetailsData
                                          .hotelDetail.hotelAddress.isNotEmpty
                                      ? Text(
                                          hotelDetailsData
                                                  .hotelDetail.hotelAddress +
                                              ', ',
                                          style: GoogleFonts.robotoCondensed(
                                              fontSize: 18,
                                              color: Colors.grey.shade800),
                                        )
                                      : SizedBox(),
                                  hotelDetailsData.hotelDetail.region.isNotEmpty
                                      ? Text(
                                          hotelDetailsData.hotelDetail.region +
                                              ', ',
                                          style: GoogleFonts.robotoCondensed(
                                              fontSize: 18,
                                              color: Colors.grey.shade800),
                                        )
                                      : SizedBox(),
                                  hotelDetailsData.hotelDetail.city.isNotEmpty
                                      ? Text(
                                          hotelDetailsData.hotelDetail.city +
                                              ', ',
                                          style: GoogleFonts.robotoCondensed(
                                              fontSize: 18,
                                              color: Colors.grey.shade800),
                                        )
                                      : SizedBox(),
                                  hotelDetailsData
                                          .hotelDetail.country.isNotEmpty
                                      ? Text(
                                          hotelDetailsData.hotelDetail.country,
                                          style: GoogleFonts.robotoCondensed(
                                              fontSize: 18,
                                              color: Colors.grey.shade800),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  hotelDetailsData.ownerDetail.email.isNotEmpty
                                      ? SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) *
                                              0.5,
                                          child: ListTile(
                                            onTap: () {
                                              hotelDetailsData.ownerDetail.email
                                                      .isNotEmpty
                                                  ? _writeEmail(
                                                      hotelDetailsData
                                                          .ownerDetail.email,
                                                    )
                                                  : null;
                                            },
                                            tileColor: Colors.orange,
                                            leading: Icon(
                                              Icons.email,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                                hotelDetailsData
                                                    .ownerDetail.email,
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                        fontSize: 18,
                                                        color: Colors.white)),
                                          ),
                                        )
                                      : SizedBox(),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  hotelDetailsData.hotelDetail.phone.isNotEmpty
                                      ? SizedBox(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  50) *
                                              0.5,
                                          child: ListTile(
                                            tileColor: Colors.lightGreen,
                                            onTap: () {
                                              setState(() {
                                                hotelDetailsData.hotelDetail
                                                        .phone.isNotEmpty
                                                    ? _makePhoneCall(
                                                        'tel:${hotelDetailsData.hotelDetail.phone}')
                                                    : null;
                                              });
                                            },
                                            leading: Icon(
                                              Icons.phone,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            title: Text(
                                                hotelDetailsData
                                                    .hotelDetail.phone,
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                        fontSize: 18,
                                                        color: Colors.white)),
                                          ),
                                        )
                                      : SizedBox(),
                                ],
                              ),
                            ),
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

  Column roomPerNIghtWidget(double price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Rooms from',
          style: GoogleFonts.robotoCondensed(color: Colors.grey),
        ),
        Text(
          '\$ $price',
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

    setState(() {
      Provider.of<HotelDataProvider>(context, listen: false).roomsList =
          response;
    });
    Navigator.of(context)
        .pushNamed(HotelRooms.hotelRoomRoute, arguments: hotelId);
  }
}
