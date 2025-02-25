import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/membership_model/membership.dart';
import 'package:pingo_front/data/network/custom_dio.dart';

class MembershipRepository {
  final CustomDio _customDio = CustomDio.instance;

  Future<List<Membership>> fetchSelectMemberShip() async {
    final response = await _customDio.get('/membership_model');

    logger.i(response);

    // ★ 여기 변환 문제
    List<Membership> result =
        response.map((json) => Membership.fromJson(json)).toList();

    return result;
  }
}
