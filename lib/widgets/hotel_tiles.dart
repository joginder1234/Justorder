import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_details.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_functions.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelTiles extends StatefulWidget {
  final String hotelId;
  final String hotelImage;
  final String hotelName;
  final String hotelAddress;
  final double hotelRatings;
  final Function onDelete;
  HotelTiles(this.hotelId, this.hotelImage, this.hotelName, this.hotelAddress,
      this.hotelRatings, this.onDelete);

  @override
  State<HotelTiles> createState() => _HotelTilesState();
}

class _HotelTilesState extends State<HotelTiles> {
  bool _isFavorite = false;
  String userId = '';
  Map<String, dynamic> thisHotel = {};
  bool loadingPrice = false;

  double price = 0.0;
  @override
  void initState() {
    super.initState();
    getFavouriteList();
    getRoomPrice(widget.hotelId);
  }

  getFavouriteList() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      await HttpWrapper.sendGetRequest(url: FVT_LIST).then((value) {
        (value['favourites'] as List).forEach((element) {
          if (element['hotelId'] == widget.hotelId) {
            print('True');
            print('Fatch bool :: ${element['favourite']}');
            setState(() {
              thisHotel = element;
              _isFavorite = element['favourite'];
            });
          }
        });
      });
    } catch (e) {
      print('getFavt Error :: $e');
    }
  }

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

  addFavourite() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      Map<String, dynamic> data = {
        'userId': _prefs.getString('userId'),
        'hotelId': widget.hotelId,
        'favourite': _isFavorite.toString()
      };
      await HttpWrapper.sendPostRequest(url: ADD_FVT, body: data).then((value) {
        print('Favourite Value :: $value');
        getFavouriteList();
      });
    } catch (e) {
      print('Favt. Error :: $e');
    }
  }

  getRoomPrice(String hotelId) async {
    setState(() {
      loadingPrice = true;
    });
    var roomsList = await FunctionsProvider.getRoomsList(hotelId);
    var priceList = (roomsList as List).map((e) => e['type']).toList();
    var tprice = priceList.reduce((value, element) =>
        value['Price'] < element['Price'] ? value : element)['Price'];
    if (mounted) {
      setState(() {
        price = double.parse(tprice.toString());

        loadingPrice = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!mounted) {
          return;
        }
        setState(() {
          Provider.of<HotelDataProvider>(context, listen: false).hotelPrice =
              price;
        });
        getallReviews(widget.hotelId);
        Navigator.of(context).pushNamed(HotelDetailsScreen.hotelDetailRoute,
            arguments: widget.hotelId);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15)),
                      child: Hero(
                        tag: widget.hotelId,
                        child: CachedNetworkImage(
                          imageUrl: widget.hotelImage,
                          imageBuilder: (ctx, ImageProvider) => Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: ImageProvider,
                                      fit: BoxFit.cover))),
                        ),
                      )),
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
                          loadingPrice
                              ? Image(
                                  image: AssetImage('assets/priceLoad.gif'),
                                  width: 90,
                                )
                              : Text(
                                  '\$$price',
                                  style: GoogleFonts.robotoCondensed(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w600),
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
            Positioned(
                top: 5,
                right: 5,
                child: _isFavorite
                    ? fvtIconBtn(
                        Icon(
                          Icons.favorite,
                          size: 20,
                          color: Colors.red,
                        ), () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                        widget.onDelete();
                      })
                    : fvtIconBtn(
                        Icon(
                          Icons.favorite_border,
                          size: 20,
                          color: Colors.red,
                        ), () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                        addFavourite();
                      }))
          ],
        ),
      ),
    );
  }

  Container fvtIconBtn(Icon icon, Function addFvt) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      width: 35,
      decoration: BoxDecoration(
          color: Colors.grey.shade100.withOpacity(0.5),
          borderRadius: BorderRadius.circular(100)),
      child: IconButton(
          onPressed: () {
            addFvt();
          },
          icon: icon),
    );
  }
}
