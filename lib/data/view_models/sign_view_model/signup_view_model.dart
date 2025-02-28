import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/keyword_model/keyword.dart';
import 'package:pingo_front/data/models/sign_model/user_signup.dart';
import 'package:pingo_front/data/repository/sign_repository/user_signup_repository.dart';

// 회원가입을 위해 사용하는 view-model
// 메서드로 있는 각각의 validation은 값을 검증하고 state에 값을 채움
// 마지막에 state와 profile 이미지를 repository에서 multipart로 서버로 보냄
class SignupViewModel extends Notifier<UserSignup> {
  final UserSignupRepository _repository;
  SignupViewModel(this._repository);

  // 프로필 사진 저장용
  File? profileImage;

  @override
  UserSignup build() {
    // 이 view-model 생성시 빈 UserSignup 객체 생성해서
    // 회원가입 step 진행할 때마다 값 채움
    return UserSignup();
  }

  // 이메일 인증
  Future<bool> verifyEmail(String userEmail) async {
    bool isSuccess = await _repository.fetchVerifyEmail(userEmail);
    return isSuccess;
  }

  // 회원 정보 검증
  Future<int> validationIdPwStep(
      String userId, String userPw1, String userPw2, String userEmail) async {
    final RegExp idRegex = RegExp(r'^[a-zA-Z0-9]{6,12}$');
    if (idRegex.hasMatch(userId)) {
      try {
        bool result = await _repository.fetchValidateId(userId);
        if (result) {
        } else {
          return 3;
        }
      } catch (e) {
        logger.e('Failed to fetch validationIdPwStep: $e');
      }
    } else {
      return 2;
    }

    final RegExp passwordRegex = RegExp(
        r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*])[a-zA-Z\d!@#$%^&*]{8,14}$');
    if (passwordRegex.hasMatch(userPw1)) {
      if (userPw1 == userPw2) {
        state.users.userId = userId;
        state.users.userPw = userPw1;
        return 1;
      } else {
        return 5;
      }
    } else {
      return 4;
    }

    // 이메일 제약 걸어야 하고
  }

  // user 기본 정보 검증
  int validationBasicInfo(
      userName, userBirth, userGender, userNick, userAddress) {
    final RegExp nameRegex = RegExp(r'^[가-힣]{2,10}$');
    if (!nameRegex.hasMatch(userName)) {
      return 1;
    }

    try {
      print(userBirth);
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      DateTime birthDate = dateFormat.parseStrict(userBirth);
      print(birthDate);

      if (birthDate.isAfter(DateTime.now())) {
        return 2;
      }
      state.userInfo.userBirth = birthDate;
    } catch (e) {
      return 3;
    }

    final RegExp nickRegex = RegExp(r'^[a-zA-Z가-힣]{2,10}$');
    if (!nickRegex.hasMatch(userNick)) {
      return 4;
    }
    if (userGender == '남성') {
      userGender = 'M';
    } else {
      userGender = 'F';
    }

    state.users.userName = userName;
    state.users.userGender = userGender;
    state.users.userNick = userNick;
    state.userInfo.userAddress = userAddress;
    return 5;
  }

  // user profile 검증
  int validationProfile(File profileImage) {
    this.profileImage = profileImage;
    return 1;
  }

  // user detail 정보 검증
  int validationDetailInfo(userJob1, userJob2, userReligion, userDrinking,
      userSmoking, userBloodType) {
    String? mappingDrinking;
    switch (userDrinking) {
      case '안 마심':
        mappingDrinking = 'N';
        break;
      case '가끔':
        mappingDrinking = 'O';
        break;
      case '자주':
        mappingDrinking = 'F';
        break;
    }

    String? mappingSmoking;
    switch (userSmoking) {
      case '비흡연':
        mappingSmoking = 'F';
        break;
      case '흡연':
        mappingSmoking = 'T';
        break;
    }

    String? mappingBloodType;
    switch (userBloodType) {
      case 'A형':
        mappingBloodType = 'A';
        break;
      case 'B형':
        mappingBloodType = 'B';
        break;
      case 'AB형':
        mappingBloodType = 'AB';
        break;
      case 'O형':
        mappingBloodType = 'O';
        break;
    }

    state.userInfo.user1stJob = userJob1;
    state.userInfo.user2ndJob = userJob2;
    state.userInfo.userReligion = userReligion;
    state.userInfo.userDrinking = mappingDrinking;
    state.userInfo.userSmoking = mappingSmoking;
    state.userInfo.userBloodType = mappingBloodType;
    return 1;
  }

  // 3차 키워드 조회
  Future<List<Keyword>> fetch3ndKeyword() async {
    try {
      List<Keyword> result = await _repository.fetch3ndKeyword();
      return result;
    } catch (e) {
      logger.e('Failed to fetch fetch3ndKeyword: $e');
    }
    return [];
  }

  // 나의 키워드 검증
  int validationMyKeywordInfo(List<String> selectedKeywordIds) {
    String result = selectedKeywordIds.join("_");

    state.userMyKeyword = result;
    return 1;
  }

  // 이상형 키워드 검증
  Future<int> validationFavoriteKeywordInfo(
      List<String> selectedKeywordIds) async {
    String result = selectedKeywordIds.join("_");

    state.userFavoriteKeyword = result;
    return 1;
  }

  // 회원 가입 정보 서버로 보내기
  Future<bool> signupInfoToServer() async {
    try {
      bool result = await _repository.fetchSignup(state, profileImage!);
      return result;
    } catch (e) {
      logger.e('Failed to fetch signupInfoToServer: $e');
      return false;
    }
  }
}

final signupViewModelProvider = NotifierProvider<SignupViewModel, UserSignup>(
  () => SignupViewModel(UserSignupRepository()),
);
