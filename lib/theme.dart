// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quickchat/constant.dart';

ThemeData lightTheme() {
  return ThemeData(
    primarySwatch: Colors.blue,
    fontFamily: "Muli",
    scaffoldBackgroundColor: Colors.white,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    inputDecorationTheme: inputDecorationTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: kPrimaryColor,
      centerTitle: true,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: kPrimaryColor,
    ),
  );
}

// dark theme
ThemeData darkTheme() {
  return ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: "Muli",
      scaffoldBackgroundColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: inputDecorationTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        elevation: 0,
      ));
}

InputDecorationTheme inputDecorationTheme() {
  var outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  var outlineErrorInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: kRedColor),
    gapPadding: 10,
  );
  var outlineFocusInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: BorderSide(color: kPrimaryColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineFocusInputBorder,
    border: outlineInputBorder,
    errorBorder: outlineErrorInputBorder,
    labelStyle: TextStyle(
      color: kPrimaryColor,
    ),
    focusedErrorBorder: outlineErrorInputBorder,
  );
}
