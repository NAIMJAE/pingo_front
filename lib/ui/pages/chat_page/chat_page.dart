import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/global_model/session_user.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_view_model.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';

import 'components/chat_match.dart';
import 'components/chat_message_list.dart';
import 'components/chat_search_header.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late String? userNo;

  @override
  void initState() {
    super.initState();
    final sessionUser = ref.watch(sessionProvider);
    userNo = sessionUser.userNo;
    // 여기서 chat 뷰모델의 초기 데이터 조회하는 로직 수행 (userNo)
  }

  @override
  Widget build(BuildContext context) {
    final chatList = ref.watch(chatProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            ChatSearchHeader(chatList),
            SizedBox(height: 12),
            ChatMatch(
              chatList: [],
            ),
            SizedBox(height: 12),
            ChatMessageList(chatList),
          ],
        ),
      ),
    );
  }
}

//리스트 뷰 자동으로 가로,세로 설정 됨
