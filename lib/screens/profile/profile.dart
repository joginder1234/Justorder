import 'package:flutter/material.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/common/get_started.dart';
import 'package:justorderuser/screens/order_history/hotel_booking_history.dart';
import 'package:justorderuser/screens/order_history/restaurant_orders.dart';
import 'package:justorderuser/screens/profile/change_password.dart';
import 'package:justorderuser/screens/profile/edit_profile.dart';
import 'package:justorderuser/screens/profile/payment.dart';
import 'package:justorderuser/screens/profile/setting.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _getCurrentUserDetails();
  }

  var userDetails = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text("Profile")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            loading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ListTile(
                    title: Text(
                        "${userDetails['firstName']} ${userDetails['lastName']}"),
                    subtitle: Text("Edit Profile"),
                    trailing: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage("${userDetails['image']}"),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => EditProfile(
                                    userDetails: userDetails,
                                  ))).then((value) => {
                            if (value != null)
                              {
                                setState(() {
                                  userDetails['firstName'] = value['firstName'];
                                  userDetails['lastName'] = value['lastName'];
                                })
                              }
                          });
                    },
                  ),
            Divider(),
            ListTile(
              title: Text("Change Password"),
              trailing: Icon(Icons.lock),
              onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ChangePassword())),
            ),
            ListTile(title: Text("Help Center"), trailing: Icon(Icons.info)),
            ListTile(
                title: Text("Settings"),
                trailing: Icon(Icons.settings),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Settings()))),
            const Divider(
              thickness: 1,
            ),
            ListTile(
                title: Text("Hotel Bookings"),
                trailing: Icon(Icons.navigate_next),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => HotelBookingHistory()))),
            ListTile(
                title: Text("Restaurant Orders"),
                trailing: Icon(Icons.navigate_next),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RestaurantOrders()))),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: 40,
            ),
            ListTile(
              title: Text("Log Out"),
              trailing: Icon(Icons.logout),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  _logout() async {
    bool isTokenRemoved = await AuthProvider.removeToken();
    if (isTokenRemoved) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => GetStarted()));
    }
  }

  _getCurrentUserDetails() async {
    try {
      var data = await AuthProvider.userDetails();
      setState(() {
        userDetails = data;
        loading = false;
      });
    } catch (e) {
      CustomToast.showToast(e.toString());
    }
  }
}
