import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/community_model/kakao_search.dart';

class KakaoMapScreen extends StatefulWidget {
  KakaoSearch kakaoSearch;
  KakaoMapScreen(this.kakaoSearch, {super.key});

  @override
  State<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends State<KakaoMapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
