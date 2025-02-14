import 'package:pingo_front/data/models/user_model/user_image.dart';
import 'package:pingo_front/data/models/user_model/user_info.dart';
import 'package:pingo_front/data/models/user_model/users.dart';

class UserMypageInfo {
  Users? users;
  UserInfo? userInfo;
  List<UserImage>? userImageList;

  UserMypageInfo({
    this.users,
    this.userInfo,
    this.userImageList,
  });

  Map<String, dynamic> toJson() {
    return {
      "users": users,
      "userInfo": userInfo,
      "userImageList": userImageList,
    };
  }

  UserMypageInfo.fromJson(Map<String, dynamic> json)
      : users = Users.fromJson(json['users']),
        userInfo = UserInfo.fromJson(json['userInfo']),
        userImageList = (json['userImageList'] as List<dynamic>?)
            ?.map((child) => UserImage.fromJson(child as Map<String, dynamic>))
            .toList();

  @override
  String toString() {
    return 'UserMypageInfo{users: $users, userInfo: $userInfo, userImageList: $userImageList}';
  }
}
