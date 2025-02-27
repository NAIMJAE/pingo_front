import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/models/chat_model/chat_user.dart';

class ChatSearchHeader extends StatefulWidget {
  final Map<String, ChatRoom> chatList;
  const ChatSearchHeader(this.chatList, {super.key});

  @override
  State<ChatSearchHeader> createState() => _ChatSearchHeaderState();
}

class _ChatSearchHeaderState extends State<ChatSearchHeader> {
  TextEditingController search = TextEditingController();
  final scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Icon(Icons.search),
          SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              child: TextFormField(
                onTap: () async {
                  print('dd');
                  // 스크롤을 최하단으로 이동
                  await Future.delayed(Duration(seconds: 2));
                  scroll.jumpTo(scroll.position.maxScrollExtent);
                },
                controller: search, // 키보드의 서치버튼 클릭시 clear 처리
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  // border: InputBorder.none, // 기본 테두리 제거
                  enabledBorder: InputBorder.none, // 활성화 시 테두리 제거
                  hintStyle:
                      TextStyle(fontSize: 16, color: Colors.grey), // theme로 바꾸기
                  hintText: '매칭된 상대를 검색하세요',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
