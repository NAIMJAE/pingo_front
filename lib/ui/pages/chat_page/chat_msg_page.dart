import 'package:flutter/material.dart';

import 'components/chat_msg_body.dart';

class ChatMsgPage extends StatelessWidget {
  final String chatRoomName;
  final String roomId;
  final String userNo;
  const ChatMsgPage(
      {required this.chatRoomName,
      Key? key,
      required this.roomId,
      required this.userNo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoomName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatMsgBody(roomId: roomId),
      ),
    );
  }
}
