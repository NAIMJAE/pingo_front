import 'package:dio/dio.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/network/custom_dio.dart';
import 'package:pingo_front/data/network/response_dto.dart';

class MainRepository {
  final CustomDio _customDio = CustomDio.instance;

  // 스와이프 등록 요청
  Future<bool> insertSwipe(Map<String, dynamic> reqData) async {
    print('들어옴?');
    logger.e(reqData);
    final response = await _customDio.post(
      '/insertSwipe',
      data: reqData,
    );

    bool result = ResponseDTO.validation(response);

    return result;
  }
}
