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
