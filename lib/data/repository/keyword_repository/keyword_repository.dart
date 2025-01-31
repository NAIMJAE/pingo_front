import 'package:dio/dio.dart';
import 'package:pingo_front/data/network/response_dto.dart';
import 'package:pingo_front/data/repository/root_url.dart';

import '../../models/keyword_model/keyword_group.dart';

// 스프링 서버와 통신하는 repository
class KeywordRepository {
  final Dio _dio = Dio();

  // localhost:8080/pingo/keyword로 http 통신
  // 통신의 결과를 ResponseDTO.validation로 검증하고 알맞은 데이터 타입으로 매핑
  Future<Map<String, KeywordGroup>> fetchKeyword() async {
    final response = await _dio.get('$rootURL/keyword');
    Map<String, dynamic> data = ResponseDTO.validation(response.data);

    Map<String, KeywordGroup> keywordGroup = {};

    for (var key in data.keys) {
      keywordGroup.addAll({key: KeywordGroup.fromJson(data[key])});
    }
    return keywordGroup;
  }
}
