import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/keyword_model/keyword_group.dart';
import 'package:pingo_front/data/models/keyword_model/keyword_repository.dart';

class KeywordViewModel extends Notifier<Map<String, KeywordGroup>> {
  final KeywordRepository _repository;
  KeywordViewModel(this._repository);

  @override
  Map<String, KeywordGroup> build() {
    return {};
  }

  // repository를 실행시키는 메서드
  // 실행 결과로 반환받은 데이터를 state에 저장
  Future<void> fetchKeywords() async {
    try {
      final keywordMap = await _repository.fetchKeyword();
      state = keywordMap;
    } catch (e) {
      state = {};
      logger.e('Failed to fetch keywords: $e');
    }
  }
}

final KeywordViewModelProvider =
    NotifierProvider<KeywordViewModel, Map<String, KeywordGroup>>(
  () => KeywordViewModel(KeywordRepository()),
);
