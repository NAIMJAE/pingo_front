import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/data/models/match_model.dart';
import 'package:pingo_front/data/view_models/main_view_model/main_page_viewmodel.dart';
import 'package:pingo_front/data/view_models/notification_view_model.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/data/view_models/stomp_view_model.dart';
import 'package:pingo_front/ui/pages/community_page/community_page.dart';
import 'chat_page/chat_room_page.dart';
import 'keyword_page/keyword_page.dart';
import 'main_page/main_page.dart';
import 'user_page/user_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0; // 기본적으로 메인 페이지로 설정
  // Map<int, AppBar> indexTitle = {
  //   0: mainAppbar(context, ref),
  // };

  @override
  void initState() {
    super.initState();
    final userNo = ref.read(sessionProvider).userNo; // 내아이디

    // STOMP 웹소캣 연결
    // 현재 코드 실행이 끝난 직후에 실행할 비동기 작업을 예약
    // IndexedStack은 한 번 빌드된 위젯을 계속 유지함(아래 페이지 모두 웹소켓 연결된 상태)
    Future.microtask(() {
      final stompViewModel = ref.read(stompViewModelProvider.notifier);
      stompViewModel.stompConnect(); // STOMP 연결
      stompViewModel.notification(userNo!); // 알림 구독
    });
  }

  void changeStackPages(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 키워드로 조회 - 유저 조회 후 페이지 전환 & main state 변경
  void changePageForKeyword(int index, List<Profile> users) async {
    logger.i('새 유저 ${users.length}');

    // ✅ 이미 사용 중인 ViewModel 가져오기 (기존 TickerProvider 유지)
    final viewModel = ref.read(mainPageViewModelProvider.notifier);

    // ✅ 기존 ViewModel 상태 변경 (새 인스턴스 생성하지 않음)
    await viewModel.changeStateForKeyword(users);

    setState(() {
      _selectedIndex = index;
    });
  }

  /**
   * Provider에 this (TickerProvider)를 넘기면서 새 Provider 인스턴스가 생성됨
   * StateNotifierProvider.family<T, P>는 동적인 파라미터(P)에 따라 서로 다른 Provider 인스턴스를 생성합니다.
      즉, A 페이지에서 사용된 mainPageViewModelProvider(this)와 B 페이지에서 사용된 mainPageViewModelProvider(this)가 서로 다른 인스턴스로 간주될 가능성이 있습니다.
      ⚠️ 문제: IndexedStack 내에서 A 페이지와 B 페이지가 같은 mainPageViewModelProvider를 공유하는 게 아니라,
      각각 다른 vsync 값을 전달하여 서로 다른 ViewModel 인스턴스를 참조할 수 있음.

      즉, B에서 ref.read(mainPageViewModelProvider(this).notifier).updateState()를 호출해도,
      A에서 사용 중인 mainPageViewModelProvider(this)는 해당 변경 사항을 감지하지 못할 가능성이 큼.

      family를 사용하면 TickerProvider (this)가 달라질 때마다 새로운 ViewModel 인스턴스가 생성됩니다.
      즉, A 페이지에서 this (TickerProvider)를 넘길 때마다 새로운 ViewModel 인스턴스를 참조하게 됩니다.
      따라서 B 페이지에서 mainPageViewModelProvider(this)를 변경하더라도, A 페이지`에서 다시 접근할 때 새로운 인스턴스를 참조하여 상태 변경이 반영되지 않습니다.

      1. family를 제거하고, TickerProvider 없이 StateNotifierProvider만 사용 -> TickerProvider를 쓰는 이유를 몰라서 안 해봄

      2. ref.invalidate()를 사용하여 강제 새로고침 -> SingleTickerProviderStateMixin인데 인스턴스 여러개되버리는 에러

      3. ref.listen()을 사용하여 상태 변화를 감지 -> SingleTickerProviderStateMixin인데 인스턴스 여러개되버리는 에러
   */

  @override
  Widget build(BuildContext context) {
    MatchModel? matchModel = ref.watch(notificationViewModelProvider);
    logger.i('match모델머임 ? : ${matchModel.toString()}');
    // 레이아웃이 모두 구성된 이후 호출하기
    if (matchModel != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNotificationAlert(context, matchModel!);
        ref
            .read(notificationViewModelProvider.notifier)
            .emptyNotification(); // 상태 초기화
      });
    }
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            MainPage(),
            KeywordPage(changePageForKeyword),
            CommunityPage(),
            ChatRoomPage(),
            UserPage(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigatorBar(),
    );
  }

  Widget _bottomNavigatorBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (index) {
        changeStackPages(index);
      },
      items: [
        BottomNavigationBarItem(label: '홈', icon: Icon(Icons.home_filled)),
        BottomNavigationBarItem(label: '키워드', icon: Icon(Icons.dashboard)),
        BottomNavigationBarItem(label: '매칭상태', icon: Icon(Icons.join_inner)),
        BottomNavigationBarItem(label: '채팅', icon: Icon(Icons.chat)),
        BottomNavigationBarItem(label: '사용자', icon: Icon(Icons.person)),
      ],
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }

  @override
  void dispose() {
    // 앱 꺼지면 웹소캣 해제
    ref.read(stompViewModelProvider.notifier).stompDisconnect();
    super.dispose();
  }

  // ✅ 자동으로 띄우는 `AlertDialog`
  void _showNotificationAlert(BuildContext context, MatchModel matchModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              "💖 새로운 매칭! 💖",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          content: Container(
            width: 300,
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildUserInfo(matchModel.userName ?? '사용자1', 25,
                    matchModel.userImage ?? ''),
                Icon(Icons.favorite, color: Colors.red, size: 40), // ❤️ 하트 아이콘
                _buildUserInfo(matchModel.userName ?? '사용자2', 28,
                    matchModel.userImage ?? ''),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // 다이얼로그 닫기, 다이얼로그는 새로운 화면이 아니라 오버레이된 UI 요소, 스택관리 X
              },
              child: Text("확인"),
            ),
          ],
        );
      },
    );
  }

  // ✅ 동그란 프로필 사진 + 이름 + 나이 표시하는 위젯
  Widget _buildUserInfo(String name, int age, String imageUrl) {
    return Expanded(
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 8),
          Text(name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text("$age세", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}
