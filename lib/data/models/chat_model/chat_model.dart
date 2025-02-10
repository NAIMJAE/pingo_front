import 'package:pingo_front/data/models/user_model/user_image.dart';

class Chat {
  final String? roomId;
  final String? lastMessage;
  final List<UserImage>? otherUsers;

  Chat(this.roomId, this.lastMessage, this.otherUsers);
}
