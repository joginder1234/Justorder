import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:justorderuser/screens/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final GlobalKey<FormState> resetPassKey = GlobalKey<FormState>();
  int formState = 0;
  String action = 'email';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      formState = 1;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _otpController.dispose();
    _passController.dispose();
    _confirmpassController.dispose();
  }

  sendResetEmail() async {
    if (resetPassKey.currentState!.validate()) {
      Map<String, dynamic> emailBody = {'email': _emailController.text.trim()};

      try {
        var response = await HttpWrapper.sendResetPassPostRequest(
            url: SEND_PASSRESET, body: emailBody);
        if (response['success'] == true) {
          setState(() {
            formState = 2;
          });
        }
        print('Reset Response :: $response');
      } catch (e) {
        CustomToast.showToast(e.toString());
      }
    }
  }

  verifyOtp() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (resetPassKey.currentState!.validate()) {
      Map<String, dynamic> verifyData = {
        'Otp': _otpController.text.trim(),
        'userId': _prefs.getString('CurrentUserId')
      };
      try {
        var otpResponse = await HttpWrapper.sendResetPassPostRequest(
            url: VERYFY_OTP, body: verifyData);
        if (otpResponse['success'] == true) {
          setState(() {
            formState = 3;
          });
        }
        print('Otp Response :: $otpResponse');
      } catch (e) {
        CustomToast.showToast(e.toString());
      }
    }
  }

  resetPassword() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (resetPassKey.currentState!.validate()) {
      Map<String, dynamic> passData = {
        'password': _passController.text.trim(),
        'userId': _prefs.getString('CurrentUserId')
      };
      try {
        var resetResponse = await HttpWrapper.sendResetPassPostRequest(
            url: NEW_PASS_SET, body: passData);
        if (resetResponse['success'] == true) {
          CustomToast.showToast(resetResponse['message']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (route) => false);
        }
        print('PassResponse :: $resetResponse');
      } catch (e) {
        CustomToast.showToast(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF398AE5),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: AnimatedContainer(
              // padding: EdgeInsets.all(20),
              duration: Duration(milliseconds: 300),
              width: MediaQuery.of(context).size.width,
              height: formState == 1
                  ? 210
                  : formState == 2
                      ? 330
                      : formState == 3
                          ? 400
                          : 0,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter email address',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AnimatedContainer(
                      duration: Duration(microseconds: 300),
                      height: formState == 2
                          ? 200
                          : formState == 3
                              ? 270
                              : 80,
                      child: SingleChildScrollView(
                        child: Form(
                          key: resetPassKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTextField(_emailController,
                                  'user@email.com', Icons.email),
                              const SizedBox(
                                height: 20,
                              ),
                              formState == 2 ? _buildOTPField() : Container(),
                              formState == 3 ? _buildNewPass() : Container()
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildButton(formState == 1
                        ? 'SEND'
                        : formState == 2
                            ? 'VERIFY'
                            : formState == 3
                                ? 'CONFIRM AND SUBMIT'
                                : '')
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Widget _buildNewPass() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter New Password',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(
          height: 10,
        ),
        _buildPassField(_passController, 'Enter Password', Icons.lock),
        const SizedBox(
          height: 10,
        ),
        _buildConfirmPassField(
            _confirmpassController, 'Re-Enter Password', Icons.lock),
      ],
    );
  }

  Widget _buildButton(
    String title,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black)),
              onPressed: () {
                if (formState == 1) {
                  sendResetEmail();
                } else if (formState == 2) {
                  verifyOtp();
                  // setState(() {
                  //   formState = 3;
                  // });
                } else if (formState == 3) {
                  resetPassword();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController cont, String hint, IconData icon) {
    return TextFormField(
      readOnly: formState == 2 || formState == 3 ? true : false,
      keyboardType: TextInputType.emailAddress,
      controller: cont,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade500,
          ),
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none)),
      validator: (v) {
        if (!v.toString().contains('@')) {
          return 'Please enter valid email address';
        }
      },
    );
  }

  Widget _buildPassField(
      TextEditingController cont, String hint, IconData icon) {
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      controller: cont,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade500,
          ),
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none)),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter new password";
        }
      },
    );
  }

  Widget _buildConfirmPassField(
      TextEditingController cont, String hint, IconData icon) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: cont,
      decoration: InputDecoration(
          fillColor: Colors.grey.shade200,
          prefixIcon: Icon(
            icon,
            color: Colors.grey.shade500,
          ),
          filled: true,
          hintText: hint,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none)),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please re-enter password';
        } else if (_passController.text != _confirmpassController.text) {
          return 'Password and Confirm Password does not match';
        }
      },
    );
  }

  Widget _buildOTPField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter OTP',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 200,
          child: TextFormField(
            obscureText: true,
            keyboardType: TextInputType.number,
            controller: _otpController,
            textAlign: TextAlign.center,
            style: TextStyle(
              letterSpacing: 20,
            ),
            maxLength: 6,
            decoration: InputDecoration(
                fillColor: Colors.grey.shade200,
                filled: true,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20)),
                hintText: 'ENTER OTP',
                hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    letterSpacing: 0,
                    fontSize: 16)),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter otp';
              }
            },
          ),
        ),
      ],
    );
  }
}
