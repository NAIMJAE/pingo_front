import 'package:flutter/material.dart';

// Model
class Message {
  final String content;
  final bool isMe;
  final DateTime timestamp;
  final MessageType type;
  final int readCount; // 읽음 여부를 나타내는 카운트 추가
  final String profileImageUrl;

  Message({
    required this.content,
    required this.isMe,
    required this.timestamp,
    required this.type,
    required this.readCount,
    required this.profileImageUrl,
  });
}

enum MessageType { text, image, sticker }

// viewModel
final List<Message> messages = [
  Message(
    content: "받아주세용",
    isMe: true,
    timestamp: DateTime.now(),
    type: MessageType.text,
    readCount: 1,
    profileImageUrl: 'sdadf',
  ),
];
// 메서드 추가로 빼기

class ChatMsgBody extends StatefulWidget {
  const ChatMsgBody({super.key});

  @override
  State<ChatMsgBody> createState() => _ChatMsgBodyState();
}

class _ChatMsgBodyState extends State<ChatMsgBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final message = messages[index];
          },
        )
      ],
    );
  }
}

Widget _buildeMessageItem(Message message) {
  return Align(
    alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment:
            message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: !message.isMe,
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(message.profileImageUrl),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.green),
          )
        ],
      ),
    ),
  );
}
