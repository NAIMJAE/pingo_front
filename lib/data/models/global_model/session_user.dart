class SessionUser {
  String? userNo;
  String? userRole;
  String? accessToken;
  bool isLogin;

  SessionUser(
      {this.userNo, this.userRole, this.accessToken, this.isLogin = false});

  @override
  String toString() {
    return 'SessionUser{userNo: $userNo, userName: $userRole, accessToken: $accessToken, isLogin: $isLogin}';
  }
}
