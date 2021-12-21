import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/screens/base_widget.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController address = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Sign up", style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customTextField("Enter your Firstname", "First Name", firstName),
            customTextField("Enter your lastname", "Last Name", lastName),
            customTextField("Enter your email", "Email", email),
            customTextField("Enter your password", "Password", password),
            customTextField("Enter your mobile", "Mobile", mobile),
            customTextField("Enter your address", "Address", address),
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: GestureDetector(
          onTap: _isLoading ? null : _signUp,
          child: _isLoading
              ? Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Text("Sign Up",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
        ),
      ),
    );
  }

  Widget customTextField(
      String hint, String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        controller: controller,
        enabled: !_isLoading,
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
        decoration: InputDecoration(
            border: OutlineInputBorder(), hintText: hint, labelText: label),
      ),
    );
  }

  _signUp() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        var body = {
          "firstName": firstName.text.trim(),
          "lastName": lastName.text.trim(),
          "email": email.text.trim(),
          "password": password.text.trim(),
          "mobile": mobile.text.trim(),
          "address": address.text.trim(),
        };
        var isLoginSuccess = await AuthProvider.singUp(body);

        if (isLoginSuccess) {
          setState(() {
            _isLoading = false;
          });
          _goToBaseWidgets();
        }
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _goToBaseWidgets() async {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => BaseWidget()));
  }
}
