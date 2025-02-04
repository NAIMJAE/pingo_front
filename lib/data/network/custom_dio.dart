import 'package:dio/dio.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/network/response_dto.dart';
import 'package:pingo_front/data/repository/root_url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomDio {
  final Dio dio;

  CustomDio()
      : dio = Dio(
          BaseOptions(
            baseUrl: rootURL,
            connectTimeout: const Duration(seconds: 10), // 연결 시간 초과
            receiveTimeout: const Duration(seconds: 10), // 응답 시간 초과
            headers: {'Accept': 'application/json'},
            contentType: 'application/json;charset=utf-8',
            validateStatus: (status) => true,
          ),
        ) {}

  /// Get 요청 커스텀 메서드 (통신 + 검증 후 데이터 반환)
  /// - path : 요청 주소의 path 부분
  /// - query : get 요청시 전송할 데이터 (Map 형태)
  /// - contentType : 기본값 application/json, 변경 필요시 입력
  Future<dynamic> get(String path,
      {Map<String, dynamic>? query,
      String contentType = 'application/json'}) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: query,
        options: Options(headers: {'Content-Type': contentType}),
      );

      logger.d(response.data);

      dynamic result = ResponseDTO.validation(response.data);
      return result;
    } on DioException catch (e) {
      return _dioException(e);
    } catch (e) {
      logger.e("서버 데이터 처리 오류");
      return null;
    }
  }

  /// Post 요청 커스텀 메서드 (통신 + 검증 후 데이터 반환)
  /// - path : 요청 주소의 path 부분
  /// - data : post 요청시 전송할 데이터 (객체)
  /// - contentType : 기본값 application/json, 변경 필요시 입력
  Future<dynamic> post(String path,
      {dynamic data, String contentType = 'application/json'}) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        options: Options(
          headers: {'Content-Type': contentType},
        ),
      );

      logger.d(response.data);

      dynamic result = ResponseDTO.validation(response.data);
      return result;
    } on DioException catch (e) {
      return _dioException(e);
    } catch (e) {
      logger.e("서버 데이터 처리 오류 (resultCode : 2)");
      return null;
    }
  }

  // case1 - 통신 성공 (서버로 요청을 보내고 응답을 받는건 성공)
  // - 정상적으로 통신 성공 (resultCode = 1)
  // -- responseDTO의 data를 꺼내 반환
  // - 서버에서 검증 중에 실패 (resultCode = 2)
  // -- 전역 예외로 던지니까 data를 반환하면 에러 내용이 들어 있음

  // case2 - 통신 실패
  // - 서버로 요청을 보내지 못함
  // - 서버로부터 응답을 받지 못함

  // dio 통신 공통 예외 처리
  dynamic _dioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        logger.e('연결 시간 초과!');
        break;
      case DioExceptionType.receiveTimeout:
        logger.e('응답 시간 초과!');
        break;
      case DioExceptionType.badResponse:
        logger.e('잘못된 응답 (${e.response?.statusCode}): ${e.response?.data}');
        break;
      case DioExceptionType.cancel:
        logger.e('요청이 취소됨');
        break;
      case DioExceptionType.unknown:
        logger.e('알 수 없는 네트워크 오류 발생: ${e.message}');
        break;
      default:
        logger.e('네트워크 오류 발생: (${e.response?.statusCode}) ${e.message}');
        break;
    }
    return null;
  }
}

// 금고
const secureStorage = FlutterSecureStorage();
