class Users {
  String? userNo;
  String? userId;
  String? userPw;
  String? userName;
  String? userNick;
  String? userGender;
  String? userState;
  DateTime? userrDate;

  Users(
      {this.userNo,
      this.userId,
      this.userPw,
      this.userName,
      this.userNick,
      this.userGender,
      this.userState,
      this.userrDate});

  Map<String, dynamic> toJson() {
    return {
      "userNo": userNo,
      "userId": userId,
      "userPw": userPw,
      "userName": userName,
      "userNick": userNick,
      "userGender": userGender,
      "userState": userState,
      "userrDate": userrDate?.toIso8601String(), // DateTime 변환 필요
    };
  }

  @override
  String toString() {
    return 'Users{userNo: $userNo, userId: $userId, userPw: $userPw, userName: $userName, userNick: $userNick, userGender: $userGender, userState: $userState, userrDate: $userrDate}';
  }
}
