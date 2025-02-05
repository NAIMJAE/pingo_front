import 'package:dio/dio.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/network/custom_dio.dart';
import 'package:pingo_front/data/network/response_dto.dart';
import 'package:pingo_front/data/repository/root_url.dart';
import 'package:pingo_front/data/models/swipe_state_model/user_swipe_details.dart';

class SwipeStateRepository {
  final CustomDio _dio = CustomDio.instance;

  Future<Map<String, List<UserSwipeDetails>>> fetchSwipeState() async {
    final response = await _dio.get('/swipeState');

    // 한번에 Map<String, List<UserSwipeDetails>>로 캐스팅 불가능
    final data = response as Map<String, dynamic>;

    logger.d('data : ${data}');

    // Map<String, List<UserSwipeDetails>>로 변환
    final userSwipeDetailMap = data.map((key, value) {
      final list = value as List<dynamic>;
      // MapEntry : Map 객체를 생성 수정 변환시 사용
      return MapEntry(
        key,
        list
            .map((e) => UserSwipeDetails.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    });

    return userSwipeDetailMap;
  }
}
