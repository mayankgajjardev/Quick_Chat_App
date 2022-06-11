// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:quickchat/constant.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/routes.dart';
import 'package:quickchat/screens/login_screen.dart';
import 'package:quickchat/screens/profile_screen.dart';

class CustomDrawer extends StatefulWidget {
  UserModel userModel;
  CustomDrawer({
    Key? key,
    required this.userModel,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: kPrimaryColor,
            ),
            accountName: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(widget.userModel.fullName.toString()),
            ),
            accountEmail: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(widget.userModel.email.toString()),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("${widget.userModel.profilePic}"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Routes.to(
                  context,
                  ProfileScreen(
                    userModel: widget.userModel,
                  ));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context, CupertinoPageRoute(builder: (_) => LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}
