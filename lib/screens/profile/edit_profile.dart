import 'package:flutter/material.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/common/custom_toast.dart';

class EditProfile extends StatefulWidget {
  final Map userDetails;
  EditProfile({Key? key, required this.userDetails}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController address = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  setData() async {
    setState(() {
      firstName.text = widget.userDetails['firstName'];
      lastName.text = widget.userDetails['lastName'];
      mobile.text = widget.userDetails['mobile'];
      address.text = widget.userDetails['address'];
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          'Edit',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [IconButton(onPressed: saveProfile, icon: Icon(Icons.check))],
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading ? LinearProgressIndicator() : Container(),
            customTextField("Enter your Firstname", "First Name", firstName),
            customTextField("Enter your lastname", "Last Name", lastName),
            customTextField("Enter your mobile", "Mobile", mobile),
            customTextField("Enter your address", "Address", address),
          ],
        ),
      )),
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

  saveProfile() async {
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        var body = {
          "firstName": firstName.text.trim(),
          "lastName": lastName.text.trim(),
          "mobile": mobile.text.trim(),
          "address": address.text.trim(),
        };
        bool isProfileUpdated = await AuthProvider.updateUserDetails(body);
        print(isProfileUpdated);
        if (isProfileUpdated) {
          CustomToast.showToast("Success");
          setState(() {
            _isLoading = true;
          });
          Navigator.of(context).pop(body);
        } else {
          CustomToast.showToast("Something went wrong.Try again later");
          setState(() {
            _isLoading = true;
          });
        }
      }
    } catch (e) {
      CustomToast.showToast(e.toString());
      setState(() {
        _isLoading = true;
      });
    }
  }
}
