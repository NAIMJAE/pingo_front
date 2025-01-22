import 'package:flutter/material.dart';
import 'package:pingo_font/pages/chat_page/components/chat_match.dart';
import 'package:pingo_font/pages/chat_page/components/chat_message_list.dart';
import 'package:pingo_font/pages/chat_page/components/chat_search_header.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [],
        ),
      ),
    );
  }
}

//리스트 뷰 자동으로 가로,세로 설정 됨
