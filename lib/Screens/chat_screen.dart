import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/model/user.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            PopupMenuButton<String>(
                onSelected: (value) {},
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: "View Contact",
                      child: Text("View Contact"),
                    ),
                    const PopupMenuItem(
                      value: "Media, Link, Docs",
                      child: Text("Media, Link, Docs"),
                    ),
                    const PopupMenuItem(
                      value: "Whatsapp Web",
                      child: Text("Whatsapp Web"),
                    ),
                    const PopupMenuItem(
                      value: "Search",
                      child: Text("Search"),
                    ),
                    const PopupMenuItem(
                      value: "Mute Notification",
                      child: Text("Mute Notification"),
                    ),
                    const PopupMenuItem(
                      value: "Wallpaper",
                      child: Text("Wallpaper"),
                    ),
                  ];
                }),
          ],
          flexibleSpace: _appbar(),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 140,
                child: ListView(
                  shrinkWrap: true,
                  children: const [
                    OwnMessageCard(),
                    ReplyMessageCard(),
                    OwnMessageCard(),
                    ReplyMessageCard(),
                    OwnMessageCard(),
                    ReplyMessageCard(),
                    OwnMessageCard(),
                    ReplyMessageCard(),
                    OwnMessageCard(),
                    ReplyMessageCard(),
                    ReplyMessageCard(),
                    OwnMessageCard(),
                    ReplyMessageCard(),
                    OwnMessageCard(),
                    ReplyMessageCard(),
                    ReplyMessageCard(),
                    OwnMessageCard(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 55,
                      child: Card(
                        margin:
                            const EdgeInsets.only(left: 2, right: 2, bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(225),
                        ),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "type a message",
                            prefixIcon: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.emoji_emotions,
                                color: Colors.deepPurple,
                              ),
                            ),
                            suffixIcon:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.image,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ]),
                            contentPadding: const EdgeInsets.all(5),
                          ),
                        ),
                      ),
                    ),
                    //send button
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appbar() {
    var mq = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          SizedBox(
            width: mq.width * 0.001,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * 0.03),
            child: CachedNetworkImage(
              height: mq.height * .05,
              width: mq.width * .11,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          SizedBox(
            width: mq.width * 0.03,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Text(
                  widget.user.name.length > 14
                      ? widget.user.name.substring(0, 14)
                      : widget.user.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: mq.height * 0.001,
              ),
              Text(
                widget.user.about,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OwnMessageCard extends StatelessWidget {
  const OwnMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          color: Color(0xffdcf9c6),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 65, bottom: 20, top: 10),
                child: Text(
                  "Where are you form",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      "20.45",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyMessageCard extends StatelessWidget {
  const ReplyMessageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          //color: Color(0xffdcf9c6),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 65, bottom: 20, top: 10),
                child: Text(
                  "I am from karachi",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  "23.45",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
