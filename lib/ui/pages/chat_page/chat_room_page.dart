import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/models/chat_model/chat_user.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_view_model.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/data/view_models/stomp_view_model.dart';

import 'components/chat_match.dart';
import 'components/chat_room_list.dart';
import 'components/chat_search_header.dart';

class ChatRoomPage extends ConsumerStatefulWidget {
  const ChatRoomPage({super.key});

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatRoomPage> {
  late String? userNo;

  // initState는 비동기를 직접 사용할 수 없음.
  @override
  void initState() {
    super.initState();

    final sessionUser = ref.read(sessionProvider);
    userNo = sessionUser.userNo;

    // 여기서 chat 뷰모델의 초기 데이터 조회하는 로직 수행 (userNo)
    // 여기에서 모든 정보 다 받아오기 (페이징처리 필요)
    Future<void> _fetchChatList() async {
      final chatProviders = ref.read(chatProvider.notifier);
      Map<String, ChatRoom> chatList =
          await chatProviders.selectChatRoom(userNo ?? '사용자없음');
      logger.e("이거  chatList 머나와나 $chatList");
      //키 RoomId를 가져온다.
      List<String> roomIds = chatList.keys.toList();

      final websocketProvider = ref.read(stompViewModelProvider.notifier);

      //키를 전달한다.
      //각각의 키로 웹소캣을 구독하고 receive 호출만 하면 stompview모델에서 알아서 view모델의 메서드로 message를 전달한다.
      for (var roomId in roomIds) {
        websocketProvider.receive(roomId);
      }
    }

    _fetchChatList();
  }

  // chatList는 Map<String,ChatRoom>의 형태를 지닌다.
  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(chatProvider); // 상태를 한번 읽어오기
    ChatRoomViewModel chatRoomViewModel = ref.read(chatProvider.notifier);
    Map<String, ChatRoom> listChat = {};
    Map<String, ChatRoom> matchChat = {};

    //키 별로 반복(맵을 우선 펼쳐서)
    for (var entry in chatList.entries) {
      String roomKey = entry.key;
      ChatRoom chatRoom = entry.value;

      // 파싱처리
      List<ChatUser> filterUsers =
          chatRoom.chatUser.where((user) => user.userNo != userNo).toList();

      if (chatRoom.lastMessage != '') {
        listChat[roomKey] = ChatRoom(
            chatUser: filterUsers,
            message: chatRoom.message,
            lastMessage: chatRoom.lastMessage);
      } else {
        matchChat[roomKey] = ChatRoom(
            chatUser: filterUsers,
            message: chatRoom.message,
            lastMessage: chatRoom.lastMessage);
      }
    }

    // chatList의 List<ChatRoom> 안에 userNo가 아닌 ChatRoom List를 들고오기

    // fromEntiries : 필터링 된 데이터를 다시 Map 형태로 변환
    // entires 펼쳐서 키, 벨류로 펼침
    // final matchChat = Map.fromEntries(
    //   chatList.entries.where((e) => (e.value.lastMessage == '')),
    // );
    // // final listChat = Map.fromEntries(
    // //   chatList.entries.where((e) => (e.value.lastMessage != '')),
    // // );

    // DB에서 chatList를 먼저 불러온다 (몽고도 사용해서 마지막메세지를 가져옴)
    // 그 후 웹소캣을 구독해서 새로운 메세지가 온다면
    // chatList로 받기
    // ChatMessageList의 마지막메세지 내용을 웹소캣으로 변경처리 해주기
    // ChatMessageList의 내용을 바꿔주기..

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ChatSearchHeader(chatList),
            SizedBox(height: 12),
            ChatMatch(
              chatList: matchChat,
            ),
            SizedBox(height: 12),
            ChatRoomList(listChat, chatRoomViewModel),
          ],
        ),
      ),
    );
  }
}

//리스트 뷰 자동으로 가로,세로 설정 됨
