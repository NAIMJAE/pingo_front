import 'package:flutter/material.dart';

import 'components/common_appbar.dart';
import 'pages/chat_page/chat_page.dart';
import 'pages/keyword_page/keyword_page.dart';
import 'pages/main_page/main_page.dart';
import 'pages/match_state_page/match_state_page.dart';
import 'pages/user_page/user_page.dart';
import 'theme/theme.dart';

void main() {
  runApp(const PingoApp());
}

class PingoApp extends StatefulWidget {
  const PingoApp({super.key});

  @override
  State<PingoApp> createState() => _PingoAppState();
}

class _PingoAppState extends State<PingoApp> {
  int _selectedIndex = 0;

  void changeStackPages(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mTheme(),
      home: SafeArea(
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
      showSelectedLabels: false, // 선택된 아이템의 label 숨기기
      showUnselectedLabels: false, // 선택되지 않은 아이템의 label 숨기기
    );
  }
}
