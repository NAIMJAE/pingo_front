import 'package:flutter/material.dart';

// 프로필 상세 정보를 담는 모델 클래스
class ProfileDetail {
  final IconData icon;
  final String title;
  final String value;

  ProfileDetail({required this.icon, required this.title, required this.value});
}
