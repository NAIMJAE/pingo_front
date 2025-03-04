import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/chat_model/chat_msg_model.dart';
import 'package:pingo_front/data/models/chat_model/chat_user.dart';
import 'package:pingo_front/data/view_models/chat_view_model/chat_room_view_model.dart';
import 'package:pingo_front/data/view_models/stomp_view_model.dart';
import 'package:pingo_front/ui/pages/chat_page/components/place_map.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// consumer 처리하기
class ChatMsgBody extends ConsumerStatefulWidget {
  final String roomId;
  final String myUserNo;

  ChatMsgBody({required this.roomId, required this.myUserNo, super.key});

  @override
  _ChatMsgBodyState createState() => _ChatMsgBodyState();
}

class _ChatMsgBodyState extends ConsumerState<ChatMsgBody> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scroll = ScrollController();
  late StompViewModel websocketProvider; // 웹소캣 객체를 저장(메세지를 보내기 위한)
  final RefreshController _refreshController = RefreshController();

  // 선언하고 initState()에서 ref.read를 사용해서 초기화를 했기때문에 build 안에서 사용가능함!

  @override
  void initState() {
    super.initState();
    // 2. 메세지를 지속적으로 받아오면서 구독하고 receive 요청!
    websocketProvider =
        ref.read(stompViewModelProvider.notifier); // 웹소캣 창고 접근(메서드 사용하려고)

    // websocketProvider.receive(widget.roomId);
  }
  //   super.initState();
  //   // 1. 백엔드 데이터베이스에서 최초로 message 정보를 불러오기 -> chatRoomProvider State에 저장
  //   // aaa();
  // }
  //
  // void aaa() async {
  //   final chatViewModel = ref.read(chatProvider.notifier);
  //   await chatViewModel.selectMessage(widget.roomId);
  //
  //   // 2. 메세지를 지속적으로 받아오면서 구독하고 receive 요청!
  //   final websocketProvider =
  //       ref.read(stompViewModelProvider.notifier); // 웹소캣 창고 접근(메서드 사용하려고)
  //   websocketProvider.receive(widget.roomId);
  // }

  // 메세지내용 + 메세지 입력
  @override
  Widget build(BuildContext context) {
    // final sessionUser = ref.read(sessionProvider);
    // final myUserNo = sessionUser.userNo;
    final chatRoom = ref.watch(chatProvider)[
        widget.roomId]; // 상태값 꺼내오기(state = Map<String,ChatRoom> 꺼내오는거임)'
    logger.i('이곳도 계속 찍히니? $chatRoom');

    //WidgetsBinding : 라이프사이클 관리
    // build() 완료 후 최하단으로 스크롤
    //  Flutter의 프레임이 그려진 직후(즉, build()가 완료된 후)에 특정 코드를 실행하도록 예약하는 함수(한번만 실행)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scroll.hasClients) {
        scroll.jumpTo(scroll.position.maxScrollExtent);
      }
    }); // logger.i('도달여부확인');
    // final List<Message> chatMessages =
    //     widget.chatRoom[widget.roomId]?.message ?? [];
    // final List<ChatUser> chatUsers =
    //     widget.chatRoom[widget.roomId]?.chatUser ?? [];

    List<ChatUser>? totalUser = chatRoom?.chatUser;
    logger.e('ㅁㅁㅁㅁㅁㅁㅁㅁㅁㅁ ${totalUser.toString()}');

    return Column(
      children: [
        Expanded(
          child: SmartRefresher(
            controller: _refreshController, // RefreshController 추가
            enablePullDown: true, // 위에서 아래로 스크롤할 때 실행 (과거 메시지 불러오기)
            enablePullUp: false,
            onRefresh: () async {
              bool aa = await ref
                  .read(chatProvider.notifier)
                  .loadOlderMessages(widget.roomId);
              if (aa == false) {
                logger.i('현재 aa : $aa');
                _refreshController.loadNoData(); // 불러올 데이터가 없음
                // 스낵바 추가 원할시 추가하기
              }
              logger.i('현재 aa : $aa');
              _refreshController.refreshCompleted(); // 데이터를 불러와서 빙글빙글 돌아가는 거 없앰
            },
            child: ListView.builder(
              controller: scroll,
              shrinkWrap: true,
              itemCount: chatRoom?.message.length,
              itemBuilder: (context, index) {
                final message = chatRoom?.message[index];
                // final chatUser = chatUsers[index];
                return _buildMessageItem(message!, widget.myUserNo, totalUser!);
              },
            ),
          ),
        ),
        Row(
          children: [
            // + 버튼 (모달 열기)
            IconButton(
              onPressed: () {
                showBottomSheet(context);
              },
              icon: Icon(Icons.add, color: Colors.blue),
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: 4,
                minLines: 1,
                textAlignVertical: TextAlignVertical.center, // 커서 수직 정렬
                decoration: InputDecoration(
                  hintText: '메시지 내용을 입력하세요',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10), // 커서 중앙 정렬
                  suffixIcon: IconButton(
                    onPressed: () {
                      final defaultMessage = ChatMessage(
                        roomId: widget.roomId, // 채팅방 번호는 고정
                        isRead: false, // 읽음 카운트
                      );
                      // 새 메시지 생성
                      final newMessage = defaultMessage.copyWith(
                        msgContent: _messageController.text, // 입력 필드에서 가져온 내용
                        msgType: 'text',
                        fileName: null,
                        userNo: widget.myUserNo, // 보낸 사람 ID (로그인한 사용자 ID)
                        msgTime: DateTime.now(), // 현재 시간
                      );
                      logger.i('머머 $newMessage');
                      websocketProvider.sendMessage(
                          newMessage, widget.roomId, null, null);

                      // 메시지 추가

                      // 입력 필드 초기화
                      _messageController.clear();
                      // 최하단으로 스크롤 내리려고하는데..
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          if (scroll.hasClients) {
                            scroll.jumpTo(scroll.position.maxScrollExtent);
                          }
                        },
                      );
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 이미지 바텀 모달
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _showBottomSheet(context); // 아래에서 `Widget` 반환
      },
    );
  }

  // 이미지 바텀 모달
  Widget _showBottomSheet(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 150,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.image, color: Colors.blue),
              title: Text("이미지 보내기"),
              onTap: () async {
                File? chatFile = await getImage(ImageSource.gallery);
                if (!mounted) return; // ✅ 위젯이 여전히 살아있는지 확인
                logger.i('현재상태 $mounted');
                final defaultMessage = ChatMessage(
                  roomId: widget.roomId,
                  isRead: false,
                );
                final newMessage = defaultMessage.copyWith(
                  //msgContent: imagePath ?? '',
                  msgType: 'image',
                  fileName: null,
                  userNo: widget.myUserNo,
                  msgTime: DateTime.now(),
                );
                websocketProvider.sendMessage(
                    newMessage, widget.roomId, chatFile, null);
                if (mounted) {
                  Future.microtask(() {
                    Navigator.pop(context);
                  });
                }
                // 이미지 보내기 로직 추가
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_file, color: Colors.blue),
              title: Text("첨부파일 보내기"),
              onTap: () async {
                logger.i('33333333333');
                Map<String, dynamic>? chatFile = await getFile();
                if (!mounted) return; // ✅ 위젯이 여전히 살아있는지 확인
                logger.i('현재상태 $mounted');
                final defaultMessage = ChatMessage(
                  roomId: widget.roomId,
                  isRead: false,
                );
                final newMessage = defaultMessage.copyWith(
                  //msgContent: imagePath ?? '',
                  fileName: chatFile?['fileName'],
                  msgType: 'file',
                  userNo: widget.myUserNo,
                  msgTime: DateTime.now(),
                );
                websocketProvider.sendMessage(newMessage, widget.roomId,
                    chatFile?['file'], chatFile?['fileName']);

                if (mounted) {
                  Future.microtask(() {
                    Navigator.pop(context);
                  });
                }
                // 첨부파일 보내기 로직 추가
              },
            ),
          ],
        ),
      ),
    );
  }

  // 메시지 내용 띄우는 위젯
  Widget _buildMessageItem(
      ChatMessage message, String? userNo, List<ChatUser> totalUser) {
    final ChatUser selectUser = totalUser.firstWhere(
      (each) => each.userNo == message.userNo,
    );

    return Align(
      alignment:
          // 로그인한 사람이 본인이면 오른쪽에 배치, 아니면 왼쪽에 배치
          message.userNo == userNo
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: message.userNo == userNo
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (message.userNo != userNo) //상대방일때
              CircleAvatar(
                radius: 20,
                backgroundImage: CustomImage().provider(selectUser.imageUrl!),
              ),
            Row(
              // 정렬 변경

              crossAxisAlignment: CrossAxisAlignment.end,
              children: message.userNo != userNo
                  ? [
                      SizedBox(width: 5),
                      _buildText(message, userNo),
                      SizedBox(width: 5),
                      _buildRead(message, userNo),
                    ]
                  : [
                      SizedBox(width: 5),
                      _buildRead(message, userNo),
                      SizedBox(width: 5),
                      _buildText(message, userNo),
                    ],
            ),
          ],
        ),
      ),
    );
  }

