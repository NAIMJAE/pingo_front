import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pingo_front/_core/utils/logger.dart';

// 앱 설정 데이터 모델
class AppSettings {
  final int maxDistance;
  final String preferredGender;
  final List<int> ageRange;
  final int minProfileImages;

  AppSettings({
    required this.maxDistance,
    required this.preferredGender,
    required this.ageRange,
    required this.minProfileImages,
  });

  // ✅ 기존 상태를 새로운 값으로 변경하는 copyWith 메서드 추가 (불변성 유지)
  AppSettings copyWith({
    int? maxDistance,
    String? preferredGender,
    List<int>? ageRange,
    int? minProfileImages,
  }) {
    return AppSettings(
      maxDistance: maxDistance ?? this.maxDistance,
      preferredGender: preferredGender ?? this.preferredGender,
      ageRange: ageRange ?? this.ageRange,
      minProfileImages: minProfileImages ?? this.minProfileImages,
    );
  }
}

// ✅ SharedPreferences를 활용한 상태 관리 Notifier
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier()
      : super(AppSettings(
          maxDistance: 50,
          preferredGender: "all",
          ageRange: [20, 40],
          minProfileImages: 3,
        )) {
    _loadSettings(); // 초기값 로드
  }

  // ✅ SharedPreferences에서 설정값 불러오기
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final maxDistance = prefs.getInt("max_distance") ?? 50;
    final preferredGender = prefs.getString("preferred_gender") ?? "all";
    final ageString = prefs.getString("age_range") ?? "20,40";
    final ageParts = ageString.split(",");
    final ageRange = [int.parse(ageParts[0]), int.parse(ageParts[1])];
    final minProfileImages = prefs.getInt("min_profile_images") ?? 3;

    state = AppSettings(
      maxDistance: maxDistance,
      preferredGender: preferredGender,
      ageRange: ageRange,
      minProfileImages: minProfileImages,
    );

    logger.i("✅ 앱 설정 로드 완료: $state");
  }

  // ✅ 설정값 변경 및 SharedPreferences 저장
  Future<void> updateSettings({
    int? maxDistance,
    String? preferredGender,
    List<int>? ageRange,
    int? minProfileImages,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (maxDistance != null) await prefs.setInt("max_distance", maxDistance);
    if (preferredGender != null)
      await prefs.setString("preferred_gender", preferredGender);
    if (ageRange != null) {
      await prefs.setString("age_range", "${ageRange[0]},${ageRange[1]}");
    }
    if (minProfileImages != null)
      await prefs.setInt("min_profile_images", minProfileImages);

    // ✅ 상태 업데이트
    state = state.copyWith(
      maxDistance: maxDistance,
      preferredGender: preferredGender,
      ageRange: ageRange,
      minProfileImages: minProfileImages,
    );

    logger.i("✅ 설정 변경됨: $state");
  }
}

// ✅ Provider 등록
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});
