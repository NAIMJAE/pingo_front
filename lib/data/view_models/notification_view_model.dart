import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/match_model.dart';

// MatchModel Model로 변경!
class NotificationViewModel extends Notifier<MatchModel?> {
  @override
  MatchModel build() {
    return MatchModel();
  }

  // 매치한 사람들 상태 넣기
  void matchNotification(MatchModel matchModel) {
    state = matchModel;
  }

  // 상태 null로 넣기
  void emptyNotification() {
    state = null;
  }
}

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, MatchModel?>(
  () {
    return NotificationViewModel();
  },
);
