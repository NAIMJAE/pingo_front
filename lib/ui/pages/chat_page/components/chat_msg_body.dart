import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';
import 'package:pingo_front/data/models/global_model/session_user.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_msg_view_model.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_view_model.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/data/view_models/stomp_view_model.dart';

// class ChatInputField extends StatefulWidget {
//   final TextEditingController messageController;
//   final ScrollController scrollController;
//   final FocusNode focusNode;
//   final Function(String) onSendMessage;
//
//   const ChatInputField({
//     Key? key,
//     required this.messageController,
//     required this.scrollController,
//     required this.focusNode,
//     required this.onSendMessage,
//   }) : super(key: key);
//
//   @override
//   _ChatInputFieldState createState() => _ChatInputFieldState();
// }
//
// class _ChatInputFieldState extends State<ChatInputField> {
//   // 메세지 보내는 함수
//   void _sendMessage() {
//     //입력한 내용 없으면 return
//     if (widget.messageController.text.trim().isEmpty) return;
//
//     widget.onSendMessage(widget.messageController.text.trim());
//
//     widget.messageController.clear();
//     FocusScope.of(context).unfocus(); // 키보드 닫기
//
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (widget.scrollController.hasClients) {
//         widget.scrollController.animateTo(
//           widget.scrollController.position.maxScrollExtent,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(
//         left: 8,
//         right: 8,
//         bottom: MediaQuery.of(context).viewInsets.bottom, // 키보드 높이만큼 자동 조정
//       ),
//       child: TextField(
//         controller: widget.messageController,
//         focusNode: widget.focusNode,
//         maxLines: 4,
//         minLines: 1,
//         decoration: InputDecoration(
//           hintText: '메시지 내용을 입력하세요',
//           suffixIcon: IconButton(
//             onPressed: _sendMessage,
//             icon: Icon(Icons.send),
//           ),
//         ),
//       ),
//     );
//   }
// }

// consumer 처리하기.
class ChatMsgBody extends ConsumerStatefulWidget {
  final String roomId;
  ChatMsgBody({required this.roomId, super.key});

  @override
  _ChatRoomBodyState createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends ConsumerState<ChatMsgBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scroll = ScrollController();
  late StompViewModel websocketProvider; // 웹소캣 객체를 저장
  // 선언하고 initState()에서 ref.read를 사용해서 초기화를 했기때문에 build 안에서 사용가능함!

  @override
  void initState() {
    super.initState();
    // 1. 백엔드 데이터베이스에서 최초로 message 정보를 불러오기 -> chatRoomProvider State에 저장
    final chatMsgViewModel = ref.read(chatMsgProvider.notifier);
    chatMsgViewModel.selectMessage(widget.roomId);

    // 2. 메세지를 지속적으로 받아오면서 구독하고 receive 요청!
    //메세지 받아옴 receive 안에 addMessage가 있는데 [...state , message] 가 있음
    final websocketProvider =
        ref.read(stompViewModelProvider.notifier); // 웹소캣 창고 접근(메서드 사용하려고)
    websocketProvider.receive(widget.roomId);
  }

  // 메세지내용 + 메세지 입력
  @override
  Widget build(BuildContext context) {
    final sessionUser = ref.read(sessionProvider);
    final myUserNo = sessionUser.userNo;
    final messages =
        ref.watch(chatMsgProvider); // 상태값 꺼내오기(state = List<Message> 꺼내오는거임)
    final chatList = ref.watch(chatProvider);

    // final otherUserNo = messages
    //     .where((msg) => msg.userNo != myUserNo)
    //     .map((msg) => msg.userNo)
    //     .toSet();
    // final otherUser = chatList
    //     .where((chat) => otherUserNo.contains(chat.userNo))
    //     .map((chat) => {'userNo': chat.userNo, 'imageUrl': chat.imageUrl})
    //     .toList();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scroll,
            shrinkWrap: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _buildeMessageItem(message);
            },
          ),
        ),
        TextField(
          controller: _messageController,
          maxLines: 4,
          minLines: 1,
          decoration: InputDecoration(
            hintText: '메시지 내용을 입력하세요',
            suffixIcon: IconButton(
              onPressed: () {
                final defaultMessage = Message(
                  roomId: '1', // 채팅방 번호는 고정
                  msgType: 'MessageType.text', // 메시지 타입
                  isRead: true, // 읽음 카운트
                  // profileImageUrl:
                  //     'https://picsum.photos/250/250', // 기본 프로필 이미지
                );
                // 새 메시지 생성
                final newMessage = defaultMessage.copyWith(
                  msgContent: _messageController.text, // 입력 필드에서 가져온 내용
                  userNo: '1', // 보낸 사람 ID (로그인한 사용자 ID)
                  msgTime: DateTime.now(), // 현재 시간
                );
                logger.i('머머 $newMessage.toString()');
                websocketProvider.sendMessage(newMessage);

                // 메시지 추가

                // 입력 필드 초기화
                _messageController.clear();
                // 최하단으로 스크롤 내리려고하는데..
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (scroll.hasClients) {
                    scroll.jumpTo(scroll.position.maxScrollExtent);
                  }
                });
              },
              icon: Icon(Icons.send),
            ),
          ),
        ),
      ],
    );
  }
}

// 메시지 내용 띄우는 위젯
Widget _buildeMessageItem(Message message) {
  return Align(
    alignment:
        message.userNo == '1' ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.userNo == '1'
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (message.userNo == '2') //상대방일때
            CircleAvatar(
                radius: 20,
                //tntntntnwjdj
                backgroundImage: NetworkImage('${message.userNo}')),
          Row(
            // 정렬 변경
            crossAxisAlignment: CrossAxisAlignment.end,
            children: message.userNo == '2'
                ? [
                    SizedBox(width: 5),
                    _buildText(message),
                    SizedBox(width: 5),
                    _buildRead(message),
                  ]
                : [
                    SizedBox(width: 5),
                    _buildRead(message),
                    SizedBox(width: 5),
                    _buildText(message),
                  ],
          ),
        ],
      ),
    ),
  );
}

// 메시지 내용
Widget _buildText(Message message) {
  return Container(
    //wrap --> 길면 자를 수 있도록 설정할 수 있는 것
    constraints: BoxConstraints(maxWidth: 250), // 너무 길면 알아서 자르기
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
      color: message.userNo == '1' ? Colors.blue : Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      '${message.msgContent}',
      style: TextStyle(
        color: message.userNo == '1' ? Colors.white : Colors.black,
      ),
    ),
  );
}

// 읽음 + 시간
Widget _buildRead(Message message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('${message.isRead}'),
      Text('${formatTime(message.msgTime)}'),
    ],
  );
}

// 데이트타임 짜르는 메서드
String formatTime(DateTime? time) {
  if (time == null) return '';
  return DateFormat('HH:mm').format(time);
}
