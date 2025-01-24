import 'package:dio/dio.dart';
import 'package:pingo_front/data/models/response_dto.dart';

import '../../../_core/utils/logger.dart';
import 'keyword_group.dart';

class KeywordRepository {
  final Dio _dio = Dio();
  final String _url = 'http://10.0.2.2:8080/pingo';

  Future<Map<String, KeywordGroup>> fetchKeyword() async {
    logger.d('fetchKeyword 시작');
    final response = await _dio.get('$_url/keyword');

    logger.d('1111');

    Map<String, dynamic> data = ResponseDTO.validation(response.data);

    logger.d('2222');

    Map<String, KeywordGroup> keywordGroup = {};

    logger.d('3333');

    for (var key in data.keys) {
      logger.d('key : ${key}');
      logger.d('key : ${KeywordGroup.fromJson(data[key])}');
      keywordGroup.addAll({key: KeywordGroup.fromJson(data[key])});
    }
    return keywordGroup;
  }
}
