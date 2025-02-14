import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_model.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';
import 'package:pingo_front/data/network/custom_dio.dart';

class ChatRepository {
  final CustomDio _customDio = CustomDio.instance;

  //채팅방 목록 조회
  Future<List<Chat>> selectRoomId(String userNo) async {
    final response =
        await _customDio.get('/select/chatRoom', query: {'userNo': userNo});
    logger.i('respnse: $response');

    // List<Chat>으로 변경처리
    return List<Map<String, dynamic>>.from(response)
        .map((json) => Chat.fromJson(json))
        .toList();
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
