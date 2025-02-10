import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/data/network/custom_dio.dart';
import 'package:pingo_front/data/network/response_dto.dart';
import 'package:pingo_front/data/repository/root_url.dart';

class MainRepository {
  final CustomDio _customDio = CustomDio.instance;

  // 메인 렌더링 - 주변 유저 불러오기
  Future<List<Profile>> fetchNearbyUsers(String userNo, int distanceKm) async {
    logger.i("🔍 주변 유저 조회 요청: userNo=$userNo, distanceKm=$distanceKm");

    final response = await _customDio.get(
      '/user/nearby',
      query: {'userNo': userNo, 'distanceKm': distanceKm},
    );
    logger.e('아아앙: ${response}');
    List<dynamic> usersData = response;

    List<Profile> users = usersData
        .map((user) => Profile(
              userNo: user['userNo'],
              name: user['userName'],
              age: user['age'],
              status: user['status'],
              distance: user['distance'],
              ImageList: List<String>.from(user['imageList'] ?? [])
                  .map((img) => "${rootURL}/uploads$img")
                  .toList(),
            ))
        .toList();

    logger.e("✅ 주변 유저 불러오기 성공: ${users.length}명");
    return users;
  }

  // 스와이프 등록 요청
  Future<bool> insertSwipe(Map<String, dynamic> reqData) async {
    logger.e(reqData);
    final response = await _customDio.post(
      '/insertSwipe',
      data: reqData,
    );

    bool result = ResponseDTO.validation(response);

    return result;
  }
}
