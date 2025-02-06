import 'package:pingo_front/data/network/custom_dio.dart';

import '../../models/keyword_model/keyword_group.dart';

// 스프링 서버와 통신하는 repository
class KeywordRepository {
  final CustomDio _dio = CustomDio.instance;

  // localhost:8080/pingo/keyword로 http 통신
  // 통신의 결과를 ResponseDTO.validation로 검증하고 알맞은 데이터 타입으로 매핑
  Future<Map<String, KeywordGroup>> fetchKeyword() async {
    final response = await _dio.get('/keyword');

    Map<String, KeywordGroup> keywordGroup = {};

    for (var key in response.keys) {
      keywordGroup.addAll({key: KeywordGroup.fromJson(response[key])});
    }
    return keywordGroup;
  }

  Future<void> fetchSelectedKeyword(userNo, kwId) async {
    final response = await _dio.get(
      '/recommend',
      query: {'userNo': userNo, 'sKwId': kwId},
    );
  }
}
