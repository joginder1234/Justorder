import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelFeatures extends StatelessWidget {
  final bool parking;
  final bool balcony;
  final bool bed;
  final bool breakfast;
  const HotelFeatures(
      {Key? key,
      required this.parking,
      required this.balcony,
      required this.bed,
      required this.breakfast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 3)],
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          feature_tile(
              FaIcon(
                Icons.car_repair_outlined,
                color: parking ? Colors.green : Colors.green.shade100,
                size: 30,
              ),
              'Parking'),
          feature_tile(
              FaIcon(
                Icons.balcony,
                color: balcony ? Colors.green : Colors.green.shade100,
                size: 30,
              ),
              'Balcony'),
          feature_tile(
              FaIcon(
                Icons.bed_sharp,
                color: bed ? Colors.green : Colors.green.shade100,
                size: 30,
              ),
              'Bed'),
          feature_tile(
              FaIcon(
                Icons.free_breakfast_outlined,
                color: breakfast ? Colors.green : Colors.green.shade100,
                size: 30,
              ),
              'Breakfast'),
        ],
      ),
    );
  }

  Column feature_tile(FaIcon icon, String text) {
    return Column(
      children: [
        icon,
        SizedBox(
          height: 5,
        ),
        Text(text,
            style: GoogleFonts.robotoCondensed(
                fontWeight: FontWeight.w600, color: Colors.grey))
      ],
    );
  }
}
