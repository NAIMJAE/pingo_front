import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/user_model/user_info.dart';
import '../../../../../data/models/user_model/user_mypage_info.dart';
import '../../../../../data/view_models/signup_view_model/signin_view_model.dart';
import '../../../../../data/view_models/user_view_model/user_view_model.dart';
import 'components/edit_profile_appbar.dart';
import 'components/edit_personal_information_box.dart';
import 'components/edit_self_introduction_box.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late String userNo;
  // 유저 상세정보 복사본
  late UserInfo copyUserInfo;

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

    // 유저 상세 정보 깊은 복사 메서드
    copyUserInfo = UserInfo().copyWith(userMypageInfo.userInfo);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: EditProfileAppBar(context),
        body: ListView(
          children: [
            const SizedBox(height: 8.0),
            EditPersonalInformationBox(copyUserInfo),
            const SizedBox(height: 8.0),
            EditSelfIntroductionBox(),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
