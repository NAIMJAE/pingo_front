import 'package:flutter/material.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/ui/pages/chat_page/chat_msg2_page.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class ChatRoomList extends StatefulWidget {
  final Map<String, ChatRoom> chatList;
  final String myUserNo;

  const ChatRoomList(this.chatList, this.myUserNo, {super.key});

  @override
  State<ChatRoomList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatRoomList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500, // ♬ 나중에 더미 넣고 높이 수정
      color: Colors.white,
      child: SingleChildScrollView(
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
                    widget.myUserNo,
                  ));
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _chatList(BuildContext context, String imgUrl, String userName,
      String lastMessage, String roomId, String myUserNo) {
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.0),
        leading: CircleAvatar(
          backgroundImage: CustomImage().provider(imgUrl),
          radius: 28, // 기본 크기 설정
        ),
        title: Text(userName),
        subtitle: Text(lastMessage),
        trailing: Icon(Icons.play_arrow),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatMsg2Page(
                  chatRoomName: userName, roomId: roomId, myUserNo: myUserNo),
            ),
          );
        });
  }
}

// 모델
