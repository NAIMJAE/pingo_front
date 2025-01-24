import 'package:dio/dio.dart';
import 'package:pingo_front/commons/utils/logger.dart';
import 'package:pingo_front/models/keyword_model/keyword_group.dart';
import 'package:pingo_front/models/response_dto.dart';

class KeywordRepository {
  final Dio _dio = Dio();
  final String _url = 'http://localhost:8080/pingo';

  void fetchKeyword() async {
    final response = await _dio.get('$_url/keyword');

    if (response.statusCode == 200) {
      final result = response.data;

      if (result['resultCode'] == '1') {
        Map<String, KeywordGroup> keywordGroup = {};
        Map<String, dynamic> data = result['data'];

        logger.d(data);

        for (var key in data.keys) {
          keywordGroup.addAll({key: KeywordGroup.fromJson(data[key])});
        }
        logger.d(keywordGroup);
      }
    }
  }
}
