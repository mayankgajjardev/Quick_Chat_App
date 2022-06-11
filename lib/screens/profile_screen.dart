// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/screens/edit_profile_screen.dart';

import '../routes.dart';

class ProfileScreen extends StatefulWidget {
  UserModel userModel;
  ProfileScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                buildImage(),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: buildEditIcon(Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  widget.userModel.fullName.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.userModel.email.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.userModel.phoneNumber.toString(),
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Routes.to(
                        context,
                        EditProfileScreen(
                          userModel: widget.userModel,
                        ));
                  },
                  child: Text("Edit Profile"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(widget.userModel.profilePic.toString());

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: () {}),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
