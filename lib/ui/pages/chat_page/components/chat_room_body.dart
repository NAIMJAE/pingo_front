import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_room_model.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/data/view_models/stomp_view_model.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController messageController;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final Function(String) onSendMessage;

  const ChatInputField({
    Key? key,
    required this.messageController,
    required this.scrollController,
    required this.focusNode,
    required this.onSendMessage,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  void _sendMessage() {
    if (widget.messageController.text.trim().isEmpty) return;

    widget.onSendMessage(widget.messageController.text.trim());

    widget.messageController.clear();
    FocusScope.of(context).unfocus(); // 키보드 닫기

    Future.delayed(Duration(milliseconds: 100), () {
      if (widget.scrollController.hasClients) {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom, // ✅ 키보드 높이만큼 자동 조정
      ),
      child: TextField(
        controller: widget.messageController,
        focusNode: widget.focusNode,
        maxLines: 4,
        minLines: 1,
        decoration: InputDecoration(
          hintText: '메시지 내용을 입력하세요',
          suffixIcon: IconButton(
            onPressed: _sendMessage,
            icon: Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}

// consumer 처리하기.
class ChatRoomBody extends ConsumerStatefulWidget {
  ChatRoomBody({super.key});

  @override
  _ChatRoomBodyState createState() => _ChatRoomBodyState();
}

class _ChatRoomBodyState extends ConsumerState<ChatRoomBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scroll = ScrollController();
  final FocusNode _focusNode = FocusNode(); // 🔹 FocusNode 추가

  // 메세지내용 + 메세지 입력
  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatRoomProvider); // 상태값 꺼내오기
    final messageNotifier = ref.read(chatRoomProvider.notifier); // 창고 직ㅈ버 접근
    final stompViewModel = ref.read(stompViewModelProvider.notifier);
    final sss = ref.read(stompViewModelProvider.notifier);
// 구독해서 보고있는 주소정보에 이 데이터를 바꿔달라고 update 구독해서 보고있는 사람들은 그렇게 바뀜.
// read 해서 상대편
// 방송과 관련해서
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
                  chatNo: '1', // 채팅방 번호는 고정
                  type: MessageType.text, // 메시지 타입
                  readCount: 1, // 읽음 카운트
                  profileImageUrl:
                      'https://picsum.photos/250/250', // 기본 프로필 이미지
                );
                // 새 메시지 생성
                final newMessage = defaultMessage.copyWith(
                  messageContent: _messageController.text, // 입력 필드에서 가져온 내용
                  fromId: '1', // 보낸 사람 ID (로그인한 사용자 ID)
                  messageTime: DateTime.now(), // 현재 시간
                );
                logger.i('머머 $newMessage.toString()');
                stompViewModel.sendMessage(newMessage);

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
        message.fromId == '1' ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: message.fromId == '1'
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (message.fromId == '2') //상대방일때
            CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage('${message.profileImageUrl}')),
          Row(
            // 정렬 변경
            crossAxisAlignment: CrossAxisAlignment.end,
            children: message.fromId == '2'
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
      color: message.fromId == '1' ? Colors.blue : Colors.grey[300],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      '${message.messageContent}',
      style: TextStyle(
        color: message.fromId == '1' ? Colors.white : Colors.black,
      ),
    ),
  );
}

// 읽음 + 시간
Widget _buildRead(Message message) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('${message.readCount}'),
      Text('${formatTime(message.messageTime)}'),
    ],
  );
}

// 데이트타임 짜르는 메서드
String formatTime(DateTime? time) {
  if (time == null) return '';
  return DateFormat('HH:mm').format(time);
}
