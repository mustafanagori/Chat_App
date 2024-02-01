import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/Screens/chat_screen.dart';
import 'package:we_chat/model/user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({
    super.key,
    required this.user,
  });

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: mq.width * 0.007,
        vertical: mq.height * 0.004,
      ),
      child: InkWell(
        onTap: () {
          Get.to(ChatScreen(
            user: widget.user,
          ));
        },
        child: ListTile(
            leading: const CircleAvatar(
              child: Icon(
                CupertinoIcons.person,
                size: 25,
              ),
            ),
            title: Text(
              widget.user.name,
            ),
            subtitle: Text(
              widget.user.about,
              maxLines: 1,
            ),
            trailing: const Text(
              "12:00",
              style: TextStyle(color: Colors.black54),
            )),
      ),
    );
  }
}
