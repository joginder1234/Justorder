import 'package:flutter/material.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/widgets/hotel_tiles.dart';
import 'package:provider/provider.dart';

class HotelsExplore extends StatefulWidget {
  HotelsExplore({Key? key}) : super(key: key);

  @override
  _HotelsExploreState createState() => _HotelsExploreState();
}

class _HotelsExploreState extends State<HotelsExplore> {
  bool loading = true;
  @override
  Widget build(BuildContext context) {
    final hotelDetails = Provider.of<HotelDataProvider>(context).hotelData;
    return Scaffold(
      backgroundColor: Colors.white,
      body: hotelDetails == null || hotelDetails.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'Search Hotels...'),
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
                          160,
                          hotelDetails[index].hotelDetail.hotelAddress,
                          hotelDetails[index].services.rating + 0.0);
                    },
                  ),
                )
              ],
            ),
    );
  }
}
