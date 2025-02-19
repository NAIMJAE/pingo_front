// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pingo_front/_core/utils/logger.dart';
// import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';
// import 'package:pingo_front/data/models/chat_model/chat_room.dart';
// import 'package:pingo_front/data/models/chat_model/chat_user.dart';
// import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
// import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
// import 'package:pingo_front/data/view_models/stomp_view_model.dart';
//
// import 'components/chat_msg_body.dart';
//
// class ChatMsgPage extends StatefulWidget {
//   final String chatRoomName;
//   final String roomId;
//   final String userNo;
//
//   const ChatMsgPage({
//     required this.chatRoomName,
//     required this.roomId,
//     required this.userNo,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ChatMsgPage> createState() => _ChatMsgPageState();
// }
//
// class _ChatMsgPageState extends State<ChatMsgPage> {
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   selectMessage();
//   //   // logger.i(ref.read(chatProvider)[widget.roomId]?.message?.length);
//   // }
//
//   // void selectMessage() async {
//   //   final ChatRoomViewModel chatViewModel = ref.read(chatProvider.notifier);
//   //   await chatViewModel.selectMessage(widget.roomId);
//   //
//   //   // 2. 메세지를 지속적으로 받아오면서 구독하고 receive 요청!
//   //   final websocketProvider =
//   //       ref.read(stompViewModelProvider.notifier); // 웹소캣 창고 접근(메서드 사용하려고)
//   //   websocketProvider.receive(widget.roomId);
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final sessionUser = ref.read(sessionProvider);
//     final myUserNo = sessionUser.userNo;
//     final Map<String, ChatRoom> chatRoom = ref
//         .watch(chatProvider); // 상태값 꺼내오기(state = Map<String,ChatRoom> 꺼내오는거임)
//     // final List<Message> chatMessages = chatRoom[widget.roomId]?.message ?? [];
//     // final List<ChatUser> chatUsers = chatRoom[widget.roomId]?.chatUser ?? [];
//     logger.i('이건 값1? : $chatRoom');
//     logger.i('이건 값2? : $chatRoom');
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.chatRoomName),
//       ),
//       body: SafeArea(
//         child: SizedBox.expand(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ChatMsgBody(
//               roomId: widget.roomId,
//               chatRoom: chatRoom[widget.roomId]!,
//               userNo: myUserNo ?? '',
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
