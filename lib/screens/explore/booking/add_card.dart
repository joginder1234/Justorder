import 'package:flutter/material.dart';

class AddCardScreen extends StatefulWidget {
  AddCardScreen({Key? key}) : super(key: key);

  @override
  _AddCardScreenState createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text("Add Cards", style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
