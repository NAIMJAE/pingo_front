import 'package:uuid/uuid.dart';

class Message {
  String? messageNo; //메세지 번호
  final String? chatNo; // 채팅방 번호
  final String? fromId; // 보낸사람과 로그인한 사용자가 동일하면 오른쪽에 메세지 띄우기 / 우선 2면 상대방
  final String? messageContent; //메세지 내용
  final DateTime? messageTime; // 메세지 보낸 시간
  final MessageType? type; // 타입 enum
  final int? readCount; // 읽음 여부를 나타내는 카운트 추가
  final String? profileImageUrl;

  Message(
      {this.chatNo,
      this.fromId,
      this.messageContent,
      this.messageTime,
      this.type,
      this.readCount,
      this.profileImageUrl}) {
    this.messageNo = _createMsgNo();
  }
  // 랜덤 pk 숫자 생성
  String _createMsgNo() {
    var uuid = Uuid();
    return messageNo = uuid.v4();
  }

  // copyWith
  Message copyWith(
      {String? chatNo,
      String? fromId,
      String? messageContent,
      DateTime? messageTime,
      MessageType? type,
      int? readCount,
      String? profileImageUrl}) {
    return Message(
        chatNo: chatNo ?? this.chatNo,
        fromId: fromId ?? this.fromId,
        messageContent: messageContent ?? this.messageContent,
        messageTime: messageTime ?? this.messageTime,
        type: type ?? this.type,
        readCount: readCount ?? this.readCount,
        profileImageUrl: profileImageUrl ?? this.profileImageUrl);
  }

  @override
  String toString() {
    return 'Message{messageNo: $messageNo, chatNo: $chatNo, fromId: $fromId, messageContent: $messageContent, messageTime: $messageTime, type: $type, readCount: $readCount, profileImageUrl: $profileImageUrl}';
  }
}

enum MessageType { text, image, sticker }
