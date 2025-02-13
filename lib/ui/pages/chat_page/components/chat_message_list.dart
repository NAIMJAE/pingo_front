import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/chat_model/chat_model.dart';

import '../chat_msg_page.dart';

class ChatMessageList extends StatefulWidget {
  final List<Chat> chatList;
  const ChatMessageList(this.chatList, {super.key});

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  /**
   * List<Chat> chatList -> 반복 if(lastmsg == null)
   *
   */

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
          ...List.generate(widget.chatList.length, (index) {
            final chat = widget.chatList[index];
            return _chatList(
              context,
              chat.imageUrl ?? '',
              chat.userNo ?? '',
              chat.lastMessage ?? '',
              chat.roomId ?? '',
            );
          }),
        ],
      ),
    );
  }
}

Widget _chatList(BuildContext context, String imgUrl, String chatName,
    String chatMsg, String roomId) {
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
            builder: (context) =>
                ChatMsgPage(chatRoomName: chatName, roomId: roomId),
          ),
        );
      });
}

// 모델
