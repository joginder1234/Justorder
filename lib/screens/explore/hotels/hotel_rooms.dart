import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:justorderuser/screens/explore/booking/review_booking.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:provider/provider.dart';

class HotelRooms extends StatelessWidget {
  const HotelRooms({Key? key}) : super(key: key);
  static const hotelRoomRoute = '/Hotelrooms';

  @override
  Widget build(BuildContext context) {
    final hotelId = ModalRoute.of(context)?.settings.arguments;
    final roomsList = Provider.of<HotelDataProvider>(context).roomsList;

    final hotel = Provider.of<HotelDataProvider>(context)
        .hotelData
        .firstWhere((element) => element.id == hotelId);

    print('Total Rooms :: ${roomsList.length}');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text('Rooms', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: roomsList.isEmpty || roomsList == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  children: [
                    RoomsTiles(
                        hotel.hotelDetail.hotelName,
                        context,
                        roomsList[0].singleType.roomtype,
                        roomsList[0].singleType.price,
                        roomsList[0].singleType.kids,
                        roomsList[0].singleType.adults,
                        roomsList[0].singleType.image),
                    RoomsTiles(
                        hotel.hotelDetail.hotelName,
                        context,
                        roomsList[0].doubleType.roomType,
                        roomsList[0].doubleType.price,
                        roomsList[0].doubleType.kids,
                        roomsList[0].doubleType.adults,
                        roomsList[0].doubleType.image),
                    RoomsTiles(
                        hotel.hotelDetail.hotelName,
                        context,
                        roomsList[0].duplexType.roomtype,
                        roomsList[0].duplexType.price,
                        roomsList[0].duplexType.kids,
                        roomsList[0].duplexType.adults,
                        roomsList[0].duplexType.image),
                    RoomsTiles(
                        hotel.hotelDetail.hotelName,
                        context,
                        roomsList[0].deluxeType.roomtype,
                        roomsList[0].deluxeType.price,
                        roomsList[0].deluxeType.kids,
                        roomsList[0].deluxeType.adults,
                        roomsList[0].deluxeType.image)
                  ],
                )),
    );
  }
}

class RoomsTiles extends StatelessWidget {
  final String hotelName;
  final BuildContext context;
  final String roomType;
  final double price;
  final int kids;
  final int adults;
  final String image;

  RoomsTiles(this.hotelName, this.context, this.roomType, this.price, this.kids,
      this.adults, this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 5),
        height: MediaQuery.of(context).size.width * 0.5,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: GridTile(
              header: GridTileBar(
                title: Text(
                  roomType,
                  style: GoogleFonts.robotoCondensed(
                      shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
              ),
              footer: GridTileBar(
                backgroundColor: Colors.black.withOpacity(0.6),
                title: Row(
                  children: [
                    Text(
                      '\$ $price',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 20,
                          shadows: [Shadow(color: Colors.black, blurRadius: 5)],
                          fontWeight: FontWeight.w600,
                          color: Colors.greenAccent.shade400),
                    ),
                    Text('/ per night')
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1 Room / Kids - $kids / Adults - $adults',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) =>
                            BookingReview(image, hotelName, price, roomType)));
                  },
                  child: Chip(
                      backgroundColor: Colors.green, label: Text('Book Now')),
                ),
              ),
              child: image == null || image.isEmpty
                  ? Image(
                      image: NetworkImage(
                          'https://just-order-api.herokuapp.com//default.jpg'))
                  : Image(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    )),
        ));
  }
}