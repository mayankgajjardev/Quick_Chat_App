// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/constant.dart';
import 'package:quickchat/main.dart';
import 'package:quickchat/models/chat_room_model.dart';
import 'package:quickchat/models/user_model.dart';
import 'package:quickchat/screens/chat_room_screen.dart';

import '../routes.dart';

class SearchScreen extends StatefulWidget {
  final UserModel userModel;
  final User authUser;
  const SearchScreen(
      {Key? key, required this.userModel, required this.authUser})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      var docData = snapshot.docs[0].data();
      ChatRoomModel exsistingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);
      chatRoom = exsistingChatroom;
    } else {
      ChatRoomModel newChatroom =
          ChatRoomModel(chatRoomId: uuid.v1(), lastMessage: "", participants: {
        widget.userModel.uid.toString(): true,
        targetUser.uid.toString(): true,
      });
      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatRoomId)
          .set(newChatroom.toMap());
      chatRoom = newChatroom;
      log("New Chatroom created");
    }
    return chatRoom;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(labelText: "Email Address"),
                  ),
                  SizedBox(height: 20),
                  defaultCupertinoButton(
                    color: true,
                    text: "Search",
                    onPressed: () {
                      // keyboard hide
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where("email", isEqualTo: searchController.text)
                            .where("email",
                                isNotEqualTo: widget.userModel.email)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child:
                                    Center(child: CircularProgressIndicator()));
                          } else if (snapshot.hasData) {
                            QuerySnapshot querySnapshot = snapshot.data;

                            if (querySnapshot.docs.isNotEmpty) {
                              Map<String, dynamic> user = querySnapshot.docs[0]
                                  .data() as Map<String, dynamic>;
                              UserModel userModel = UserModel.fromMap(user);
                              return ListTile(
                                title: Text(userModel.fullName.toString()),
                                subtitle: Text(userModel.email.toString()),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userModel.profilePic.toString()),
                                ),
                                trailing: Icon(Icons.keyboard_arrow_right),
                                onTap: () async {
                                  ChatRoomModel? chatRoomModel =
                                      await getChatroomModel(userModel);
                                  if (chatRoomModel != null) {
                                    Routes.toPop(context);
                                    Routes.to(
                                      context,
                                      ChatRoomScreen(
                                        targetUser: userModel,
                                        authUser: widget.authUser,
                                        userModel: widget.userModel,
                                        chatRoom: chatRoomModel,
                                      ),
                                    );
                                  }
                                },
                              );
                            } else {
                              return SizedBox(
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  child: Center(child: Text("No user found")));
                            }
                          } else if (snapshot.hasError) {
                            return SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                    child: Text("Error : ${snapshot.error}")));
                          }
                          return SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(child: Text("No data")));
                        }),
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
