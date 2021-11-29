import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/explore.dart';
import 'package:justorderuser/screens/profile/profile.dart';
import 'package:justorderuser/screens/search/search.dart';
import 'package:justorderuser/screens/services/service.dart';
import 'package:justorderuser/screens/trips/trips.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseWidget extends StatefulWidget {
  BaseWidget({Key? key}) : super(key: key);

  @override
  _BaseWidgetState createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  int _currentIndex = 0;
  _onTap(int index) => setState(() {
        _currentIndex = index;
      });
  List<Widget> _screens = [Explore(), OtherServices(), Trips(), Profile()];
  List<CustomIconAndLabel> _icons = [
    CustomIconAndLabel(title: "Explore", icon: Icons.explore),
    CustomIconAndLabel(title: "Services", icon: Icons.location_on_outlined),
    CustomIconAndLabel(title: "Trips", icon: Icons.favorite_border),
    CustomIconAndLabel(title: "Profile", icon: Icons.person),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    try {
      var data = await HttpWrapper.sendGetRequest(url: CURRENT_USER_DETAILS);
      if (data['success'] == true) {
        setState(() {
          _prefs.setString('userId', data['user']['_id']);
        });
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          child: _screens[_currentIndex], onWillPop: () async => false),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: Color(0XFF0F2C67),
          selectedLabelStyle:
              TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          items: _icons
              .map((e) => BottomNavigationBarItem(
                  icon: Icon(
                    e.icon,
                  ),
                  label: e.title,
                  backgroundColor: Colors.white))
              .toList()),
    );
  }
}

class CustomIconAndLabel {
  String title;
  IconData icon;
  CustomIconAndLabel({required this.title, required this.icon});
}
