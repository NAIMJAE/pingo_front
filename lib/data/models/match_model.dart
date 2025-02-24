class MatchModel {
  final String? userName;
  final String? userAge;
  final String? userImage;

  MatchModel({
    this.userName,
    this.userAge,
    this.userImage,
  });

  MatchModel.fromJson(Map<String, dynamic> json)
      : userName = json['userName'] ?? '',
        userAge = json['userAge'] ?? '',
        userImage = json['userImage'] ?? '';

  @override
  String toString() {
    return 'MatchModel{userName: $userName, userAge: $userAge, userImage: $userImage}';
  }
}
