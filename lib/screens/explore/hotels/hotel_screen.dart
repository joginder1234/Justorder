import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/modals/hotel_detail.dart';
import 'package:justorderuser/modals/rooms_details.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_details.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_functions.dart';
import 'package:justorderuser/widgets/hotel_tiles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelsExplore extends StatefulWidget {
  HotelsExplore({Key? key}) : super(key: key);

  @override
  _HotelsExploreState createState() => _HotelsExploreState();
}

class _HotelsExploreState extends State<HotelsExplore> {
  bool loading = true;
  TextEditingController _searchController = TextEditingController();
  List<Hotel> _searchHotel = [];
  List fvtHotel = [];
  List<RoomsData> rooms = [];

  @override
  void dispose() {
    super.dispose();
    TextEditingController().dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  //// While Searching for custom Hotels
  onSearching(String value, List<Hotel> hotelList) {
    setState(() {
      _searchHotel = hotelList
          .where((element) => element.hotelDetail.hotelName
              .contains(value == '' ? 'abcdefghij' : value))
          .toList();
    });
  }

  //// getting reviews
  getallReviews(String hotelId) async {
    var response = FunctionsProvider.getallReviews(hotelId);
    setState(() {
      Provider.of<HotelDataProvider>(context, listen: false)
          .setreviewList((response));
    });
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
        // getFavouriteList();
        print('Fvrt remove Response :: $value');
      });
    } catch (e) {
      CustomToast.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final hotelDetails = Provider.of<HotelDataProvider>(context).hotelData;
    final roomsList = Provider.of<HotelDataProvider>(context).roomsList;

    return GestureDetector(
      onTap: () {
        setState(() {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
          _searchHotel.clear();
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: hotelDetails == null || hotelDetails.isEmpty
            ? Center(
                child: Text('No Hotel found in database'),
              )
            : Stack(children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: 'Search Hotels...'),
                              onChanged: (v) => onSearching(v, hotelDetails),
                            )),
                        Container(
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
                                  hotelDetails[index].hotelDetail.hotelAddress,
                                  hotelDetails[index].services.rating + 0.0,
                                  () {
                                removeFavourite(hotelDetails[index].id);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _searchHotel.isEmpty
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 65, right: 15, left: 15),
                        padding: EdgeInsets.fromLTRB(1, 0, 15, 15),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(color: Colors.grey.shade500, blurRadius: 3)
                        ]),
                        width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height - 200,
                        constraints: BoxConstraints(
                            maxHeight:
                                MediaQuery.of(context).size.height - 200),
                        child: ListView.builder(
                            itemCount: _searchHotel.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, i) => ListTile(
                                onTap: () {
                                  getallReviews(_searchHotel[i].id);
                                  Navigator.of(context).pushNamed(
                                      HotelDetailsScreen.hotelDetailRoute,
                                      arguments: _searchHotel[i].id);
                                  setState(() {
                                    _searchController.clear();
                                    FocusScope.of(context).unfocus();
                                    _searchHotel.clear();
                                  });
                                },
                                leading: Container(
                                  height: 50,
                                  width: 50,
                                  decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: Image.network(
                                      _searchHotel[i].hotelDetail.hotelImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                title:
                                    Text(_searchHotel[i].hotelDetail.hotelName),
                                subtitle: Text(
                                    _searchHotel[i].hotelDetail.hotelAddress),
                                trailing: Icon(Icons.navigate_next))),
                      )
              ]),
      ),
    );
  }
}
