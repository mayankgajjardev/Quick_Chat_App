// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickchat/components/chat_bubble.dart';
import 'package:quickchat/constant.dart';
import 'package:quickchat/main.dart';
import 'package:quickchat/models/chat_room_model.dart';
import 'package:quickchat/models/message_model.dart';
import 'package:quickchat/models/user_model.dart';

class ChatRoomScreen extends StatefulWidget {
  final UserModel targetUser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User authUser;

  ChatRoomScreen({
    Key? key,
    required this.targetUser,
    required this.chatRoom,
    required this.userModel,
    required this.authUser,
  }) : super(key: key);

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController messageController = TextEditingController();

  sendMessage() async {
    String msg = messageController.text.trim();
    if (msg != "") {
      MessageModel message = MessageModel(
        messageId: uuid.v1(),
        sender: widget.userModel.uid,
        text: msg,
        seen: false,
        createdAt: DateTime.now(),
      );

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatRoomId)
          .collection("messages")
          .doc(message.messageId)
          .set(message.toMap());
      messageController.clear();
      log("Message Sent!");
      widget.chatRoom.lastMessage = msg;
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(widget.chatRoom.chatRoomId)
          .update(widget.chatRoom.toMap());
    } else {
      log("Message is empty");
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       CircleAvatar(
      //         backgroundImage: NetworkImage("https://fakeimg.pl/250x250/"),
      //       ),
      //       SizedBox(width: 10),
      //       Text("Mayank Sureliya"),
      //     ],
      //   ),
      //   centerTitle: false,
      // ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: kWhiteColor,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(widget.targetUser.profilePic.toString()),
                  maxRadius: 20,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.targetUser.fullName.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: kWhiteColor,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "Online",
                        style: TextStyle(color: kWhiteColor, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.settings,
                  color: kWhiteColor,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("chatrooms")
                      .doc(widget.chatRoom.chatRoomId)
                      .collection("messages")
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        QuerySnapshot dataSnapShot =
                            snapshot.data as QuerySnapshot;
                        return ListView.builder(
                            reverse: true,
                            itemCount: dataSnapShot.docs.length,
                            itemBuilder: (context, int i) {
                              MessageModel currentMessage =
                                  MessageModel.fromMap(dataSnapShot.docs[i]
                                      .data() as Map<String, dynamic>);
                              return ChatBubble(
                                text: currentMessage.text.toString(),
                                isCurrentUser: currentMessage.sender ==
                                        widget.userModel.uid
                                    ? true
                                    : false,
                                time: currentMessage.createdAt!.toLocal(),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              "An error occured, Please Check your internet connection"),
                        );
                      } else {
                        return Center(
                          child: Text("Sey, Hi to new friend."),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            Container(
              color: Colors.grey[300],
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: messageController,
                      maxLines: null,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        errorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: "Type a message",
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  IconButton(
                      onPressed: sendMessage,
                      icon: Icon(
                        Icons.send,
                        color: kPrimaryColor,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
