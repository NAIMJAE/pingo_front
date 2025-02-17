import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/community_model/dating_guide_search.dart';
import 'package:pingo_front/data/repository/community_repository/dating_guide_repository.dart';

class DatingGuideViewModel extends Notifier<Map<String, DatingGuideSearch>> {
  final DatingGuideRepository _repository;
  DatingGuideViewModel(this._repository);

  @override
  Map<String, DatingGuideSearch> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  // init - 모든 게시글 인기순으로 조회
  Future<void> selectDatingGuideForInit() async {
    await _repository.fetchSelectDatingGuideForInit();
    // 아직 아무곳에서도 호출 안하는 중임
    // postman으로 api는 확인함
  }

  // sort - 각 게시글 카테고리별로 정렬 변경시 조회

  // 게시글 작성
  Future<void> insertDatingGuide(
      Map<String, dynamic> data, File guideImage) async {
    await _repository.fetchInsertDatingGuide(data, guideImage);
  }
}
