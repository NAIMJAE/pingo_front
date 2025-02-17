import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/user_model/user_image.dart';
import 'package:pingo_front/data/models/user_model/user_mypage_info.dart';
import 'package:pingo_front/data/repository/user_repository/user_repository.dart';
import 'package:image_picker/image_picker.dart';

class UserViewModel extends Notifier<UserMypageInfo> {
  final UserRepository _repository;

  UserViewModel(this._repository);

  @override
  UserMypageInfo build() {
    return UserMypageInfo();
  }

  Future<void> fetchMyPageInfo(String userNo) async {
    try {
      final userInfo = await _repository.fetchMyPageInfo(userNo);
      state = userInfo;
    } catch (e) {
      logger.e('Failed to fetch user info: $e');
    }
  }

  // 대표 이미지 변경 기능 추가
  Future<void> setMainImage(String currentMainImageNo, String newMainImageNo,
      BuildContext context) async {
    try {
      bool success = await _repository.updateMainProfileImage(
          currentMainImageNo, newMainImageNo);

      if (success) {
        // 상태 업데이트
        state = UserMypageInfo(
          users: state.users,
          userInfo: state.userInfo,
          userImageList: state.userImageList?.map((userImage) {
            if (userImage.imageNo == currentMainImageNo) {
              return userImage.copyWith(imageProfile: 'F'); // 기존 대표 이미지 해제
            } else if (userImage.imageNo == newMainImageNo) {
              return userImage.copyWith(imageProfile: 'T'); // 새 대표 이미지 설정
            }
            return userImage;
          }).toList(),
        );

        // 대표 이미지 변경 성공 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "대표 이미지가 변경되었습니다.",
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        // 대표 이미지 변경 실패 알림
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("대표 이미지 변경에 실패했습니다. 다시 시도해주세요."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
        logger.e("대표 이미지 변경 실패: 서버에서 false 응답");
      }
    } catch (e) {
      // 네트워크 오류 또는 예외 발생 시 알림 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("네트워크 오류가 발생했습니다. 다시 시도해주세요."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      logger.e('대표 이미지 변경 중 오류 발생: $e');
    }
  }

  Future<void> uploadUserImage(BuildContext context, File imageFile) async {
    final String? userNo = state.userInfo?.userNo;

    bool result = await _repository.uploadUserImage(userNo!, imageFile);

    if (result) {
      fetchMyPageInfo(userNo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지가 추가되었습니다.'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미지 추가에 실패했습니다.'), backgroundColor: Colors.red),
      );
    }
  }
}

final userViewModelProvider = NotifierProvider<UserViewModel, UserMypageInfo>(
  () => UserViewModel(UserRepository()),
);

/**
 * Class의 정의? -> 붕어빵틀 -> 객체를 찍어내는 틀, 설계도
 * 객체란? -> 현실 세계에 존재하는 사물이나 개념을 프로그래밍을 위해 나타낸 것?
 * ex) 사람 객체 -> 이름이 있고, 나이도 있고, 밥도 먹고, 똥도 싸고...
 * Class의 구성요소는?
 * - 필드 (속성)
 * - 메서드 (행위)
 *
 * Class Person {
 *    String name;
 *    int age;
 *
 *    void eat() {
 *       print('밥 먹음');
 *    }
 *
 *    void work() {
 *       print('일함');
 *    }
 *
 *    void setAge(int newAge) {
 *       this.age = newAge;
 *    }
 * }
 *
 * Person person1 = new Person('홍길동', 34);
 * Person person2 = new Person('장보고', 44);
 * person1.eat();
 * person2.work();
 *
 * person2.setAge(54);
 *
 *
 */
