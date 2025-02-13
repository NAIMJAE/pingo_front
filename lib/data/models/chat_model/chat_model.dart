import 'package:pingo_front/data/models/user_model/user_image.dart';

class Chat {
  final String? userNo;
  final String roomId;
  final String? imageUrl;
  final String? lastMessage;

  Chat({
    required this.userNo,
    required this.roomId,
    required this.imageUrl,
    required this.lastMessage,
  });

  //fromJson
  Chat.fromJson(Map<String, dynamic> json)
      : userNo = json['userNo'],
        roomId = json['roomId'],
        imageUrl = json['imageUrl'],
        lastMessage = json['lastMessage'];

  @override
  String toString() {
    return 'Chat{userNo: $userNo, roomId: $roomId, imageUrl: $imageUrl, lastMessage: $lastMessage}';
  } // //fromJson
  // Chat.fromJson(Map<String, dynamic> json)
  //     : roomId = json['roomId'],
  //       lastMessage = json['lastMessage'],
  //       otherUsers = (json['otherUsers'] as List<dynamic>?)
  //           ?.map(
  //               (others) => UserImage.fromJson(others as Map<String, dynamic>))
  //           .toList();

  Chat copyWith({String? lastMessage}) {
    return Chat(
      userNo: this.userNo,
      roomId: this.roomId,
      imageUrl: this.imageUrl,
      lastMessage: lastMessage ?? '',
    );
  }
}
