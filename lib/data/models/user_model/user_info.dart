class UserInfo {
  String? userNo;
  DateTime? userBirth;
  int? userHeight;
  String? userAddress;
  String? user1stJob;
  String? user2ndJob;
  String? userReligion;
  String? userDrinking;
  String? userSmoking;
  String? userBloodType;

  UserInfo(
      {this.userNo,
      this.userBirth,
      this.userHeight,
      this.userAddress,
      this.user1stJob,
      this.user2ndJob,
      this.userReligion,
      this.userDrinking,
      this.userSmoking,
      this.userBloodType});

  Map<String, dynamic> toJson() {
    return {
      "userNo": userNo,
      "userBirth": userBirth?.toIso8601String(),
      "userHeight": userHeight,
      "userAddress": userAddress,
      "user1stJob": user1stJob,
      "user2ndJob": user2ndJob,
      "userReligion": userReligion,
      "userDrinking": userDrinking,
      "userSmoking": userSmoking,
      "userBloodType": userBloodType,
    };
  }

  @override
  String toString() {
    return 'UserInfo{userNo: $userNo, userBirth: $userBirth, userHeight: $userHeight, userAddress: $userAddress, user1stJob: $user1stJob, user2ndJob: $user2ndJob, userReligion: $userReligion, userDrinking: $userDrinking, userSmoking: $userSmoking, userBloodType: $userBloodType}';
  }
}
