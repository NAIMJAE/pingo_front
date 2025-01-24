import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/keyword_model/keyword_group.dart';
import 'package:pingo_front/data/models/keyword_model/keyword_repository.dart';

class KeywordViewModel extends Notifier<Map<String, KeywordGroup>> {
  final KeywordRepository _repository;
  KeywordViewModel(this._repository);

  @override
  Map<String, KeywordGroup> build() {
    logger.d('build');
    return {};
  }

  Future<void> fetchKeywords() async {
    try {
      final keywordMap = await _repository.fetchKeyword();
      // Map의 값만 리스트로 변환하여 상태 업데이트
      state = keywordMap;
      logger.d(state);
    } catch (e) {
      // 에러 발생 시 로그 추가 및 상태 초기화
      state = {};
      logger.e('Failed to fetch keywords: $e');
    }
  }
}

final KeywordViewModelProvider =
    NotifierProvider<KeywordViewModel, Map<String, KeywordGroup>>(
  () => KeywordViewModel(KeywordRepository()),
);
