import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/rooms_details.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_rooms.dart';
import 'package:justorderuser/screens/explore/hotels/reviews_screen.dart';
import 'package:justorderuser/widgets/features.dart';
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
    print('Data of reviews : ${reviewsData}');

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: Colors.transparent),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.brown.shade400,
                foregroundColor: Colors.black,
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
                                                color: Colors.grey.shade800),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rooms from',
                                  style: GoogleFonts.robotoCondensed(
                                      color: Colors.grey),
                                ),
                                Text(
                                  '\$ 160',
                                  style: GoogleFonts.robotoCondensed(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '/per night',
                                  style:
                                      GoogleFonts.robotoCondensed(fontSize: 18),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      HotelFeatures(
                          parking: hotelDetailsData.services.parking,
                          balcony: hotelDetailsData.services.balcony,
                          bed: hotelDetailsData.services.bed,
                          breakfast: hotelDetailsData.services.breakfast),
                      SizedBox(
                        height: 10,
                      ),
                      Text('About Hotel',
                          style: GoogleFonts.robotoCondensed(
                              fontSize: 18, fontWeight: FontWeight.w500)),
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
                                    fontSize: 18, fontWeight: FontWeight.w500)),
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
                                  style:
                                      GoogleFonts.robotoCondensed(fontSize: 20),
                                ))
                          ],
                        ),
                      ),
                      Divider(),
                      SizedBox(
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (ctx) {
                                        return HotelReviewsScreen(
                                            hotelDetailsData.services.rating +
                                                0.0,
                                            hotelDetailsData.id);
                                      }));
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'View All',
                                          style: GoogleFonts.robotoCondensed(
                                              fontSize: 18),
                                        ),
                                        Icon(
                                          Icons.arrow_right_outlined,
                                          size: 25,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                            Row(
                              children: [
                                ratingBar(
                                    hotelDetailsData.services.rating + 0.0),
                                Text(
                                    '(${hotelDetailsData.services.rating} / 5)')
                              ],
                            ),
                          ],
                        ),
                      ),
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

  getRoomsList(String hotelId) async {
    try {
      var hotelRoomsData =
          await HttpWrapper.sendGetRequest(url: HOTEL_ROOMS_LIST + '/$hotelId');
      if (hotelRoomsData['success'] == true) {
        print(hotelRoomsData['room']);
        (hotelRoomsData['rooms'] as List).forEach((element) {
          print("room elements: $element");
          setState(() {
            Provider.of<HotelDataProvider>(context, listen: false)
                .setRoomsData(RoomsData.fromJson(element));
          });
        });
        // setState(() {
        //   Provider.of<HotelDataProvider>(context, listen: false)
        //       .setRoomsData(RoomsData.fromJson(RoomsData['room']));
        // });
      } else {
        CustomToast.showToast(hotelRoomsData['message']);
      }
    } catch (e) {
      print('Function Error : $e');
    }
  }
}

class ImageTiles extends StatelessWidget {
  final String imageUrl;
  ImageTiles(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (ctx) => SimpleDialog(
                  backgroundColor: Colors.white,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Image(image: NetworkImage(imageUrl))),
                      ),
                    )
                  ],
                ));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        height: 90,
        width: 130,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.shade500, blurRadius: 3)]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
