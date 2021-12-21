import 'dart:io';

import 'package:flutter/material.dart';
import 'package:justorderuser/backend/common/http_wrapper.dart';
import 'package:justorderuser/backend/providers/auth_provider.dart';
import 'package:justorderuser/backend/urls/urls.dart';
import 'package:justorderuser/common/custom_toast.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  File? file;
  XFile? xfile;
  List<String> imageFiles = [];
  bool _uploading = false;

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

  getImage() async {
    var img = await _picker.pickImage(source: ImageSource.gallery);

    if (img?.path == null) {
      return;
    }

    final imageSplit = img!.path.split('/');
    final imageLink = imageSplit.last;
    print('MyImage :: $imageLink');

    uploadFiles(imageLink);
  }

  uploadFiles(String imagepath) async {
    print(imagepath);

    setState(() {
      _uploading = true;
    });
    Map<String, dynamic> image = {'file': imagepath};
    var imagelink =
        await HttpWrapper.sendPostRequest(url: ADD_USER_IMAGE, body: image);
    print(imagelink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Edit',
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
            const SizedBox(
              height: 10,
            ),
            _buildImageAvatar(),
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

  Widget _buildImageAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
      height: 120,
      width: 120,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(1000),
            // child: Image(image: NetworkImage(url)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: PopupMenuButton(
                child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black),
                    child: Icon(Icons.edit, color: Colors.white)),
                itemBuilder: (ctx) => [
                      PopupMenuItem(
                        onTap: () {
                          getImage();
                        },
                        child: Text('Add Image'),
                        value: 1,
                      ),
                    ]),
          ),
        ],
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
