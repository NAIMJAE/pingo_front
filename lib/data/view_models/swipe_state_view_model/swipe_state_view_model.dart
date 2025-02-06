import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/repository/swipe_state_repository/swipe_state_repository.dart';
import 'package:pingo_front/data/models/swipe_state_model/user_swipe_details.dart';

class SwipeStateViewModel
    extends Notifier<Map<String, List<UserSwipeDetails>>> {
  final SwipeStateRepository _repository;
  SwipeStateViewModel(this._repository);

  @override
  Map<String, List<UserSwipeDetails>> build() {
    return {};
  }

  Future<void> fetchSwipeState() async {
    try {
      final userSwipeDetailMap = await _repository.fetchSwipeState();
      state = userSwipeDetailMap;
    } catch (e) {
      state = {};
      logger.e('Failed to fetch keywords: $e');
    }
  }
}

final SwipeStateProvider =
    NotifierProvider<SwipeStateViewModel, Map<String, List<UserSwipeDetails>>>(
  () => SwipeStateViewModel(SwipeStateRepository()),
);
