// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quickchat/screens/login_screen.dart';
import 'package:quickchat/screens/sign_up_screen.dart';

final Map<String, WidgetBuilder> routes = {
  LoginScreen.routeName: (context) => LoginScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
};
