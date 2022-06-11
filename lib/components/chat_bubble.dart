// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:quickchat/constant.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
    required this.time,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? kPrimaryColor : Colors.grey[300],
            borderRadius: isCurrentUser
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))
                : BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: isCurrentUser
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        softWrap: true,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color:
                                isCurrentUser ? Colors.white : Colors.black87),
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          TimeOfDay.fromDateTime(time).format(context),
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color:
                                isCurrentUser ? Colors.white : Colors.black87,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
