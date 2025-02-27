import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/ui/pages/chat_page/components/chat_msg_body.dart';

class ChatMsg2Page extends StatefulWidget {
  final String chatRoomName;
  final String roomId;
  final String myUserNo;

  const ChatMsg2Page({
    required this.chatRoomName,
    required this.roomId,
    required this.myUserNo,
    super.key,
  });

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'myUserNo': myUserNo,
    };
  }

  @override
  State<ChatMsg2Page> createState() => _ChatMsg2PageState();
}

class _ChatMsg2PageState extends State<ChatMsg2Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoomName),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChatMsgBody(
            roomId: widget.roomId,
            myUserNo: widget.myUserNo,
          ),
        ),
      ),
    );
  }
}
