// import 'package:dio/dio.dart';
// import 'package:pingo_front/data/network/response_dto.dart';
// import 'package:pingo_front/data/repository/root_url.dart';
//
// class CustomDio {
//   final Dio dio;
//
//   CustomDio()
//       : dio = Dio(BaseOptions(
//           baseUrl: rootURL,
//           connectTimeout: const Duration(seconds: 10), // 연결 시간 초과
//           receiveTimeout: const Duration(seconds: 10), // 응답 시간 초과
//           headers: {
//             'Accept': 'application/json',
//           },
//         )) {}
//
//   /// Get 요청 커스텀 메서드
//   /// - path : 요청 주소의 path 부분
//   /// - query : get 요청시 전송할 데이터 (Map 형태)
//   /// - contentType : 기본값 application/json, 변경 필요시 입력
//   Future<Response> get(String path,
//       {Map<String, dynamic>? query,
//       String contentType = 'application/json'}) async {
//     try {
//       final response = await dio.get(
//         path,
//         queryParameters: query,
//         options: Options(headers: {'Content-Type': contentType}),
//       );
//
//       // 통신 성공 (서버로 요청을 보내고 응답을 받는건 성공)
//       // - 정상적으로 통신 성공 (resultCode = 1)
//       // -- responseDTO의 data를 꺼내 반환
//       // - 서버에서 검증 중에 실패 (resultCode = 2)
//       // -- 전역 예외로 던지니까 data를 반환하면 에러 내용이 들어 있음
//
//       // 통신 실패
//       // - 서버로 요청을 보내지 못함
//       // - 서버로부터 응답을 받지 못함
//
//       dynamic data = ResponseDTO.validation(response.data);
//       return data;
//     } on DioException catch (e) {
//       if (e.response?.statusCode == 404) {
//         print('404 에러: 해당 리소스를 찾을 수 없음');
//       } else if (e.type == DioExceptionType.connectionTimeout) {
//         print('연결 시간 초과! (connectTimeout)');
//       } else if (e.type == DioExceptionType.receiveTimeout) {
//         print('응답 시간 초과! (receiveTimeout)');
//       } else {
//         print('다른 네트워크 오류 발생: ${e.message}');
//       }
//     } catch (e) {
//       print("서버 데이터 처리 오류");
//     }
//   }
//
//   Future<Response> post(String path,
//       {dynamic data, String contentType = 'application/json'}) async {
//     return await dio.post(path,
//         data: data, options: Options(headers: {'Content-Type': contentType}));
//   }
// }
