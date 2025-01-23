import 'package:dio/dio.dart';
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
        Map<String, KeywordGroup> aa;
        Map<String, dynamic> bb = result['data'];

        // for문에서 bb를 돌려서
        // KeywordGroup의 formjson을 호출
        // KeywordGroup의 childKeyword에서 keyword의 fromjson 호출
        // 마지막에 map에 put
      }
    }
  }
}
