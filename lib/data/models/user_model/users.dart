class Users {
  String? userNo;
  String? userId;
  String? userPw;
  String? userName;
  String? userNick;
  String? userGender;
  String? userState;
  DateTime? userrDate;
  String? userEmail;

  Users({
    this.userNo,
    this.userId,
    this.userPw,
    this.userName,
    this.userNick,
    this.userGender,
    this.userState,
    this.userrDate,
    this.userEmail,
  });

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
      "userEmail": userEmail,
    };
  }

  Users.fromJson(Map<String, dynamic> json)
      : userNo = json['userNo'],
        userId = json['userId'],
        userPw = json['userPw'],
        userName = json['userName'],
        userNick = json['userNick'],
        userGender = json['userGender'],
        userState = json['userState'],
        userrDate = json['userrDate'] != null
            ? DateTime.parse(json['userrDate'])
            : null,
        userEmail = json['userEmail'];

  @override
  String toString() {
    return 'Users{userNo: $userNo, userId: $userId, userPw: $userPw,'
        'userName: $userName, userNick: $userNick, userGender: $userGender,'
        'userState: $userState, userrDate: $userrDate, userEmail: $userEmail}';
  }
}
