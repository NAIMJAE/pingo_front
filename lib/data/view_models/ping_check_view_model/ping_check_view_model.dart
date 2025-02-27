import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/keyword_model/keyword.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/data/models/main_model/ProfileDetail.dart';
import 'package:pingo_front/data/models/user_model/user_info.dart';
import 'package:pingo_front/data/repository/ping_check_repository/ping_check_repository.dart';

class PingCheckViewModel extends Notifier<Map<String, List<Profile>>> {
  final PingCheckRepository _repository;
  PingCheckViewModel(this._repository);

  @override
  Map<String, List<Profile>> build() {
    return {
      "super": _generateProfiles(),
      "ping": _generateProfiles(),
    };
  }
}

final pingCheckViewModelProvider =
    NotifierProvider<PingCheckViewModel, Map<String, List<Profile>>>(
  () => PingCheckViewModel(PingCheckRepository()),
);

// 임시 데이터
List<Profile> _generateProfiles() {
  return [
    Profile(
      userNo: 'US12341234',
      name: '박임재',
      age: '31',
      status: '접속 중',
      distance: '1km 거리',
      ImageList: [
        '/images/users/USec57c47a/UI7890bed5.jpeg',
        '/images/users/US5dcc4adb/UI4c1857df.png',
        '/images/users/USd30a4c47/UI1fc3bbce.jpeg'
      ],
      profileDetail: ProfileDetail(
        UserInfo(
            userNo: 'US12341234',
            user1stJob: 'IT직군',
            user2ndJob: '백엔드 개발자',
            userAddress: '부산',
            userBirth: DateTime(2025, 2, 11),
            userBloodType: 'A',
            userDrinking: 'N',
            userHeight: 180,
            userReligion: '천주교',
            userSmoking: 'F'),
        [
          Keyword(
              kwId: 'kw132',
              kwName: '객관',
              kwParentId: 'kg13',
              kwMessage: null,
              kwLevel: '3'),
          Keyword(
              kwId: 'kw143',
              kwName: '감정',
              kwParentId: 'kg14',
              kwMessage: null,
              kwLevel: '3'),
        ],
        '나는 바보입니다.',
      ),
    ),
    Profile(
      userNo: 'US56785678',
      name: '김개발',
      age: '28',
      status: '5분 전 접속',
      distance: '3km 거리',
      ImageList: [
        '/images/users/US5dcc4adb/UI4c1857df.png',
        '/images/users/USec57c47a/UI7890bed5.jpeg',
        '/images/users/USd30a4c47/UI1fc3bbce.jpeg'
      ],
      profileDetail: ProfileDetail(
        UserInfo(
            userNo: 'US56785678',
            user1stJob: '마케팅',
            user2ndJob: '콘텐츠 기획',
            userAddress: '서울',
            userBirth: DateTime(1996, 5, 20),
            userBloodType: 'B',
            userDrinking: 'Y',
            userHeight: 175,
            userReligion: '무교',
            userSmoking: 'F'),
        [
          Keyword(
              kwId: 'kw241',
              kwName: '축구&농구',
              kwParentId: 'kg24',
              kwMessage: null,
              kwLevel: '3'),
          Keyword(
              kwId: 'kw311',
              kwName: '독립',
              kwParentId: 'kg31',
              kwMessage: null,
              kwLevel: '3'),
        ],
        '나는 멋진 개발자입니다.',
      ),
    ),
  ];
}
