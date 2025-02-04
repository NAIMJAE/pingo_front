import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/global_model/session_user.dart';
import 'package:pingo_front/data/network/custom_dio.dart';
import 'package:pingo_front/data/repository/sign_repository/user_signin_repository.dart';

class SigninViewModel extends Notifier<SessionUser> {
  UserSigninRepository repository = UserSigninRepository();

  @override
  SessionUser build() {
    return SessionUser();
  }

  // 로그인 체크
  Future<bool> checkLoginState() async {
    String? accessToken = await secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      return false;
    }

    Map<String, dynamic> response =
        await repository.loginWithToken(accessToken);

    response = response['data'];

    if (response['message'] == '자동 로그인 성공') {
      state = SessionUser(
        userNo: response['userNo'],
        userRole: response['userRole'],
        accessToken: accessToken,
        isLogin: true,
      );
      return true;
    } else {
      return false;
    }
  }

  // 로그인
  Future<void> login(String userId, String userPw) async {
    Map<String, String> loginData = {
      "userId": userId,
      "userPw": userPw,
    };

    // Map<String, dynamic>
    Map<String, dynamic> userData =
        await repository.fetchSendSignInData(loginData);

    logger.d(userData);

    await secureStorage.write(
        key: 'accessToken', value: userData['accessToken']);

    state = SessionUser(
        userNo: userData['userNo'],
        userRole: userData['userRole'],
        accessToken: userData['accessToken'],
        isLogin: true);

    logger.d(state);
  }
}

final sessionProvider = NotifierProvider<SigninViewModel, SessionUser>(
  () => SigninViewModel(),
);
