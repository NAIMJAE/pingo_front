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
    content:
        "받아주세용dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
    isMe: false,
    timestamp: DateTime.now(),
    type: MessageType.text,
    readCount: 1,
    profileImageUrl: 'https://picsum.photos/250/250',
  ),
  Message(
    content: "받아주세용ddddddddddddddddddd",
    isMe: true,
    timestamp: DateTime.now(),
    type: MessageType.text,
    readCount: 1,
    profileImageUrl: 'https://picsum.photos/250/250',
  ),
];
// 메서드 추가로 빼기

class ChatRoomBody extends StatefulWidget {
  const ChatRoomBody({super.key});

  @override
  State<ChatRoomBody> createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends State<ChatRoomBody> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _buildeMessageItem(message);
            },
          ),
        ),
        TextField(
          controller: _messageController,
          decoration: InputDecoration(
            hintText: '메시지 내용을 입력하세요',
            suffixIcon: IconButton(
              onPressed: () {},
              icon: Icon(Icons.send),
            ),
          ),
        ),
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
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (!message.isMe)
            CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(message.profileImageUrl)),
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // 정렬 변경
            crossAxisAlignment: CrossAxisAlignment.end,
            children: !message.isMe
                ? [
                    SizedBox(width: 5),
                    _buildText(message),
                    SizedBox(width: 5),
                    _buildRead(message),
                  ]
                : [
                    SizedBox(width: 5),
                    _buildRead(message),
                    SizedBox(width: 5),
                    _buildText(message),
                  ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildText(Message message) {
  return Container(
    constraints: BoxConstraints(maxWidth: 250), // 너무 길면 알아서 자르기
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
      color: message.isMe ? Colors.blue : Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      message.content,
      style: TextStyle(
        color: message.isMe ? Colors.white : Colors.black,
      ),
    ),
  );
}

Widget _buildRead(Message message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('11'),
      Text('14:22'),
    ],
  );
}
