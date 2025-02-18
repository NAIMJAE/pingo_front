class DatingGuide {
  String? dgNo;
  String? title;
  String? contents;
  String? thumb;
  String? category;
  String? userNo;
  int? heart;
  DateTime? regDate;

  String? userName;
  String? userProfile;

  @override
  String toString() {
    return 'DatingGuide{dgNo: $dgNo, title: $title, contents: $contents, thumb: $thumb, category: $category, userNo: $userNo, heart: $heart, regDate: $regDate, userName: $userName, userProfile: $userProfile}';
  }

  DatingGuide.fromJson(Map<String, dynamic> json)
      : dgNo = json['dgNo'],
        title = json['title'],
        contents = json['contents'],
        thumb = json['thumb'],
        category = json['cateName'],
        userNo = json['userNo'],
        heart = json['heart'],
        regDate = DateTime.parse(json['regDate']),
        userName = json['userName'],
        userProfile = json['imageUrl'];
}
