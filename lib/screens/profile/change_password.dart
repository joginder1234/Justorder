import 'package:flutter/material.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/common/custom_toast.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _isLoading = false;
  TextEditingController _oldPassowrd = TextEditingController();
  TextEditingController _newPassowrd = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool _hidePassowrd = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            "Change Password",
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              customTextField(
                  "Enter Old Password", "Old Password", _oldPassowrd),
              customTextField(
                  "Enter New Password", "New Password", _newPassowrd),
              GestureDetector(
                onTap: _chanegePassword,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: _isLoading
                      ? BoxDecoration()
                      : BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5)),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Center(
                          child: Text("Save",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(
      String hint, String label, TextEditingController controller) {
    return Container(
      height: 70,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        controller: controller,
        enabled: !_isLoading,
        obscureText: _hidePassowrd,
        validator: (value) => value!.isEmpty ? "Please enter $label" : null,
        decoration: InputDecoration(
            suffix: IconButton(
                onPressed: () {
                  setState(() {
                    _hidePassowrd = !_hidePassowrd;
                  });
                },
                icon: _hidePassowrd
                    ? Icon(Icons.remove_red_eye)
                    : Icon(Icons.close)),
            border: OutlineInputBorder(),
            hintText: hint,
            labelText: label),
      ),
    );
  }

  _chanegePassword() async {
    try {
      if (_key.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        var body = {
          "oldPassword": _oldPassowrd.text.trim(),
          "newPassword": _newPassowrd.text.trim()
        };
        var data = await AuthProvider.changePasswords(body);
        CustomToast.showToast("${data['message']}");
        if (data['success']) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pop(context);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      CustomToast.showToast("${e.toString()}");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
