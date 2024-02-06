import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/Screens/chat_screen.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/model/message.dart';
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

    Message? _message;
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
        child: StreamBuilder(
          stream: APIs.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) _message = list[0];
            return ListTile(
                // leading: const CircleAvatar(
                //   child: Icon(
                //     CupertinoIcons.person,
                //     size: 25,
                //   ),
                // ),

                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.03),
                  child: CachedNetworkImage(
                    height: mq.height * .05,
                    width: mq.width * .11,
                    fit: BoxFit.cover,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                title: Text(
                  widget.user.name,
                ),
                subtitle: Text(
                  _message != null ? _message!.msg : widget.user.about,
                  maxLines: 1,
                ),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ? Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: Colors.green.shade500,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Text(_message!.sent,
                            style: TextStyle(color: Colors.black54)));
          },
        ),
      ),
    );
  }
}
