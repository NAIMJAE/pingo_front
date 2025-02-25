import 'dart:io';
import 'package:dio/dio.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/user_model/user_image.dart';
import 'package:pingo_front/data/network/custom_dio.dart';
import 'package:pingo_front/data/models/user_model/user_mypage_info.dart';
import 'package:mime/mime.dart';

// 스프링 서버와 통신하는 repository
class UserRepository {
  final CustomDio _customDio = CustomDio.instance;

  // 마이페이지 회원 정보 조회
  Future<UserMypageInfo> fetchMyPageInfo(userNo) async {
    final response = await _customDio.get(
      '/user',
      query: {'userNo': userNo},
    );

    UserMypageInfo userInfo = UserMypageInfo.fromJson(response);

    return userInfo;
  }

  // 개인 정보 수정 완료 후 서버 전송
  Future<void> fetchSubmitUpdateInfo(Map<String, dynamic> updateInfo) async {
    final response = await _customDio.post('/user/info', data: updateInfo);
  }

  // 대표 이미지 변경 API 추가
  Future<bool> updateMainProfileImage(
      String currentMainImageNo, String newMainImageNo) async {
    try {
      final response = await _customDio.dio.put(
        '/user/image',
        data: {
          "currentMainImageNo": currentMainImageNo,
          "newMainImageNo": newMainImageNo,
        },
      );

      return response.data['data'] == true;
    } catch (e) {
      logger.e("대표 이미지 변경 실패: $e");
      return false;
    }
  }

  // 유저 이미지 추가
  Future<bool> uploadUserImage(String userNo, File imageFile) async {
    try {
      String mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      FormData formData = FormData.fromMap({
        "userNo": userNo,
        "userImageForAdd": await MultipartFile.fromFile(
          imageFile.path,
          contentType: DioMediaType.parse(mimeType),
        ),
      });

      final response = await _customDio.post(
        "/user/image",
        data: formData,
        contentType: 'multipart/form-data',
      );

      return response == true; // 서버 응답 확인
    } catch (e) {
      logger.e("이미지 업로드 실패: $e");
      return false;
    }
  }

  // 유저 이미지 삭제
  Future<bool> deleteUserImage(String ImageNoForDelete) async {
    try {
      final response = await _customDio.dio.delete(
        '/user/image',
        data: {
          "ImageNoForDelete": ImageNoForDelete,
        },
      );

      return response.data['data'] == true;
    } catch (e) {
      logger.e("이미지 삭제 실패: $e");
      return false;
    }
  }
}
/**
 * 서버에서 객체로 return
 * http 통신할땐 JSON으로 변환
 * Dio가 다시 받을때 JSON을 Map<String, dynamic> 으로 받음
 *
 * response = Map<String, dynamic>;
 */
