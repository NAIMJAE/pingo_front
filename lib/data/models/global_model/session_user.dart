class SessionUser {
  String? userNo;
  String? userName;
  String? accessToken;
  bool isLogin;

  SessionUser(
      {required this.userNo,
      required this.userName,
      required this.accessToken,
      required this.isLogin});

  @override
  String toString() {
    return 'SessionUser{userNo: $userNo, userName: $userName, accessToken: $accessToken, isLogin: $isLogin}';
  }
}
