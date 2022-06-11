// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/models/firebase_hepler.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/routes.dart';
import 'package:quickchat/screens/home_screen.dart';
import 'package:quickchat/screens/login_screen.dart';
import 'package:quickchat/theme.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    UserModel? thisUerModel =
        await FirebaseHelper.getUserModelById(currentUser.uid);
    if (thisUerModel != null) {
      runApp(Wrapper(
        authUser: currentUser,
        userModel: thisUerModel,
      ));
    } else {
      runApp(const MyApp());
    }
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickChat',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      initialRoute: LoginScreen.routeName,
      routes: routes,
    );
  }
}

class Wrapper extends StatelessWidget {
  final UserModel userModel;
  final User authUser;

  const Wrapper({Key? key, required this.userModel, required this.authUser})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickChat',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      home: HomeScreen(userModel: userModel, authUser: authUser),
    );
  }
}
