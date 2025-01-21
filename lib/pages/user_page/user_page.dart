import 'package:flutter/material.dart';
import 'components/myinfo_box.dart';
import 'components/mypage_box.dart';
import '../../models/user_model/mypage_menu.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '마이페이지',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          const SizedBox(height: 4.0),
          MyinfoBox(),
          const SizedBox(height: 8.0),
          MypageBox(myPageMenuList: MypageMenu1),
          const SizedBox(height: 8.0),
          MypageBox(myPageMenuList: MypageMenu2),
          const SizedBox(height: 8.0),
          MypageBox(myPageMenuList: MypageMenu3),
        ],
      ),
    );
  }
}
