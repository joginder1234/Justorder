import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:justorderuser/backend/config/key.dart';
import 'package:justorderuser/common/splash.dart';
import 'package:justorderuser/backend/providers/source_provider.dart';
import 'package:justorderuser/backend/providers/restaurant_provider.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_details.dart';
import 'package:justorderuser/screens/explore/hotels/hotel_rooms.dart';
import 'package:justorderuser/screens/explore/restaurant/menu_details.dart';
import 'package:justorderuser/screens/order_history/booking_history_details.dart';
import 'package:justorderuser/screens/order_history/restaurant_orders.dart';
import 'package:provider/provider.dart';

void main() {
  Stripe.publishableKey = PK_KEY_TEST;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HotelDataProvider()),
        ChangeNotifierProvider(create: (context) => ResaurantsDataProvider()),
        ChangeNotifierProvider(create: (context) => Quantity())
      ],
      child: MaterialApp(
        title: 'Justorder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            buttonColor: Color(0XFF0F2C67),
            appBarTheme: AppBarTheme(
                brightness: Brightness.light,
                color: Color(0XFF0F2C67),
                elevation: 0,
                textTheme: TextTheme(
                    headline5: TextStyle(
                  color: Colors.black,
                )))),
        home: SplashScreen(),
        routes: {
          HotelDetailsScreen.hotelDetailRoute: (ctx) => HotelDetailsScreen(),
          HotelRooms.hotelRoomRoute: (ctx) => HotelRooms(),
          MenuDetails.menuDetailRoute: (ctx) => MenuDetails(),
          BookingHistoryDetails.bookingHistoryRoute: (ctx) =>
              BookingHistoryDetails(),
          RestaurantOrders.restOrderRoute: (ctx) => RestaurantOrders(),

          // HotelReviewsScreen.hotelReviewsRoute: (ctx) => HotelReviewsScreen(),
        },
      ),
    );
  }
}
