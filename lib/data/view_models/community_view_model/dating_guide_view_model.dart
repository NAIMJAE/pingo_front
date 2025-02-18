import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/community_model/dating_guide_search.dart';
import 'package:pingo_front/data/repository/community_repository/dating_guide_repository.dart';

class DatingGuideViewModel extends Notifier<Map<String, DatingGuideSearch>> {
  final DatingGuideRepository _repository;
  DatingGuideViewModel(this._repository);

  @override
  Map<String, DatingGuideSearch> build() {
    selectDatingGuideForInit();
    return {};
  }

  // init - 모든 게시글 인기순으로 조회
  Future<void> selectDatingGuideForInit() async {
    Map<String, DatingGuideSearch> response =
        await _repository.fetchSelectDatingGuideForInit();
    state = response;
  }

  // sort - 각 게시글 카테고리별로 정렬 변경시 조회
  Future<void> changeSearchSort(String newSort, String category) async {
    await _repository.fetchSelectDatingGuideWithSort(newSort, category);
  }

  // 게시글 작성
  Future<void> insertDatingGuide(
      Map<String, dynamic> data, File guideImage) async {
    await _repository.fetchInsertDatingGuide(data, guideImage);
  }
}

final datingGuideViewModelProvider =
    NotifierProvider<DatingGuideViewModel, Map<String, DatingGuideSearch>>(
  () => DatingGuideViewModel(DatingGuideRepository()),
);
