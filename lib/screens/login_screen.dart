// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/constant.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/screens/home_screen.dart';
import 'package:quickchat/screens/sign_up_screen.dart';

import '../routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      UserCredential? credential;

      try {
        credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        customToast(title: "${e.message}");
      }

      if (credential != null) {
        String uid = credential.user!.uid;
        DocumentSnapshot userData =
            await FirebaseFirestore.instance.collection("users").doc(uid).get();
        UserModel userModel =
            UserModel.fromMap(userData.data() as Map<String, dynamic>);
        customToast(title: "Login Successful");
        Routes.toRemovUntil(context,
            HomeScreen(userModel: userModel, authUser: credential.user!));
      } else {
        customToast(title: "Sign Up Failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome back!',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Login to your account',
                    style: TextStyle(
                      color: kPrimaryColor.withOpacity(0.8),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 40),
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                    ),
                    style: TextStyle(fontSize: 20),
                    validator: (values) {
                      if (values!.trim().isEmpty) {
                        return kEmailNullError;
                      } else if (!emailRgxValidation.hasMatch(values.trim())) {
                        return kInvalidEmailError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    obscureText: true,
                    obscuringCharacter: '*',
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                    ),
                    style: TextStyle(fontSize: 20),
                    validator: (values) {
                      if (values!.trim().isEmpty) {
                        return kPasswordNullError;
                      } else if (values.trim().length < 8) {
                        return kShortPasswordError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  defaultCupertinoButton(
                    text: "Login",
                    color: true,
                    onPressed: login,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: defaultCupertinoButton(
                          text: "SignUp",
                          textColor: true,
                          onPressed: () {
                            Routes.to(context, SignUpScreen());
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
