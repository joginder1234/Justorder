import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/modals/hotel_detail.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/widgets/review_tile.dart';
import 'package:provider/provider.dart';

class HotelReviewsScreen extends StatelessWidget {
  double overallRatings;
  String hotelId;
  HotelReviewsScreen(this.overallRatings, this.hotelId);

  static const hotelReviewsRoute = '/hotelReviewsScreen';

  @override
  Widget build(BuildContext context) {
    var allReviews = Provider.of<HotelDataProvider>(context).reviewsList;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Reviews'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Reviews',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 22, fontWeight: FontWeight.w600)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ratingBar(overallRatings),
                          Text(
                            '($overallRatings / 5)',
                            style: TextStyle(fontSize: 16),
                          )
                        ],
                      ),
                      Chip(
                          label: Text(
                        '${allReviews.length} Reviews',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ))
                    ],
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: allReviews.length,
              itemBuilder: (BuildContext context, int index) {
                return ReviewTile(
                    allReviews[index]['review'],
                    allReviews[index]['image'],
                    allReviews[index]['ratings'] + 0.0,
                    DateTime.parse(allReviews[index]['createdAt'].toString()));
              },
            ),
          ],
        ),
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
        onRatingUpdate: (value) {});
  }
}
