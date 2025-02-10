import 'package:pingo_front/data/models/chat_model/chat_model.dart';
import 'package:pingo_front/data/network/custom_dio.dart';

class ChatRepository {
  final CustomDio _customDio = CustomDio.instance;

  Future<List<Chat>> selectRoomId(String userNo) async {
    final response =
        await _customDio.get('/select/chatRoomId/', query: {'userNo': userNo});

    return response;
  }
}
