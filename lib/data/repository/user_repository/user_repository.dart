import 'package:pingo_front/data/network/custom_dio.dart';
import 'package:pingo_front/data/models/user_model/user_mypage_info.dart';
import '../../models/user_model/user_mypage_info.dart';

// 스프링 서버와 통신하는 repository
class UserRepository {
  final CustomDio _customDio = CustomDio.instance;
}
