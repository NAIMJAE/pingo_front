import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 유저별 설정 프로바이더 (userNo 기반 관리)
final settingsProvider =
    StateNotifierProvider.family<SettingsNotifier, AppSettings, String>(
  (ref, userId) => SettingsNotifier(userId),
);

class AppSettings {
  final int maxDistance;
  final String preferredGender;
  final RangeValues ageRange;
  final bool autoAdjustDistance;
  final bool autoAdjustAge;
  final bool profileComplete;

  AppSettings({
    required this.maxDistance,
    required this.preferredGender,
    required this.ageRange,
    required this.autoAdjustDistance,
    required this.autoAdjustAge,
    required this.profileComplete,
  });

  // JSON 변환 (SharedPreferences 저장용)
  Map<String, dynamic> toJson() => {
        "maxDistance": maxDistance,
        "preferredGender": preferredGender,
        "ageRange": "${ageRange.start.toInt()},${ageRange.end.toInt()}",
        "autoAdjustDistance": autoAdjustDistance,
        "autoAdjustAge": autoAdjustAge,
        "profileComplete": profileComplete,
      };

  // JSON → 객체 변환
  static AppSettings fromJson(Map<String, dynamic> json) {
    final ageParts = json["ageRange"].split(",");
    return AppSettings(
      maxDistance: json["maxDistance"] ?? 50,
      preferredGender: json["preferredGender"] ?? "all",
      ageRange:
          RangeValues(double.parse(ageParts[0]), double.parse(ageParts[1])),
      autoAdjustDistance: json["autoAdjustDistance"] ?? true,
      autoAdjustAge: json["autoAdjustAge"] ?? false,
      profileComplete: json["profileComplete"] ?? false,
    );
  }

  // 일부 설정값 변경 (copyWith)
  AppSettings copyWith({
    int? maxDistance,
    String? preferredGender,
    RangeValues? ageRange,
    bool? autoAdjustDistance,
    bool? autoAdjustAge,
    bool? profileComplete,
  }) {
    return AppSettings(
      maxDistance: maxDistance ?? this.maxDistance,
      preferredGender: preferredGender ?? this.preferredGender,
      ageRange: ageRange ?? this.ageRange,
      autoAdjustDistance: autoAdjustDistance ?? this.autoAdjustDistance,
      autoAdjustAge: autoAdjustAge ?? this.autoAdjustAge,
      profileComplete: profileComplete ?? this.profileComplete,
    );
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  final String userId; // 유저별 설정 저장을 위한 ID

  SettingsNotifier(this.userId)
      : super(AppSettings(
          maxDistance: 50,
          preferredGender: "all",
          ageRange: RangeValues(18, 32),
          autoAdjustDistance: true,
          autoAdjustAge: false,
          profileComplete: false,
        )) {
    _loadSettings();
  }

  // 유저별 키 생성
  String _getUserKey() => "${userId}_app_settings";

  // SharedPreferences에서 설정 불러오기
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_getUserKey());

    if (jsonString != null) {
      state = AppSettings.fromJson(json.decode(jsonString));
    }
  }

  // 설정 변경 및 SharedPreferences 저장
  Future<void> updateSettings(AppSettings newSettings) async {
    state = newSettings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_getUserKey(), json.encode(newSettings.toJson()));
  }
}
