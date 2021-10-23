import 'package:flutter/material.dart';
import 'package:justorderuser/screens/auth/login.dart';

class GetStarted extends StatefulWidget {
  GetStarted({Key? key}) : super(key: key);

  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black26),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover)),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
              top: size.height * 0.5,
              left: size.width * 0.1,
              right: size.width * 0.05,
              child: Text(
                "Best Deals for your holidays",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
          Positioned(
              bottom: size.height * 0.025,
              left: size.width * 0.025,
              right: size.width * 0.025,
              child: GestureDetector(
                onTap: _goToLogInPage,
                child: Container(
                  height: 50,
                  width: size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text("Get Started",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ))
        ]));
  }

  _goToLogInPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
