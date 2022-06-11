// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickchat/constant.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/screens/home_screen.dart';
import 'package:quickchat/screens/login_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  final UserModel userModel;
  final User authUser;

  static const String routeName = '/completeProfile';
  const CompleteProfileScreen(
      {Key? key, required this.userModel, required this.authUser})
      : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  File? imageFile;

  //get argument data from route

  void selectImage(ImageSource imageSource) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      cropImage(pickedFile);
    } else {
      customToast(title: 'No image selected');
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? cropedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );

    if (cropedImage != null) {
      setState(() {
        imageFile = File(cropedImage.path);
      });
    } else {
      customToast(title: 'No Cropped Image');
    }
  }

  void showPhotosOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Select a photo'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Take a photo'),
                    onTap: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choose from gallery'),
                    onTap: () {
                      Navigator.pop(context);
                      selectImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();
      if (imageFile != null) {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref("profilePicture")
            .child(widget.userModel.uid.toString())
            .putFile(imageFile!);

        TaskSnapshot taskSnapshot = await uploadTask;

        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        String? fullName = fullNameController.text.trim();
        String? phoneNumber = phoneNumberController.text.trim();

        widget.userModel.fullName = fullName;
        widget.userModel.phoneNumber = phoneNumber;
        widget.userModel.profilePic = imageUrl;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userModel.uid)
            .set(widget.userModel.toMap())
            .then((value) {
          print("Data Done....👍");
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                  builder: (_) => HomeScreen(
                        authUser: widget.authUser,
                        userModel: widget.userModel,
                      )),
              (route) => false);
        });
      } else {
        customToast(title: 'Please Select Profile Picture...');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Complete Profile'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      CupertinoButton(
                        onPressed: showPhotosOptions,
                        child: CircleAvatar(
                          backgroundColor:
                              imageFile == null ? kPrimaryColor : null,
                          backgroundImage:
                              imageFile != null ? FileImage(imageFile!) : null,
                          foregroundColor: kWhiteColor,
                          radius: 60,
                          child: imageFile == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        controller: fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                        ),
                        style: TextStyle(fontSize: 20),
                        validator: (values) {
                          if (values!.trim().isEmpty) {
                            return kFullNameNullError;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        style: TextStyle(fontSize: 20),
                        validator: (values) {
                          if (values!.trim().isEmpty) {
                            return kPhoneNumberNullError;
                          } else if (values.trim().length != 10) {
                            return kPhoneNumberInvalidError;
                          } else if (!numericRegex.hasMatch(values.trim())) {
                            return kInvalidCharacter;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      defaultCupertinoButton(
                        text: "Submit",
                        color: true,
                        onPressed: onSubmit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
