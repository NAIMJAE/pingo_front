import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/keyword_model/keyword.dart';
import 'package:pingo_front/data/models/user_model/user_signup.dart';

import '../response_dto.dart';
import '../root_url.dart';

// 회원가입 Repository
class UserSignupRepository {
  final Dio _dio = Dio();

  // 아이디 중복 검증
  Future<bool> fetchValidateId(String userId) async {
    final response = await _dio.get(
      '$rootURL/validateId',
      queryParameters: {'inputId': userId},
    );
    bool data = ResponseDTO.validation(response.data);
    return data;
  }

  // 3차 키워드 조회
  Future<List<Keyword>> fetch3ndKeyword() async {
    final response = await _dio.get('$rootURL/3ndKeyword');
    dynamic data = ResponseDTO.validation(response.data);
    List<Keyword> result =
        (data as List).map((item) => Keyword.fromJson(item)).toList();
    return result;
  }

  // 회원가입 데이터 전송
  Future<dynamic> fetchSignup(UserSignup signupData, File profileImage) async {
    // 일단 테스트 버튼을 없애면 null 값이 있을 경우 이 함수가 호출이 되지는 않지만
    // 그래도 이 함수에서 전송할 UserSignup 객체에 null이 있는지 확인하는 작업 추가 필요함
    // 이미지 이름도 profile.jpg가 아니라 임의의 사진이름 필요 (백엔드에서 구분 가능하기만 하면 됨)

    FormData formData = FormData.fromMap({
      "userSignUp": jsonEncode(signupData.toJson()),
      "image": await MultipartFile.fromFile(
        profileImage.path,
        filename: "profile.jpg",
      )
    });

    logger.d(formData);

    final response = await _dio.post(
      '$rootURL/signup',
      data: formData,
      options: Options(headers: {"Content-Type": "multipart/form-data"}),
    );

    // 서버 로직 완료 후 성공 실패 처리 남음
  }
}
