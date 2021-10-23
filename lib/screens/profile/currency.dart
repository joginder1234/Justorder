import 'package:flutter/material.dart';

class Currency extends StatefulWidget {
  Currency({Key? key}) : super(key: key);

  @override
  _CurrencyState createState() => _CurrencyState();
}

class _CurrencyState extends State<Currency> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select currency"),
      ),
    );
  }
}
