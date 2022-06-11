// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/constant.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/screens/complete_profile_screen.dart';
import 'package:quickchat/screens/login_screen.dart';

import '../routes.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/signUp';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      UserCredential? credential;

      try {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        customToast(title: "${e.message}");
      }

      if (credential != null) {
        String uid = credential.user!.uid;
        UserModel mewUser = UserModel(
          uid: uid,
          email: emailController.text.trim(),
          fullName: "",
          phoneNumber: "",
          profilePic: "",
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .set(mewUser.toMap())
            .then((value) {
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
                builder: (_) => CompleteProfileScreen(
                      authUser: credential!.user!,
                      userModel: mewUser,
                    )),
            (route) => false,
          );
        });
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
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to QuickChat',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sign up to your account',
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
                        } else if (!emailRgxValidation
                            .hasMatch(values.trim())) {
                          return kInvalidEmailError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      textInputAction: TextInputAction.next,
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
                    TextFormField(
                      controller: confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                      ),
                      style: TextStyle(fontSize: 20),
                      validator: (values) {
                        if (values!.trim().isEmpty) {
                          return kConfirmPasswordNullError;
                        } else if (values.trim().length < 8) {
                          return kShortPasswordError;
                        } else if (values.trim() !=
                            passwordController.text.trim()) {
                          return kMatchPassError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    defaultCupertinoButton(
                      text: "Sign Up",
                      color: true,
                      onPressed: signUp,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'I have an account?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: defaultCupertinoButton(
                            text: "Login",
                            textColor: true,
                            onPressed: () {
                              Routes.to(context, LoginScreen());
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
      ),
    );
  }
}
