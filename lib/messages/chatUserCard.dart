import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'apis.dart';
import 'myDateUtil.dart';

import 'chatUser.dart';
import 'message.dart';
import 'chatScreen.dart';
class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  final bool showNameAndImage;

  ChatUserCard({required this.user, this.showNameAndImage = true});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}
class _ChatUserCardState extends State<ChatUserCard> {
  // last message info (if null --> no message)
  Message? _message;

  @override
  Widget build(BuildContext context) {
    final Size mq = MediaQuery.of(context).size;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      // color: Colors.blue.shade100,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // for navigating to chat screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(user: widget.user),
            ),
          );
        },
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];

            return ListTile(
              // user profile picture
              leading: InkWell(
                onTap: () {},
                child: widget.showNameAndImage
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: CachedNetworkImage(
                    width: 50.0,
                    height: 50.0,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                )
                    : SizedBox(width: 0, height: 0), // Hidden if showNameAnsdImage is false
              ),

              // User name
              title: widget.showNameAndImage ? Text(widget.user.name) : SizedBox(width: 0, height: 0), // Hidden if showNameAndImage is false

              // last message

              // last message time
              trailing: _message == null
                  ? null // show nothing when no message is sent
                  : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                  ? // show for unread message
              Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
                  : // message sent time
              Text(
                MyDateUtil.getLastMessageTime(
                  context: context,
                  time: _message!.sent,
                ),
                style: const TextStyle(color: Colors.black54),
              ),
            );
          },
        ),
      ),
    );
  }
}