import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _keyMaxDistance = "max_distance";
  static const String _keyPreferredGender = "preferred_gender";
  static const String _keyAgeRange = "age_range";
  static const String _keyMinProfileImages = "min_profile_images";

  // 최대 거리 저장
  static Future<void> saveMaxDistance(int distance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMaxDistance, distance);
  }

  // 최대 거리 불러오기 (기본값: 50km)
  static Future<int> getMaxDistance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMaxDistance) ?? 50;
  }

  // 보고 싶은 성별 저장
  static Future<void> savePreferredGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPreferredGender, gender);
  }

  // 보고 싶은 성별 불러오기 (기본값: "all")
  static Future<String> getPreferredGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPreferredGender) ?? "all";
  }

  // 상대의 연령대 저장
  static Future<void> saveAgeRange(List<int> ageRange) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAgeRange, "${ageRange[0]},${ageRange[1]}");
  }

  // 상대의 연령대 불러오기 (기본값: 20~40)
  static Future<List<int>> getAgeRange() async {
    final prefs = await SharedPreferences.getInstance();
    final ageString = prefs.getString(_keyAgeRange) ?? "20,40";
    final ageParts = ageString.split(",");
    return [int.parse(ageParts[0]), int.parse(ageParts[1])];
  }

  // 프로필 사진 최소 개수 저장
  static Future<void> saveMinProfileImages(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyMinProfileImages, count);
  }

  // 프로필 사진 최소 개수 불러오기 (기본값: 3)
  static Future<int> getMinProfileImages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMinProfileImages) ?? 3;
  }
}
