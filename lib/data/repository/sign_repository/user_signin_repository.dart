import 'package:dio/dio.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/network/response_dto.dart';
import 'package:pingo_front/data/repository/root_url.dart';

class UserSigninRepository {
  final Dio _dio = Dio();

  Future<dynamic> fetchSendSignInData(loginData) async {
    try {
      Response response =
          await _dio.post('$rootURL/permit/signin', data: loginData);

      // 토큰 추출 (일단 body에서 추출 나중에 헤더로 변경)

      dynamic userData = ResponseDTO.validation(response.data);

      logger.d(userData);

      return userData;
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
