import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/setting_model/AppSettings.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';

class SettingsPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Timer? _debounceTimer;
  late double _tempMaxDistance;

  @override
  void initState() {
    super.initState();

    // 세션 유저 정보 가져오기
    final sessionUser = ref.read(sessionProvider);
    final userId = sessionUser?.userNo ?? "guest";

    // 유저별 설정 불러오기 & UI 값 반영
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider(userId));
      setState(() {
        _tempMaxDistance = settings.maxDistance.toDouble();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionUser = ref.watch(sessionProvider);
    final userId = sessionUser?.userNo ?? "guest";
    final settings = ref.watch(settingsProvider(userId));
    final settingsNotifier = ref.read(settingsProvider(userId).notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("소셜 디스커버리 범위 설정"),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context, settings.maxDistance);
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
          _buildSmoothSlider(settingsNotifier,
              settings), // UI 즉각 반영 + API 최적화 (변할때마다 계속 api 요청 쏘지않도록)
          _buildSwitch("스와이프할 프로필이 없을 때 거리 조정", settings.autoAdjustDistance,
              (value) {
            settingsNotifier.updateSettings(
              settings.copyWith(autoAdjustDistance: value),
            );
          }),
          SizedBox(height: 16),
          _buildSectionTitle("보고 싶은 성별"),
          _buildGenderSelection(settings, settingsNotifier),
          SizedBox(height: 16),
          _buildSectionTitle("상대의 연령대"),
          RangeSlider(
            values: settings.ageRange,
            min: 18,
            max: 60,
            divisions: 42,
            labels: RangeLabels(
              "${settings.ageRange.start.toInt()}세",
              "${settings.ageRange.end.toInt()}세",
            ),
            onChanged: (values) {
              settingsNotifier.updateSettings(
                settings.copyWith(ageRange: values),
              );
            },
            activeColor: Colors.red,
          ),
          _buildSwitch("스와이프할 프로필이 없을 때 나이 범위 조정", settings.autoAdjustAge,
              (value) {
            settingsNotifier.updateSettings(
              settings.copyWith(autoAdjustAge: value),
            );
          }),
          SizedBox(height: 16),
          _buildPremiumSection(),
          SizedBox(height: 16),
          _buildSectionTitle("프로필 사진 최소 개수"),
          Slider(
            value: 1,
            min: 1,
            max: 6,
            divisions: 5,
            onChanged: (value) {},
            label: "1",
          ),
          SizedBox(height: 16),
          _buildSwitch("자기소개 완료", settings.profileComplete, (value) {
            settingsNotifier.updateSettings(
              settings.copyWith(profileComplete: value),
            );
          }),
          _buildOptionTile("관심사"),
          _buildOptionTile("내가 찾는 관계"),
          _buildOptionTile("언어 추가하기"),
        ],
      ),
    );
  }

  // UI 즉각 반영 + API 호출 최적화
  Widget _buildSmoothSlider(
      SettingsNotifier settingsNotifier, AppSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          value: _tempMaxDistance, // UI 즉각 반영
          min: 1,
          max: 50,
          divisions: 49,
          label: "${_tempMaxDistance.toInt()}km",
          onChanged: (newValue) {
            setState(() {
              _tempMaxDistance = newValue; // UI에 즉시 반영
            });

            // 기존 타이머 취소
            _debounceTimer?.cancel();

            // 0.5초 동안 변화가 없으면 API 요청
            _debounceTimer = Timer(Duration(milliseconds: 500), () {
              settingsNotifier.updateSettings(
                settings.copyWith(maxDistance: newValue.toInt()),
              );
            });
          },
          activeColor: Colors.red,
        ),
        Text("${_tempMaxDistance.toInt()} km",
            style: TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildGenderSelection(
      AppSettings settings, SettingsNotifier settingsNotifier) {
    return DropdownButton<String>(
      value: settings.preferredGender,
      dropdownColor: Colors.black,
      icon: Icon(Icons.arrow_drop_down, color: Colors.white),
      onChanged: (String? newValue) {
        if (newValue != null) {
          settingsNotifier.updateSettings(
            settings.copyWith(preferredGender: newValue),
          );
        }
      },
      items: ["남성", "여성", "Beyond Binary", "all"]
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
          color: Colors.yellow[700], borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Text("Tinder 골드",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text("디스커버리 필터를 설정하면 원하는 프로필을 볼 수 있어요.",
                style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
