import 'package:pingo_front/data/models/chat_model/chat_user.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';

class ChatRoom {
  final List<ChatUser> chatUser;
  final List<Message>? message;
  final String lastMessage;

  ChatRoom({required this.chatUser, this.message, required this.lastMessage});

  // List<Map<String,dynamic>>으로 chatUser가 들어오기때문에 List<ChatUser>로 형변환이 필요함?
  ChatRoom.fromJson(Map<String, dynamic> json)
      : chatUser = (json['chatUser'] as List?)
                ?.map((e) => ChatUser.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [], // ✅ `null`이면 빈 리스트 반환
        message = (json['message'] as List?)
                ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [], // ✅ `null`이면 빈 리스트 반환
        lastMessage = json['lastMessage'] ?? ''; // ✅ `null`이면 빈 문자열 반환

  // childKeyword = (json['childKeyword'] as List<dynamic>?)
  //     ?.map((child) => Keyword.fromJson(child as Map<String, dynamic>))
  //     .toList();

  // // ChatRoom 객체 생성시 메세지를 초기화하는 함수
  // void createNewMessage(List<Message> newMsg) {
  //   message.clear();
  //   message.addAll(newMsg);
  // }
  //
  // // 새로운 메세지가 소켓으로 도착하면 추가하는 함수
  // void addNewMessage(Message newMsg) {
  //   message.add(newMsg);
  // }
}
