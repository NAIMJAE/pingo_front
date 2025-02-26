import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/data/repository/ping_check_repository/ping_check_repository.dart';

class PingCheckViewModel extends Notifier<Map<String, Profile>> {
  final PingCheckRepository _repository;
  PingCheckViewModel(this._repository);

  @override
  Map<String, Profile> build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}

final pingCheckViewModelProvider =
    NotifierProvider<PingCheckViewModel, Map<String, Profile>>(
  () => PingCheckViewModel(PingCheckRepository()),
);
