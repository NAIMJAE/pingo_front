import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/keyword_model/keyword_group.dart';
import 'package:pingo_front/data/repository/keyword_repository/keyword_repository.dart';

class KeywordViewModel extends Notifier<Map<String, KeywordGroup>> {
  final KeywordRepository _repository;
  KeywordViewModel(this._repository);

  @override
  Map<String, KeywordGroup> build() {
    return {};
  }

  Future<void> fetchKeywords() async {
    try {
      final keywordMap = await _repository.fetchKeyword();
      state = keywordMap;
    } catch (e) {
      state = {};
      logger.e('Failed to fetch keywords: $e');
    }
  }

  Future<void> fetchSelectedKeyword(userNo, kwId) async {
    try {
      await _repository.fetchSelectedKeyword(userNo, kwId);
    } catch (e) {
      logger.e('Failed to fetch Selected keywords: $e');
    }
  }
}

final KeywordViewModelProvider =
    NotifierProvider<KeywordViewModel, Map<String, KeywordGroup>>(
  () => KeywordViewModel(KeywordRepository()),
);