// 메시지 내용 말풍선
  Widget _buildText(ChatMessage message, String? userNo) {
    if (message.msgType == 'image') {
      return Container(
        constraints: BoxConstraints(maxWidth: 250), // 너무 길면 알아서 자르기
        padding: EdgeInsets.only(left: 16),
        child: CustomImage().token(
          message.msgContent ?? '',
        ),
      );
    }
    if (message.msgType == 'file') {
      return Container(
        constraints: BoxConstraints(maxWidth: 250), // 너무 길면 알아서 자르기
        padding: EdgeInsets.only(left: 16),
        child: _msgFileBox(),
      );
    }
    if (message.msgType == 'place') {
      return Container(
        constraints: BoxConstraints(maxWidth: 250), // 너무 길면 알아서 자르기
        padding: EdgeInsets.only(left: 16),
        child: _msgPlaceBox(message),
      );
    }

    return Container(
      //wrap --> 길면 자를 수 있도록 설정할 수 있는 것
      constraints: BoxConstraints(maxWidth: 250), // 너무 길면 알아서 자르기
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: message.userNo == userNo ? Colors.blue : Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '${message.msgContent}',
        style: TextStyle(
          color: message.userNo == userNo ? Colors.white : Colors.black,
        ),
      ),
    );
  }

// 읽음 + 시간 풍선
  Widget _buildRead(ChatMessage message, String? userNo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('${message.isRead}'),
        Text('${formatTime(message.msgTime)}'),
      ],
    );
  }

