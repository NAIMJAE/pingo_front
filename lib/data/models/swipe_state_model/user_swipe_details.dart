class UserSwipeDetails {
  String? userNo;
  String? userName;
  String? userNick;
  String? userGender;
  String? imageUrl;
  String? swipeNo;

  UserSwipeDetails(
      {required this.userNo,
      required this.userName,
      required this.userNick,
      required this.userGender,
      required this.imageUrl,
      required this.swipeNo});

  UserSwipeDetails.fromJson(Map<String, dynamic> json)
      : userNo = json['userNo'],
        userName = json['userName'],
        userNick = json['userNick'],
        userGender = json['userGender'],
        imageUrl = json['imageUrl'],
        swipeNo = json['swipeNo'];

  static List<UserSwipeDetails> jsonToList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => UserSwipeDetails.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
