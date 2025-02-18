import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/models/chat_model/chat_user.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/data/view_models/stomp_view_model.dart';

// consumer 처리하기.
class ChatMsgBody extends ConsumerStatefulWidget {
  final String roomId;
  final String userNo;
  final ChatRoom chatRoom2;
  final ChatRoomViewModel chatRoomViewModel;

  ChatMsgBody(
      {required this.userNo,
      required this.chatRoom2,
      required this.roomId,
      required this.chatRoomViewModel,
      super.key});

  @override
  _ChatMsgBodyState createState() => _ChatMsgBodyState();
}

class _ChatMsgBodyState extends ConsumerState<ChatMsgBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scroll = ScrollController();
  late StompViewModel websocketProvider; // 웹소캣 객체를 저장

  // 선언하고 initState()에서 ref.read를 사용해서 초기화를 했기때문에 build 안에서 사용가능함!

  @override
  void initState() {
    super.initState();
    // 2. 메세지를 지속적으로 받아오면서 구독하고 receive 요청!
    websocketProvider =
        ref.read(stompViewModelProvider.notifier); // 웹소캣 창고 접근(메서드 사용하려고)
    // websocketProvider.receive(widget.roomId);
  }
  //   super.initState();
  //   // 1. 백엔드 데이터베이스에서 최초로 message 정보를 불러오기 -> chatRoomProvider State에 저장
  //   // aaa();
  // }
  //
  // void aaa() async {
  //   final chatViewModel = ref.read(chatProvider.notifier);
  //   await chatViewModel.selectMessage(widget.roomId);
  //
  //   // 2. 메세지를 지속적으로 받아오면서 구독하고 receive 요청!
  //   final websocketProvider =
  //       ref.read(stompViewModelProvider.notifier); // 웹소캣 창고 접근(메서드 사용하려고)
  //   websocketProvider.receive(widget.roomId);
  // }

  // 메세지내용 + 메세지 입력
  @override
  Widget build(BuildContext context) {
    // final sessionUser = ref.read(sessionProvider);
    // final myUserNo = sessionUser.userNo;
    final chatRoom = ref.watch(chatProvider)[
        widget.roomId]; // 상태값 꺼내오기(state = Map<String,ChatRoom> 꺼내오는거임)
    // logger.i('도달여부확인');
    // final List<Message> chatMessages =
    //     widget.chatRoom[widget.roomId]?.message ?? [];
    // final List<ChatUser> chatUsers =
    //     widget.chatRoom[widget.roomId]?.chatUser ?? [];

    List<ChatUser>? totalUser = chatRoom?.chatUser;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: scroll,
            shrinkWrap: true,
            itemCount: chatRoom?.message?.length,
            itemBuilder: (context, index) {
              final message = chatRoom?.message![index];
              // final chatUser = chatUsers[index];
              return _buildMessageItem(message!, widget.userNo, totalUser!);
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
                  roomId: widget.roomId, // 채팅방 번호는 고정
                  msgType: 'MessageType.text', // 메시지 타입
                  isRead: false, // 읽음 카운트
                );
                // 새 메시지 생성
                final newMessage = defaultMessage.copyWith(
                  msgContent: _messageController.text, // 입력 필드에서 가져온 내용
                  userNo: widget.userNo, // 보낸 사람 ID (로그인한 사용자 ID)
                  msgTime: DateTime.now(), // 현재 시간
                );
                logger.i('머머 $newMessage');
                websocketProvider.sendMessage(newMessage, widget.roomId);

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
Widget _buildMessageItem(
    Message message, String? userNo, List<ChatUser> totalUser) {
  final ChatUser selectUser = totalUser.firstWhere(
    (each) => each.userNo == message.userNo,
    orElse: () => ChatUser(
        userNo: '1111', roomId: '2222', imageUrl: '3333', userName: '4444'),
  );

  return Align(
    alignment:
        // 로그인한 사람이 본인이면 오른쪽에 배치, 아니면 왼쪽에 배치
        message.userNo == userNo ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.userNo == userNo
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (message.userNo != userNo) //상대방일때
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(selectUser.imageUrl!),
            ),
          Row(
            // 정렬 변경
            crossAxisAlignment: CrossAxisAlignment.end,
            children: message.userNo != userNo
                ? [
                    SizedBox(width: 5),
                    _buildText(message, userNo),
                    SizedBox(width: 5),
                    _buildRead(message, userNo),
                  ]
                : [
                    SizedBox(width: 5),
                    _buildRead(message, userNo),
                    SizedBox(width: 5),
                    _buildText(message, userNo),
                  ],
          ),
        ],
      ),
    ),
  );
}

// 메시지 내용
Widget _buildText(Message message, String? userNo) {
  return Container(
    //wrap --> 길면 자를 수 있도록 설정할 수 있는 것
    constraints: BoxConstraints(maxWidth: 250), // 너무 길면 알아서 자르기
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    decoration: BoxDecoration(
      color: message.userNo == userNo ? Colors.blue : Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      '${message.msgContent}',
      style: TextStyle(
        color: message.userNo == userNo ? Colors.white : Colors.black,
      ),
    ),
  );
}

// 읽음 + 시간
Widget _buildRead(Message message, String? userNo) {
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