// 데이트타임 짜르는 메서드
  String formatTime(DateTime? time) {
    if (time == null) return '';
    return DateFormat('HH:mm').format(time);
  }

// 첨부파일 박스
  Widget _msgFileBox() {
    return Container(
      constraints: BoxConstraints(maxWidth: 250), // 메시지 최대 너비 제한
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.blueAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '파일이름',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.insert_drive_file, color: Colors.blue),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "용량: 3333333",
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
          SizedBox(height: 8),
          GestureDetector(
            onTap: () {},
            child: Text(
              "다운로드",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

// 장소 공유 박스
  Widget _msgPlaceBox(ChatMessage message) {
    List<String>? placeInfo = message.fileName?.split('@#');
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceMap(
                placeName: placeInfo?[0] ?? '',
                placeAddress: placeInfo?[1] ?? ''),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(maxWidth: 250), // 메시지 최대 너비 제한
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CustomImage().provider(message.msgContent ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placeInfo?[0] ?? '',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    placeInfo?[1] ?? '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.black54),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// 이미지 가져오는 함수 (imageSource = 갤러리 사진) 매개변수로 받아서 디코딩
// 플러터 로컬 디바이스 전용 경로
// 서버에서 해당 경로를 직접 접근할 수 없기때문에 multipart/form-data로 전송해야 한다.?
  Future<File?> getImage(ImageSource imageSource) async {
    File? _image; // 이미지 담을 변수 선언
    final ImagePicker picker = ImagePicker(); // 이미지픽커 초기화
    final pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      return _image;
    }
  }

// File (우선 1개만.. single로 처리)
  Future<Map<String, dynamic>?> getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      String fileName = result.files.single.name;
      String? filePath = result.files.single.path;

      if (filePath != null) {
        File file = File(filePath);
        return {
          'file': file,
          'fileName': fileName,
        };
      }
    }

    print('파일 선택 취소');
    return null;
  }
}

//1. 가장 상단에 스크롤을 더 했을 때
// 2. 서버 요청 -> 불ㄹ러올 메세지가 없으면 스크롤 종료 //마지막 메세지 Id를 확인 -> 그거로부터 200개 // 서버에서 200개보다 이하일땐 나머지 모두 불러온다?
// 불러올 메세지 있으면 state에 저장해서 띄우기

// Future<void> loadOlderMessages(String roomId) async {
//   if (!hasMoreMessages[roomId]!) {
//     logger.i("⚠ 더 이상 불러올 메시지가 없음.");
//     _refreshController.refreshCompleted(); // ✅ 로딩 종료
//     return;
//   }
//
//   String lastMessageId = state[roomId]!.first.id;  // ✅ 현재 가장 오래된 메시지 ID
//   final response = await http.get(Uri.parse("$apiUrl?roomId=$roomId&beforeId=$lastMessageId"));
//
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     List<ChatMessage> olderMessages = (data['messages'] as List)
//         .map((e) => ChatMessage.fromJson(e))
//         .toList();
//
//     if (olderMessages.isEmpty) {
//       hasMoreMessages[roomId] = false;  // ✅ 더 이상 불러올 메시지가 없으면 false
//     } else {
//       state = {
//         ...state,
//         roomId: [...olderMessages, ...state[roomId]!],  // ✅ 기존 메시지 위에 추가
//       };
//     }
//   }
//
//   _refreshController.refreshCompleted(); // ✅ 로딩 완료
// }
