import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/global_model/session_user.dart';

// 전역으로 로그인한 사용자의 정보를 관리하는 클래스
// userNo, userName, token등 필요한 정보를 SessionUser 객체로 만들어서 관리
// isLogin을 통해 로그인 유무 확인
class SessionGvm extends Notifier<SessionUser> {
  @override
  SessionUser build() {
    return SessionUser(
        userNo: null, userName: null, accessToken: null, isLogin: false);
  }

  // 1. 디바이스 어딘가에 저장된 로그인 정보를 불러와서 isLogin을 true로 변경하는 함수
  int checkLoginState() {
    // 임시 로직
    // 나중에는 isLogin 여부에 따라 return 값 변경해야함

    return 0;
  }

  // 2. 아이디 비밀번호 입력해 로그인 성공시 isLogin을 true로 변경하는 함수

  // 3. 로그아웃 버튼을 눌러 isLogin을 false로 변경하는 함수
}

final sessionGvmProvider = NotifierProvider<SessionGvm, SessionUser>(
  () => SessionGvm(),
);

// 중요 데이터 보관소
// FlutterSecureStorage();
