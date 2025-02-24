import 'package:flutter/material.dart';
import 'package:pingo_front/_core/utils/SharedPreference.dart';
import 'package:pingo_front/_core/utils/logger.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  double maxDistance = 2.0;
  RangeValues ageRange = RangeValues(18, 32);
  bool autoAdjustDistance = true;
  bool autoAdjustAge = false;
  bool profileComplete = false;
  bool isLoading = true; // ✅ 로딩 상태 추가
  String preferredGender = "모두";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // ✅ SharedPreferences에서 기존 설정 불러오기
  Future<void> _loadPreferences() async {
    maxDistance = (await SharedPrefsHelper.getMaxDistance()).toDouble();
    preferredGender = await SharedPrefsHelper.getPreferredGender();
    List<int> ageList = await SharedPrefsHelper.getAgeRange();
    ageRange = RangeValues(ageList[0].toDouble(), ageList[1].toDouble());

    setState(() {
      isLoading = false; // ✅ 로딩 완료
    });

    // ✅ 설정된 값 로깅
    logger.i("🔍 설정 불러오기 완료");
    logger.i("➡️ 최대 거리: $maxDistance km");
    logger.i("➡️ 보고 싶은 성별: $preferredGender");
    logger.i("➡️ 연령대: ${ageRange.start.toInt()} - ${ageRange.end.toInt()} 세");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("소셜 디스커버리 범위 설정"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child:
                Text("완료", style: TextStyle(color: Colors.blue, fontSize: 16)),
          )
        ],
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // ✅ 로딩 화면 추가
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildSectionTitle("상대와의 최대 거리"),
                _buildSlider(
                  value: maxDistance,
                  min: 1,
                  max: 50,
                  onChanged: (value) => setState(() {
                    maxDistance = value;
                    SharedPrefsHelper.saveMaxDistance(value.toInt()); // ✅ 저장
                  }),
                  label: "${maxDistance.toInt()}km",
                ),
                _buildSwitch("스와이프할 프로필이 없을 때 거리 조정", autoAdjustDistance,
                    (value) => setState(() => autoAdjustDistance = value)),
                SizedBox(height: 16),
                _buildSectionTitle("보고 싶은 성별"),
                _buildGenderSelection(),
                SizedBox(height: 16),
                _buildSectionTitle("상대의 연령대"),
                RangeSlider(
                  values: ageRange,
                  min: 18,
                  max: 60,
                  divisions: 42,
                  labels: RangeLabels(
                      "${ageRange.start.toInt()}세", "${ageRange.end.toInt()}세"),
                  onChanged: (values) {
                    setState(() {
                      ageRange = values;
                      SharedPrefsHelper.saveAgeRange([
                        ageRange.start.toInt(),
                        ageRange.end.toInt()
                      ]); // ✅ 저장
                    });
                  },
                  activeColor: Colors.red,
                ),
                _buildSwitch("스와이프할 프로필이 없을 때 나이 범위 조정", autoAdjustAge,
                    (value) => setState(() => autoAdjustAge = value)),
                SizedBox(height: 16),
                _buildPremiumSection(),
                SizedBox(height: 16),
                _buildSectionTitle("프로필 사진 최소 개수"),
                _buildSlider(
                  value: 1,
                  min: 1,
                  max: 6,
                  onChanged: (value) {},
                  label: "1",
                ),
                SizedBox(height: 16),
                _buildSwitch("자기소개 완료", profileComplete,
                    (value) => setState(() => profileComplete = value)),
                _buildOptionTile("관심사"),
                _buildOptionTile("내가 찾는 관계"),
                _buildOptionTile("언어 추가하기"),
              ],
            ),
    );
  }

  Widget _buildGenderSelection() {
    return DropdownButton<String>(
      value: preferredGender.isNotEmpty ? preferredGender : "all", // 기본값 설정
      dropdownColor: Colors.black,
      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
      onChanged: (String? newValue) {
        setState(() {
          preferredGender = newValue!;
          SharedPrefsHelper.savePreferredGender(preferredGender); // ✅ 저장
        });
      },
      items: <String>["남성", "여성", "Beyond Binary", "all"]
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white));
  }

  Widget _buildSlider(
      {required double value,
      required double min,
      required double max,
      required Function(double) onChanged,
      required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: label,
          onChanged: onChanged,
          activeColor: Colors.red,
        ),
        Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.red,
    );
  }

  Widget _buildOptionTile(String title) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildPremiumSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("Tinder 골드",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "디스커버리 필터를 설정하면 원하는 프로필을 볼 수 있어요.",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
