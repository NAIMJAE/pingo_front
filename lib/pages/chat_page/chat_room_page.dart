import 'package:flutter/material.dart';
import 'package:pingo_font/pages/chat_page/components/chat_room_body.dart';

class ChatRoomPage extends StatelessWidget {
  final String chatRoomName;
  const ChatRoomPage({required this.chatRoomName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoomName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ChatRoomBody(),
      ),
    );
  }
}
