import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantReviews extends StatefulWidget {
  const RestaurantReviews({Key? key}) : super(key: key);

  @override
  State<RestaurantReviews> createState() => _CommentsBarState();
}

class _CommentsBarState extends State<RestaurantReviews> {
  List restReviews = [];
  String restId = '';
  bool _isloading = false;

  @override
  void initState() {
    super.initState();

    getallReviews();
  }

  getallReviews() async {
    setState(() {
      _isloading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      var reviews = await HttpWrapper.sendGetRequest(
          url: ALL_REVIEWS + '/${_prefs.getString('restId')}');

      if (reviews['success'] == true) {
        setState(() {
          restReviews = reviews['reviews'];
          _isloading = false;
        });
        print('Total Reviews Saved :: ${restReviews.length}');
      } else {
        CustomToast.showToast(reviews['message']);
        setState(() {
          _isloading = false;
        });
      }
    } catch (e) {
      print('function Error : $e');
      setState(() {
        _isloading = false;
      });
    }
  }

  double rating = 4.1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            'Comment & Ratings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : restReviews == null || restReviews.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/empty.jpg'),
                          width: MediaQuery.of(context).size.width * 0.35,
                        ),
                        Text(
                          'No reviews or comments found..',
                          style: TextStyle(
                              fontSize: 18, color: Colors.grey.shade600),
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Total Reviews (${restReviews.length})',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                        ListView.builder(
                            padding: EdgeInsets.symmetric(
                              // horizontal: 15,
                              vertical: 10,
                            ),
                            shrinkWrap: true,
                            itemCount: restReviews.length,
                            itemBuilder: (ctx, i) {
                              return CommentTile(
                                image: restReviews[i]['image'],
                                rating: restReviews[i]['ratings'] + 0.0,
                                comment: restReviews[i]['review'],
                                reviewData:
                                    DateTime.parse(restReviews[i]['createdAt']),
                              );
                            }),
                      ],
                    ),
                  ));
  }
}

class CommentTile extends StatelessWidget {
  const CommentTile({
    Key? key,
    required this.image,
    required this.rating,
    required this.comment,
    required this.reviewData,
  }) : super(key: key);

  final String image;
  final double rating;
  final String comment;
  final DateTime reviewData;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              // height: MediaQuery.of(context).size.height * 0.13,
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 3,
                      offset: Offset.fromDirection(10, 0.4))
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(8),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(image),
                      maxRadius: 20,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        comment,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                    ),
                    title: Row(
                      children: [
                        RatingBar(
                            ignoreGestures: true,
                            initialRating: rating,
                            maxRating: 5,
                            allowHalfRating: true,
                            itemSize: 20,
                            ratingWidget: RatingWidget(
                                full: Icon(Icons.star, color: Colors.green),
                                half:
                                    Icon(Icons.star_half, color: Colors.green),
                                empty: Icon(Icons.star_border_outlined,
                                    color: Colors.green)),
                            onRatingUpdate: (v) {}),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          '($rating / 5)',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(blurRadius: 3, color: Colors.black)],
                color: Colors.grey.shade500,
              ),
              child: Text(
                DateFormat('yMMMd').format(reviewData),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
