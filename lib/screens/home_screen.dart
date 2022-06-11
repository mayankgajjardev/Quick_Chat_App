// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/components/customDrawer.dart';
import 'package:quickchat/models/chat_room_model.dart';
import 'package:quickchat/models/firebase_hepler.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/screens/chat_room_screen.dart';
import 'package:quickchat/screens/login_screen.dart';
import 'package:quickchat/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;
  final User authUser;
  static const String routeName = '/home';
  const HomeScreen({Key? key, required this.userModel, required this.authUser})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QuickChat"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushReplacement(
                  context, CupertinoPageRoute(builder: (_) => LoginScreen()));
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .where('participants.${widget.userModel.uid}', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

                  return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (context, index) {
                      ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                          querySnapshot.docs[index].data()
                              as Map<String, dynamic>);
                      Map<String, dynamic> participants =
                          chatRoomModel.participants!;

                      List<String> participantKeys = participants.keys.toList();

                      participantKeys.remove(widget.userModel.uid);

                      return FutureBuilder(
                        future:
                            FirebaseHelper.getUserModelById(participantKeys[0]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.data != null) {
                              UserModel targetUser = snapshot.data as UserModel;
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      targetUser.profilePic.toString()),
                                ),
                                title: Text(targetUser.fullName.toString()),
                                subtitle:
                                    Text(chatRoomModel.lastMessage.toString()),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => ChatRoomScreen(
                                              targetUser: targetUser,
                                              chatRoom: chatRoomModel,
                                              userModel: widget.userModel,
                                              authUser: widget.authUser)));
                                },
                              );
                            } else {
                              return Container();
                            }
                          } else {
                            return Container();
                          }
                        },
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error : ${snapshot.error}"));
                }
                return Center(
                  child: Text("No Chats"),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => SearchScreen(
                      userModel: widget.userModel, authUser: widget.authUser)));
        },
        child: Icon(Icons.search),
      ),
      drawer: CustomDrawer(
          Email: widget.userModel.email.toString(),
          FullName: widget.userModel.fullName.toString()),
    );
  }
}
