import 'package:pingo_front/data/models/chat_model/chat_model.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';

class chatRoom {
  final List<Chat> chatUser;
  final List<Message> message;
  final String lastMessage;

  chatRoom(
      {required this.chatUser,
      required this.message,
      required this.lastMessage});
}
