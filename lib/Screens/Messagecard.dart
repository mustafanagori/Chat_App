import 'package:flutter/material.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/helper/my_date.dart';
import 'package:we_chat/model/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return widget.message.fromId == APIs.user.uid ? _greenCard() : _blueCard();
  }

  Widget _blueCard() {
    if (widget.message.read.isNotEmpty) {
      APIs.updateMessageReadStatus(widget.message);
      print("message updated");
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          //color: Color(0xffdcf9c6),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 65, bottom: 20, top: 10),
                child: Text(
                  widget.message.msg,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  MyDateUtilis.getFormattedTime(
                      context: context, time: widget.message.sent),
                  style: TextStyle(
                    fontSize: 11,
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

  Widget _greenCard() {
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
                  widget.message.msg,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      MyDateUtilis.getFormattedTime(
                          context: context, time: widget.message.sent),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.done_all,
                      size: 20,
                      color: widget.message.read.isNotEmpty
                          ? Colors.green
                          : Colors.black87,
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
