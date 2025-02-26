import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/membership_model/membership.dart';
import 'package:pingo_front/data/network/custom_dio.dart';

class MembershipRepository {
  final CustomDio _customDio = CustomDio.instance;

  Future<List<Membership>> fetchSelectMemberShip() async {
    final response = await _customDio.get('/membership');

    List<Membership> memberships =
        (response as List).map((item) => Membership.fromJson(item)).toList();

    return memberships;
  }
}
