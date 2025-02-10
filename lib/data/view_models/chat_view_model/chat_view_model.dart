import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_model.dart';
import 'package:pingo_front/data/repository/chat_repository/chat_repository.dart';

class ChatViewModel extends Notifier<List<Chat>> {
  final ChatRepository _repository;
  ChatViewModel(this._repository);

  @override
  List<Chat> build() {
    return [];
  }

  //state는 List<Chat> 인 상태!
  // 메서드 추가
  Future<void> selectChat(String userNo) async {
    try {
      final chatting = await _repository.selectRoomId(userNo);
      state = chatting;
    } catch (e, traceTrack) {
      state = [];
      logger.e('Failed to fetch keywords: $e');
    }
  }
}

//창고 관리자 생성하기
final chatProvider = NotifierProvider<ChatViewModel, List<Chat>>(
  () {
    return ChatViewModel(ChatRepository());
  },
);
