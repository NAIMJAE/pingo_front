import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:dio/dio.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/network/custom_dio.dart';

class DatingGuideRepository {
  final CustomDio _customDio = CustomDio.instance;

  // 게시글 최초 조회
  Future<void> fetchSelectDatingGuideForInit() async {
    await _customDio.get('/community/guide/init');
  }

  // 게시글 작성
  Future<void> fetchInsertDatingGuide(
      Map<String, dynamic> data, File guideImage) async {
    String? mimeType = lookupMimeType(guideImage.path) ?? 'image/jpeg';

    FormData formData = FormData.fromMap({
      "DatingGuide": MultipartFile.fromString(
        jsonEncode(data),
        contentType: DioMediaType("application", "json"),
      ),
      "guideImage": await MultipartFile.fromFile(
        guideImage.path,
        filename: "guideImage.jpg",
        contentType: DioMediaType.parse(mimeType),
      )
    });

    final response = await _customDio.post(
      '/community/guide',
      data: formData,
      contentType: 'multipart/form-data',
    );

    logger.i(response);
  }
}
