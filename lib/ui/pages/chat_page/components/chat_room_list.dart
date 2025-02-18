import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/ui/pages/chat_page/chat_msg2_page.dart';

class ChatRoomList extends StatefulWidget {
  final Map<String, ChatRoom> chatList;
  final ChatRoomViewModel chatRoomViewModel;

  const ChatRoomList(this.chatList, this.chatRoomViewModel, {super.key});

  @override
  State<ChatRoomList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatRoomList> {
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
          // Map 이라서 펼치기
          // expend : 리스트 안의 요소를 하나의 리스트로 펼쳐줌
          ...widget.chatList.entries.expand((entry) {
            final chat = entry.value; // chatRoom 객체를 가져오기
            final roomId = entry.key; // roomId 가져오기

            return chat.chatUser.map((user) => _chatList(
                  context,
                  user.imageUrl ?? '',
                  user.userName ?? '',
                  chat.lastMessage ?? '',
                  roomId,
                  user.userNo ?? '',
                ));
          }).toList(),
        ],
      ),
    );
  }

  Widget _chatList(BuildContext context, String imgUrl, String chatName,
      String chatMsg, String roomId, String userNo) {
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
              builder: (context) => ChatMsg2Page(
                  chatRoomName: chatName,
                  roomId: roomId,
                  userNo: userNo,
                  chatList: widget.chatList[roomId]!,
                  chatRoomViewModel: widget.chatRoomViewModel),
            ),
          );
        });
  }
}

// 모델
