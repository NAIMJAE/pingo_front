import 'package:uuid/uuid.dart';

class Message {
  String? msgId; //메세지 번호
  final String? roomId; // 채팅방 번호
  final String? userNo; // 보낸사람과 로그인한 사용자가 동일하면 오른쪽에 메세지 띄우기 / 우선 2면 상대방
  final String? msgContent; //메세지 내용
  final DateTime? msgTime; // 메세지 보낸 시간
  final String? msgType; // 타입 enum
  final bool? isRead; // 읽음 여부를 나타내는 카운트 추가

  Message({
    this.msgId,
    this.roomId,
    this.userNo,
    this.msgContent,
    this.msgTime,
    this.msgType,
    this.isRead,
  }) {}

  // copyWith
  Message copyWith({
    String? msgId,
    String? userNo,
    String? roomId,
    String? msgContent,
    DateTime? msgTime,
    String? msgType,
    bool? isRead,
  }) {
    return Message(
        msgId: msgId ?? this.msgId,
        userNo: userNo ?? this.userNo,
        roomId: roomId ?? this.roomId,
        msgContent: msgContent ?? this.msgContent,
        msgTime: msgTime ?? this.msgTime,
        msgType: msgType ?? this.msgType,
        isRead: isRead ?? this.isRead);
  }

  @override
  String toString() {
    return 'Message{msgId: $msgId, userNo: $userNo, roomId: $roomId, msgContent: $msgContent, msgTime: $msgTime, msgType: $msgType, isRead: $isRead}';
  }

  // Json으로 받아온것을 객체로 변환
  Message.fromJson(Map<String, dynamic> json)
      : msgId = json['msgId'] ?? Uuid().v4(),
        roomId = json['roomId'],
        userNo = json['userNo'],
        msgContent = json['msgContent'],
        msgTime =
            json['msgTime'] != null ? DateTime.parse(json['msgTime']) : null,
        msgType = json['msgType'],
        isRead = json['isRead'] ?? false;
  // Json으로 변환
  Map<String, dynamic> toJson() {
    return {
      'msgId': msgId,
      'roomId': roomId,
      'userNo': userNo,
      'msgContent': msgContent,
      'msgTime': msgTime?.toIso8601String(),
      'msgType': msgType ?? '',
      'isRead': isRead,
    };
  }
}

enum MessageType { text, image, sticker }
// 'messageTime': messageTime?.toIso8601String(),
