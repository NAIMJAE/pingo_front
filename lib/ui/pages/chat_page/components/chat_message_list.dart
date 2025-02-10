import 'package:flutter/material.dart';

import '../chat_room_page.dart';

class ChatMessageList extends StatefulWidget {
  final String userNo;
  const ChatMessageList({required this.userNo, super.key});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // 전체 페이지 스크롤 가능
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0), // 페이지 좌우 여백
            child: Text(
              '나의 채팅',
              style: TextStyle(
                fontSize: 12, // 크기 수정
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          ...List.generate(20, (index) {
            return _chatList(
              context,
              'https://picsum.photos/250/250',
              'User $index',
              'Message $index',
            );
          }),
        ],
      ),
    );
  }
}

Widget _chatList(
    BuildContext context, String imgUrl, String chatName, String chatMsg) {
  return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
        radius: 28, // 기본 크기 설정
      ),
      title: Text(chatName),
      subtitle: Text(chatMsg),
      trailing: Icon(Icons.play_arrow),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(chatRoomName: chatName),
          ),
        );
      });
}

// 모델
