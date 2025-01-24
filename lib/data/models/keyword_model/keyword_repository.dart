import 'package:dio/dio.dart';

import '../../../_core/utils/logger.dart';
import 'keyword_group.dart';

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
