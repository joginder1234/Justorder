import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _currentCurrency = "...";
  List<String> _preferences = ['PKR', 'USD', 'EUR', 'GBP', 'INR'];

  @override
  void initState() {
    super.initState();
    getCurrentCurrency();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: Colors.black)),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTile(
              title: Text("Currency"),
              trailing: Text("$_currentCurrency"),
              children: _preferences
                  .map((e) => ListTile(
                        title: Text("$e"),
                        trailing: e == _currentCurrency
                            ? Icon(Icons.check_circle, color: Colors.green)
                            : Icon(Icons.radio_button_off),
                        onTap: () => setCurrency(e),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  getCurrentCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("currency") == null) {
      setState(() {
        _currentCurrency = "\$ USD";
      });
    } else {
      setState(() {
        _currentCurrency = prefs.getString("currency") as String;
      });
    }
  }

  setCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("currency", currency);
    });
    getCurrentCurrency();
  }
}
