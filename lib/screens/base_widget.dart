import 'package:flutter/material.dart';
import 'package:justorderuser/explore.dart';
import 'package:justorderuser/screens/profile/profile.dart';
import 'package:justorderuser/screens/search/search.dart';
import 'package:justorderuser/screens/trips/trips.dart';

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
  List<Widget> _screens = [Explore(), Trips(), Search(), Profile()];
  List<CustomIconAndLabel> _icons = [
    CustomIconAndLabel(title: "Explore", icon: Icons.explore),
    CustomIconAndLabel(title: "Services", icon: Icons.location_on_outlined),
    CustomIconAndLabel(title: "Trips", icon: Icons.favorite_border),
    CustomIconAndLabel(title: "Search", icon: Icons.search),
    CustomIconAndLabel(title: "Profile", icon: Icons.person),
  ];
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
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          items: _icons
              .map((e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
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
