import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ReviewTile extends StatelessWidget {
  final String comment;
  final String imageUrl;
  final double rating;
  final DateTime postDate;
  ReviewTile(this.comment, this.imageUrl, this.rating, this.postDate);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(100)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ratingBar(rating),
                        Text(DateFormat('yMMMd').format(postDate))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      comment,
                      style: TextStyle(color: Colors.grey),
                      softWrap: true,
                      maxLines: 3,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  RatingBar ratingBar(double rating) {
    return RatingBar(
        initialRating: rating,
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
              Icons.star_outline,
              color: Colors.grey.shade800,
            )),
        ignoreGestures: true,
        onRatingUpdate: (value) {});
  }
}
