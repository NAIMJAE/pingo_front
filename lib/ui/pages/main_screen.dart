import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/model_views/stomp_view_model.dart';

import '../widgets/common_appbar.dart';
import 'chat_page/chat_page.dart';
import 'keyword_page/keyword_page.dart';
import 'main_page/main_page.dart';
import 'swipe_state_page/swipe_state_page.dart';
import 'user_page/user_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0; // 기본적으로 메인 페이지로 설정

  @override
  void initState() {
    super.initState();

    // STOMP 웹소캣 연결
    // 현재 코드 실행이 끝난 직후에 실행할 비동기 작업을 예약
    Future.microtask(
        () => ref.read(stompViewModelProvider.notifier).stompConnect());
  }

  void changeStackPages(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(context, ref),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            MainPage(),
            KeywordPage(),
            SwipeStatePage(),
            ChatPage(),
            UserPage(),
          ],
        ),
        bottomNavigationBar: _bottomNavigatorBar(),
      ),
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
}
