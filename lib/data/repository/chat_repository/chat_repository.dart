import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_user.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';
import 'package:pingo_front/data/models/chat_model/chat_room.dart';
import 'package:pingo_front/data/network/custom_dio.dart';

class ChatRepository {
  final CustomDio _customDio = CustomDio.instance;

  //채팅방 목록 조회
  Future<Map<String, ChatRoom>> selectRoomId(String userNo) async {
    final Map<String, dynamic> response =
        await _customDio.get('/select/chatRoom', query: {'userNo': userNo});
    logger.i('response: $response');

    // "romm1" : {List<User>, Null, lastMsg}

    // json -> Map<String, ChatRoom>

    // List<ChatRoom> -> 원하는 채팅방을 찾을때 전부다 돌아봐야함
    // Map<String, ChatRoom> -> String 값만 알면 빠르게 원하는 채팅방 찾기 가능

    Map<String, ChatRoom> result = {};

    // Map<String,dynamic> 데이터를 Map<String,ChatRoom>으로 변환해야 한다. response의 각 요소를 순회하면서 ChatRoom객체로 변환해야함
    response.forEach((key, value) =>
        result[key] = ChatRoom.fromJson(value as Map<String, dynamic>));

    logger.i(result);

    return result;

    // return Map<String, ChatRoom>

    // List<Chat>으로 변경처리
    // return List<Map<String, dynamic>>.from(response)
    //     .map((json) => Chat.fromJson(json))
    //     .toList();
  }

  //채팅방 메세지 조회
  Future<List<Message>> selectMessage(String roomId) async {
    final response =
        await _customDio.get('/select/message', query: {'roomId': roomId});
    logger.i('messageReponse : $response');

    return List<Map<String, dynamic>>.from(response)
        .map((json) => Message.fromJson(json))
        .toList();
  }
}
