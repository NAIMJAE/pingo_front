import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/data/view_models/user_view_model/user_view_model.dart';
import '../../../data/models/user_model/mypage_menu.dart';
import 'components/myinfo_box.dart';
import 'components/mypage_box.dart';
import 'components/profile_photo_box.dart';

class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key});

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  late String userNo;

  // stateful 위젯이 생성될 때 최초 1회만 실행하는 메서드
  @override
  void initState() {
    super.initState();
    userNo = ref.read(sessionProvider).userNo!;
    ref.read(userViewModelProvider.notifier).fetchMyPageInfo(userNo);
  }

  @override
  Widget build(BuildContext context) {
    final userViewModelNotifier =
        ref.read(userViewModelProvider.notifier); // 읽기 전용
    final userMypageInfo =
        ref.watch(userViewModelProvider); // 계속해서 감시 (즉, 추적 관리, 구독)

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
          MyinfoBox(userMypageInfo),
          const SizedBox(height: 8.0),
          ProfilePhotoBox(userMypageInfo.userImageList),
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
