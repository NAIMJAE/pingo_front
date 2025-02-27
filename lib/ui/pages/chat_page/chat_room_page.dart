import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/models/chat_model/chat_user.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/data/view_models/sign_view_model/signin_view_model.dart';
import 'package:pingo_front/data/view_models/stomp_view_model.dart';
import 'package:pingo_front/ui/pages/main_screen.dart';
import 'package:pingo_front/ui/pages/observer_page.dart';
import 'package:pingo_front/ui/widgets/appbar/chat_appbar.dart';

import 'components/chat_match.dart';
import 'components/chat_room_list.dart';
import 'components/chat_search_header.dart';

class ChatRoomPage extends ConsumerStatefulWidget {
  const ChatRoomPage({super.key});

  @override
  ConsumerState<ChatRoomPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatRoomPage> {
  late observerPage _lifecycleObserver;
  late String? myUserNo;

  // initState는 비동기를 직접 사용할 수 없음.
  @override
  void initState() {
    super.initState();

    final sessionUser = ref.read(sessionProvider);
    myUserNo = sessionUser.userNo;

    // 여기서 chat 뷰모델의 초기 데이터 조회하는 로직 수행 (userNo)
    // 여기에서 모든 정보 다 받아오기 (페이징처리 필요)
    Future<void> _fetchChatList() async {
      final chatProviders = ref.read(chatProvider.notifier);
      Map<String, ChatRoom> chatList =
          await chatProviders.selectChatRoom(myUserNo ?? '사용자없음');
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

    Map<String, ChatRoom> listChat = {};
    Map<String, ChatRoom> matchChat = {};

    //키 별로 반복(맵을 우선 펼쳐서)
    for (var entry in chatList.entries) {
      String roomKey = entry.key;
      ChatRoom chatRoom = entry.value;

      // 파싱처리
      List<ChatUser> filterUsers =
          chatRoom.chatUser.where((user) => user.userNo != myUserNo).toList();

      // 내가 보낸게 아닌 메세지
      List<ChatMessage> filterMessages =
          chatRoom.message.where((msg) => msg.userNo != myUserNo).toList();

      // 남이 보낸 메세지 중 마지막 메세지
      String finalMessage = filterMessages
          .map((e) => e.msgContent == chatRoom.lastMessage)
          .toString();

      // 상대방 유저이름
      String userName = filterUsers
          .map(
            (e) => e.userName,
          )
          .toString();

      // ✅ 옵저버 생성 및 상태 변경 감지
      _lifecycleObserver = observerPage(
        onStateChanged: (state) {
          if (state == AppLifecycleState.resumed) {
            // showNotification(finalMessage, roomKey, myUserNo!, userName);
            print("✅ 앱이 다시 활성화됨!");
          } else if (state == AppLifecycleState.paused) {
            print("⏸️ 앱이 백그라운드로 이동함.");
            return;
          }
        },
      );

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
    // logger.e('★★★$listChat');
    // logger.e('★★★$matchChat');

    return Scaffold(
      appBar: chatAppbar(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ChatSearchHeader(chatList),
            const SizedBox(height: 8),
            ChatMatch(
              chatList: matchChat,
              myUserNo: myUserNo!,
            ),
            const SizedBox(height: 8),
            ChatRoomList(listChat, myUserNo!),
          ],
        ),
      ),
    );
  }

  Future<void> showNotification(String messageContent, String roomKey,
      String myUserNo, String userName) async {
// if 조건문 걸어서 내 메세지면 return 시켜 버림
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'chat_channel_id', // 채널 ID
      '채팅 알림', // 채널 이름
      importance: Importance.high,
      priority: Priority.high,
    );

// WidgetsBindingObserver ---> 앱이 백그라운지 포그라운드인지 확인 가능
// "백그라운드에서 받은 알림"을 앱 진입 시 무시하도록 처리(시간 기준으로)
//
// 앱이 포그라운드일 때 → 상단 배너(Snackbar) 표시
// 앱이 백그라운드일 때 → 푸시 알림 표시

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // 매개변수로 받은 데이터를 객체로 변환시키기
    String payloadData = jsonEncode({
      'roomId': roomKey,
      'chatRoomName': userName,
      'myUserNo': myUserNo,
    });

    await flutterLocalNotificationsPlugin.show(
        roomKey.hashCode.abs(), // 알림 ID 정수형 Id로 변환..
        '새 메세지 도착', // 알림 제목
        messageContent, // 메시지 내용
        details,
        payload: payloadData); //Json으로 변환해서 전달 가능
  }
}

//리스트 뷰 자동으로 가로,세로 설정 됨
