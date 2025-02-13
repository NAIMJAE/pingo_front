import 'package:dio/dio.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/community_model/place_review.dart';
import 'package:pingo_front/data/network/custom_dio.dart';

class PlaceReviewSearchRepository {
  final Dio _dio = Dio();
  final CustomDio _customDio = CustomDio.instance;
  final String _baseUrl = "https://dapi.kakao.com/v2/local/search/keyword.json";
  final String _apiKey = "KakaoAK 1e94dca04a49847a5688820f39327f7e";

  // 서버에서 장소 리뷰 조회
  Future<List<PlaceReview>> fetchSearchPlaceReview(
      {required String? cateSort,
      required String? searchSort,
      String? keyword}) async {
    List<dynamic> response = await _customDio.get('/community/place', query: {
      'cateSort': cateSort,
      'searchSort': searchSort,
      'keyword': keyword
    });

    return response.map((json) => PlaceReview.fromJson(json)).toList();
  }

  // 카카오 API 검색
  Future<Map<String, dynamic>> fetchSearchKaKaoLocation(String keyword,
      {int page = 1, int size = 10}) async {
    try {
      Response response = await _dio.get(
        _baseUrl,
        queryParameters: {"query": keyword, "page": page, "size": size},
        options: Options(
          headers: {
            "Authorization": _apiKey, // 카카오 API 인증 헤더 추가
          },
        ),
      );

      logger.i(response);

      if (response.statusCode == 200) {
        return response.data; // JSON 데이터를 그대로 반환
      } else {
        throw Exception("카카오 API 요청 실패: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("카카오 API 요청 실패: ${e.toString()}");
    }
  }
}
