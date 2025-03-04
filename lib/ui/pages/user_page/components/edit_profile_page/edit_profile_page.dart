import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/ui/pages/user_page/components/edit_profile_page/components/edit_user_email.dart';
import 'package:pingo_front/ui/pages/user_page/components/edit_profile_page/components/edit_user_keyword_box.dart';
import '../../../../../data/models/user_model/user_mypage_info.dart';
import '../../../../../data/view_models/sign_view_model/signin_view_model.dart';
import '../../../../../data/view_models/user_view_model/user_view_model.dart';
import 'components/edit_profile_appbar.dart';
import 'components/edit_personal_information_box.dart';
import 'components/edit_self_introduction_box.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late String userNo;
  // 유저 상세정보 복사본
  late UserMypageInfo copyUserInfo;

  // stateful 위젯이 생성될 때 최초 1회만 실행하는 메서드
  @override
  void initState() {
    super.initState();
    userNo = ref.read(sessionProvider).userNo!;
    ref.read(userViewModelProvider.notifier).fetchMyPageInfo(userNo);
  }

  // 수정 완료 버튼 눌렀을때 실행되는 함수
  void _submitUserInfo() async {
    print(copyUserInfo.userIntroduction); // 여기서 JSON 데이터를 확인

    await ref
        .read(userViewModelProvider.notifier)
        .submitUpdateInfo(copyUserInfo);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userNotifier = ref.read(userViewModelProvider.notifier); // 읽기 전용
    final userMypageInfo =
        ref.watch(userViewModelProvider); // 계속해서 감시 (즉, 추적 관리, 구독)

    // 유저 상세 정보 깊은 복사 메서드
    copyUserInfo = UserMypageInfo().copyWith(userMypageInfo);

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: EditProfileAppBar(context),
          backgroundColor: Colors.black12,
          body: ListView(
            children: [
              const SizedBox(height: 8.0),
              EditUserEmail(copyUserInfo.users!.userEmail ?? '', userNotifier),
              const SizedBox(height: 8.0),
              EditPersonalInformationBox(copyUserInfo.userInfo!),
              const SizedBox(height: 8.0),
              EditUserKeywordBox(copyUserInfo.myKeywordList!,
                  copyUserInfo.favoriteKeywordList!),
              const SizedBox(height: 8.0),
              EditSelfIntroductionBox(copyUserInfo),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: _submitButton(),
      ),
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF906FB7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        onPressed: () => _submitUserInfo(),
        child: Text(
          '수정 완료',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}
