import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/chat_model/chat_room_model.dart';

class chatRoomViewModel extends Notifier<List<Message>> {
  @override
  List<Message> build() {
    return [
      Message(
        // messageNo: '1',
        chatNo: '1',
        messageContent:
            "받아주세용dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd",
        fromId: '1',
        messageTime: DateTime.now(),
        type: MessageType.text,
        readCount: 1,
        profileImageUrl: 'https://picsum.photos/250/250',
      ),
      Message(
        // messageNo: '1',
        chatNo: '1',
        messageContent: "받아주세용dddddddddddddddd",
        fromId: '2',
        messageTime: DateTime.now(),
        type: MessageType.text,
        readCount: 1,
        profileImageUrl: 'https://picsum.photos/250/250',
      ),
    ];
  }

  void addMessage(Message message) {
    state = [...state, message];
  }

//메서드 추가 예정
}

//창고 관리자 생성하기
final chatRoomProvider = NotifierProvider<chatRoomViewModel, List<Message>>(
  () {
    return chatRoomViewModel();
  },
);

// viewModel
// final List<Message> messages = [
//   Message(
//     // messageNo: '1',
//     chatNo: '1',
//     messageContent: "받아주세용dddddddddddddddddddd",
//     fromId: '1',
//     messageTime: DateTime.now(),
//     type: MessageType.text,
//     readCount: 1,
//     profileImageUrl: 'https://picsum.photos/250/250',
//   ),
//   Message(
//     // messageNo: '1',
//     chatNo: '1',
//     messageContent: "받아주세용dddddddddddddddd",
//     fromId: '2',
//     messageTime: DateTime.now(),
//     type: MessageType.text,
//     readCount: 1,
//     profileImageUrl: 'https://picsum.photos/250/250',
//   ),
// ];
