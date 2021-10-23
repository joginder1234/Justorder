import 'package:flutter/material.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/common/get_started.dart';
import 'package:justorderuser/screens/auth/login.dart';
import 'package:justorderuser/screens/base_widget.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'assets/background.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  checkUser() async {
    try {
      bool isCurretUserValid = await AuthProvider.currentUser();
      if (isCurretUserValid) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => BaseWidget()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    } catch (e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => GetStarted()));
    }
  }
}
