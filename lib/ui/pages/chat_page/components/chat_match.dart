// chat_match.dart
import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/models/chat_model/chat_user.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class ChatMatch extends StatelessWidget {
  // final List<Chat> chatList;
  final Map<String, ChatRoom> chatList;
  // Constructor
  ChatMatch({required this.chatList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                '새 매치',
                style: TextStyle(
                  fontSize: 12, // 크기 수정해야됨
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...chatList.entries.map(
                      (each) {
                        return _newMatchChatItem(chatList[each.key]!);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _newMatchChatItem(ChatRoom chatRoom) {
    ChatUser otherUser = chatRoom.chatUser[0]; ///// 나중에 수정

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 80,
        margin: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CustomImage().token(otherUser.imageUrl!),
                  ),
                ),
                if (true) ///// 나중에 수정
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      child: Icon(
                        Icons.circle,
                        color: Colors.green,
                        size: 15,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              otherUser.userName!,
              style: TextStyle(
                fontWeight: FontWeight.w500, // 사이즈수정
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
