import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_details.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HotelTiles extends StatefulWidget {
  final String hotelId;
  final String hotelImage;
  final String hotelName;
  final double price;
  final String hotelAddress;
  final double hotelRatings;
  HotelTiles(this.hotelId, this.hotelImage, this.hotelName, this.price,
      this.hotelAddress, this.hotelRatings);

  @override
  State<HotelTiles> createState() => _HotelTilesState();
}

class _HotelTilesState extends State<HotelTiles> {
  bool _isFavorite = false;

  getallReviews(String hotelId) async {
    try {
      var reviews =
          await HttpWrapper.sendGetRequest(url: ALL_REVIEWS + '/$hotelId');

      if (reviews['success'] == true) {
        setState(() {
          Provider.of<HotelDataProvider>(context, listen: false)
              .setreviewList((reviews['reviews']));
        });
      } else {
        CustomToast.showToast(reviews['message']);
      }
    } catch (e) {
      print('function Error : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        getallReviews(widget.hotelId);
        Navigator.of(context).pushNamed(HotelDetailsScreen.hotelDetailRoute,
            arguments: widget.hotelId);
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
                  height: 130,
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: CachedNetworkImage(
                        imageUrl: widget.hotelImage,
                        imageBuilder: (ctx, ImageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: ImageProvider, fit: BoxFit.cover))),
                      )

                      //  widget.hotelImage != null &&
                      //         widget.hotelImage.isNotEmpty
                      //     ? Hero(
                      //         tag: widget.hotelId,
                      //         child: Image(
                      //           image: NetworkImage(widget.hotelImage),
                      //           fit: BoxFit.cover,
                      //         ),
                      //       )
                      //     : Placeholder(),
                      ),
                ),
                Container(
                  height: 110,
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.hotelName,
                        style: GoogleFonts.robotoCondensed(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // FaIcon(
                          //   FontAwesomeIcons.dollarSign,
                          //   size: 25,
                          //   color: Colors.grey,
                          // ),
                          Text(
                            '\$${widget.price}',
                            style: GoogleFonts.robotoCondensed(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                        ],
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
                                widget.hotelAddress,
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
                          initialRating: widget.hotelRatings,
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
  }
}
