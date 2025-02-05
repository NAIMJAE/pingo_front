import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/model_views/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/data/models/chat_model/chat_room_model.dart';
import 'package:pingo_front/data/network/custom_dio.dart';
import 'package:pingo_front/data/repository/root_url.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class StompViewModel extends Notifier<bool> {
  StompClient? stompClient;

  //build를 오버라이드 해줌, state값을 bool로 관리할 예정 / false면 웹소캣 연결 해제
  @override
  bool build() {
    return false;
  }

  // 웹소캣 연결하기 initState일때사용하기
  void stompConnect() async {
    if (stompClient != null) return;
    String? accessToken = await secureStorage.read(key: 'accessToken');
    // stompclient 콜백메서드를 등록할 수 있는 웹소캣의 객체
    stompClient = StompClient(
      config: StompConfig(
        url: wsRootURL,
        webSocketConnectHeaders: {
          'Authorization': accessToken,
        },
        onConnect: _onConnect, // 연결 성공시 실행할 콜백 함수
        onWebSocketError: (dynamic error) =>
            print('연결안되자너 $error.toString()'), // 웹소캣 자체 오류 감지 , 서버 문제
        onStompError: (dynamic error) =>
            print('잘못된 메세지 형식'), // stomp 프로토콜 오류 감지, 잘못된 메시지 형식
        onDisconnect: (StompFrame frame) => print('연결해지'), // 웹소켓 연결 해제 감지
      ),
    );
    stompClient?.activate(); // 웹소캣 활성화
    state = true;
  }

  //frame은 명령(command)와 추가적인 헤더(Header, 키 벨류 형태)와 추가적인 바디(body: payload, 전송되는 데이터)로 구성된다.

  //맨처음 진입했을 때 메시지 갯수를 받아올 수 있는 콜백 메서드를 추가할 필요가 있지 않을까...?

  // 서버에서 메시지 받아오기 받은 메세지를 저장소(chatRoomProvider에 추가할예정)
  // 서버에서 메시지를 받아올 경로
  void _onConnect(StompFrame frame) {
    stompClient?.subscribe(
      destination: '/sub/1',
      callback: (StompFrame frame) {
        final Map<String, dynamic> jsonData = jsonDecode(frame.body!);
        final Message message = Message.fromJson(jsonData);
        // 이전 채팅 가져와야 하기 때문에
        logger.i('이거이거이거 $message');
        _addMessage(message);
      },
    );
    logger.i('연결');
  }
  // 메시지 갯수

  // 서버로 메시지 보내기/ 메세지 보낼 경로, 보내는 메세지 내용
  void sendMessage(Message message) {
    final messages = jsonEncode(message.toJson());
    stompClient?.send(
      destination: '/pub/1',
      body: messages, // 수정 예정 객체 -> JSON 문자열 변환
    );
    logger.i('머나와 $messages.toString()');
  }

  // 연결 해제 하는 메서드 depose일때
  void stompDisconnect() {
    stompClient?.deactivate();
    stompClient = null;
    state = false;
  }

  void _addMessage(Message message) {
    final messageNotifier = ref.read(chatRoomProvider.notifier);
    messageNotifier.addMessage(message);
    logger.i(messageNotifier);
  }
}

// 창고 관리자 + 관리할 창고 설정
final stompViewModelProvider = NotifierProvider<StompViewModel, bool>(
  () {
    return StompViewModel();
  },
);
