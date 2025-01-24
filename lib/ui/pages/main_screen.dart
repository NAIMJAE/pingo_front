import 'package:flutter/material.dart';

import '../widgets/common_appbar.dart';
import 'chat_page/chat_page.dart';
import 'keyword_page/keyword_page.dart';
import 'main_page/main_page.dart';
import 'match_state_page/match_state_page.dart';
import 'user_page/user_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 기본적으로 메인 페이지로 설정

  void changeStackPages(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            MainPage(),
            KeywordPage(),
            MatchStatePage(),
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
}
