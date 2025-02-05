import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/global_model/session_user.dart';
import 'package:pingo_front/data/network/custom_dio.dart';
import 'package:pingo_front/data/repository/sign_repository/user_signin_repository.dart';
import 'package:pingo_front/main.dart';

class SigninViewModel extends Notifier<SessionUser> {
  final mContext = navigatorkey.currentContext!;
  UserSigninRepository repository = UserSigninRepository();

  @override
  SessionUser build() {
    return SessionUser();
  }

  // 로그인 체크
  Future<void> checkLoginState() async {
    String? accessToken = await secureStorage.read(key: 'accessToken');
    if (accessToken == null) {
      throw Exception('토큰 없음');
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
      CustomDio.instance.setToken(accessToken);
      Navigator.popAndPushNamed(mContext, '/mainScreen');
    } else {
      throw Exception('로그인 실패');
    }
  }

  // 로그인
  Future<void> login(String userId, String userPw) async {
    Map<String, String> loginData = {
      "userId": userId,
      "userPw": userPw,
    };

    Map<String, dynamic> userData =
        await repository.fetchSendSignInData(loginData);

    logger.d(userData);

    await secureStorage.write(
        key: 'accessToken', value: userData['accessToken']);

    state = SessionUser(
      userNo: userData['userNo'],
      userRole: userData['userRole'],
      accessToken: userData['accessToken'],
      isLogin: true,
    );
    CustomDio.instance.setToken(userData['accessToken']);
    Navigator.popAndPushNamed(mContext, '/mainScreen');
  }

  // 로그아웃
  void logout() {
    secureStorage.delete(key: 'accessToken');
    state = SessionUser(
      userNo: null,
      userRole: null,
      accessToken: null,
      isLogin: false,
    );
    CustomDio.instance.clearToken();
    Navigator.popAndPushNamed(mContext, '/signin');
  }
}

final sessionProvider = NotifierProvider<SigninViewModel, SessionUser>(
  () => SigninViewModel(),
);
