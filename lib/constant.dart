// ignore_for_file: prefer_const_constructors, sort_child_properties_last
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Colors
const kPrimaryColor = Colors.deepPurple;
const kWhiteColor = Colors.white;
const kBlackColor = Colors.black;
const kRedColor = Colors.red;
const kScondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);
const kAnimationDuration = Duration(milliseconds: 200);

// Errors
final RegExp emailRgxValidation =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

const String kEmailNullError = 'Email can\'t be empty';
const String kInvalidEmailError = 'Invalid Email';
const String kPasswordNullError = 'Password can\'t be empty';
const String kShortPasswordError = 'Password is too short';
const String kMatchPassError = 'Password doesn\'t match';
const String kConfirmPasswordNullError = 'Confirm Password can\'t be empty';
const String kFullNameNullError = 'Full Name can\'t be empty';
const String kPhoneNumberNullError = 'Phone Number can\'t be empty';
const String kPhoneNumberInvalidError = 'Invalid Phone Number';
const String kInvalidCharacter = "Invalid Character";

OutlineInputBorder outlineBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: kTextColor),
  );
}

// Default Cupertino Button
CupertinoButton defaultCupertinoButton({
  double? fontSize,
  void Function()? onPressed,
  String? text,
  bool color = false,
  bool textColor = false,
}) {
  return CupertinoButton(
    borderRadius: BorderRadius.circular(30),
    color: color == true ? kPrimaryColor : null,
    child: Text(
      text.toString(),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor == true ? kPrimaryColor : null,
      ),
    ),
    onPressed: onPressed,
  );
}

customToast({String? title}) {
  return Fluttertoast.showToast(
    msg: title.toString(),
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: kWhiteColor,
    textColor: kBlackColor,
    fontSize: 17.0,
  );
}
