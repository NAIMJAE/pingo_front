import 'package:flutter/material.dart';

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
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionTitle("상대와의 최대 거리"),
          _buildSlider(
            value: maxDistance,
            min: 1,
            max: 50,
            onChanged: (value) => setState(() => maxDistance = value),
            label: "${maxDistance.toInt()}km",
          ),
          _buildSwitch("스와이프할 프로필이 없을 때 거리 조정", autoAdjustDistance,
              (value) => setState(() => autoAdjustDistance = value)),
          SizedBox(height: 16),
          _buildSectionTitle("보고 싶은 성별"),
          _buildOptionTile("남성, 여성, Beyond Binary"),
          SizedBox(height: 16),
          _buildSectionTitle("상대의 연령대"),
          RangeSlider(
            values: ageRange,
            min: 18,
            max: 60,
            divisions: 42,
            labels: RangeLabels(
                "${ageRange.start.toInt()}", "${ageRange.end.toInt()}"),
            onChanged: (values) => setState(() => ageRange = values),
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
