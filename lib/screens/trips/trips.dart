import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/modals/hotel_detail.dart';
import 'package:justorderuser/widgets/hotel_tiles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Trips extends StatefulWidget {
  Trips({Key? key}) : super(key: key);

  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  bool _isFavorite = false;
  String userId = '';
  List fvt = [];
  List<Hotel> hotelDetails = [];
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    getFavouriteList();
  }

  getFavouriteList() async {
    setState(() {
      _loading = true;
    });
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      await HttpWrapper.sendGetRequest(url: FVT_LIST).then((value) {
        setState(() {
          fvt =
              (value['favourites'] as List).map((element) => element).toList();
          hotelDetails = Provider.of<HotelDataProvider>(context, listen: false)
              .hotelData
              .where((e) => fvt.any((element) => element['hotelId'] == e.id))
              .toList();
        });
        setState(() {
          _loading = false;
        });
        print('Hotel List :: $hotelDetails');
      });
    } catch (e) {
      print('getFavt Error :: $e');
    }
  }

  removeFavourite(String id) async {
    print('Hotel Id :: $id');
    var fvtId = '';
    try {
      await HttpWrapper.sendGetRequest(url: FVT_LIST).then((value) {
        (value['favourites'] as List).forEach((element) {
          if (element['hotelId'] == id) {
            fvtId = element['_id'];
          }
        });
      });
      await HttpWrapper.sendDeleteRequest(url: REMOVE_FVT + '/$fvtId')
          .then((value) {
        getFavouriteList();
        print(value);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text('My Favourites'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.transparent,
              ),
            )
          : hotelDetails.isEmpty
              ? Center(
                  child: Text(
                    'You have marked any favourite.\nPlease add some items here...',
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.75),
                    itemCount: hotelDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HotelTiles(
                          hotelDetails[index].id,
                          hotelDetails[index].hotelDetail.hotelImage,
                          hotelDetails[index].hotelDetail.hotelName,
                          160,
                          hotelDetails[index].hotelDetail.hotelAddress,
                          hotelDetails[index].services.rating + 0.0, () {
                        removeFavourite(hotelDetails[index].id);
                      });
                    },
                  ),
                ),
    );
  }
}
