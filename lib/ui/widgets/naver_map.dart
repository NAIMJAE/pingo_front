import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:pingo_front/_core/utils/logger.dart';

class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});

  @override
  State<NaverMapApp> createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> {
  bool isMapInitialized = false; // ✅ 네이버 맵 초기화 여부
  late NaverMapController _mapController;

  @override
  void initState() {
    super.initState();
    _initializeNaverMap();
  }

  Future<void> _initializeNaverMap() async {
    try {
      await NaverMapSdk.instance.initialize(
        clientId: 'YOUR_NAVER_CLIENT_ID', // 네이버 클라이언트 ID 입력
        onAuthFailed: (ex) {
          logger.e("네이버 맵 인증 오류: $ex");
        },
      );

      if (mounted) {
        setState(() {
          isMapInitialized = true; // ✅ 초기화 완료 후 UI 업데이트
        });
      }
    } catch (e) {
      logger.e("네이버 맵 초기화 중 오류 발생: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isMapInitialized
        ? NaverMap(
            options: const NaverMapViewOptions(
              indoorEnable: true,
              locationButtonEnable: false,
              consumeSymbolTapEvents: false,
            ),
            onMapReady: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
          )
        : const Center(child: CircularProgressIndicator()); // ✅ 초기화 중 로딩 표시
  }
}
