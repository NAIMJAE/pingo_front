// chat_match.dart
import 'package:flutter/material.dart';

class ChatMatch extends StatelessWidget {
  const ChatMatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              children: List.generate(
                10,
                (index) {
                  return NewMatchItem(
                    imageUrl: 'https://picsum.photos/250/250', // 실제 이미지 URL
                    name: 'ㅇㄱㅇ', // 실제 이름
                    connection: true,
                    onTap: () {
                      print('클릭했음');
                      // 매치 클릭 처리 -> 클릭했을 때 채팅방으로 이동
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// model
class NewMatchItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final bool connection;
  final VoidCallback onTap;

  const NewMatchItem({
    Key? key,
    required this.imageUrl,
    required this.name,
    this.connection = false,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (connection)
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
              name,
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
