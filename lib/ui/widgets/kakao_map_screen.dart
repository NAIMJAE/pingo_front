import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/community_model/kakao_search.dart';

class KakaoMapScreen extends StatefulWidget {
  final KakaoSearch kakaoSearch;
  KakaoMapScreen(this.kakaoSearch, {super.key});

  @override
  State<KakaoMapScreen> createState() => _KakaoMapScreenState();
}

class _KakaoMapScreenState extends State<KakaoMapScreen> {
  KakaoMapController? mapController;

  @override
  Widget build(BuildContext context) {
    // ✅ KakaoMap 위젯에서 직접 위도/경도 설정
    LatLng latlng = LatLng(
      widget.kakaoSearch.latitude ?? 37.5665,
      widget.kakaoSearch.longitude ?? 126.9780,
    );

    // ✅ KakaoMap 위젯에서 직접 마커 설정
    Set<Marker> markers = {
      Marker(
        markerId: 'search_marker',
        latLng: latlng,
      ),
    };

    // 랜더링 시점의 문제 같음

    return Scaffold(
      body: KakaoMap(
        onMapCreated: (controller) async {
          mapController = controller;
          logger.i("✅ 지도 컨트롤러 생성됨");

          // 🛠 KakaoMap이 완전히 로드될 때까지 대기
          await Future.delayed(Duration(seconds: 1));

          // 🛠 지도의 중심을 부모 위젯에서 받은 값으로 설정
          await mapController!.setCenter(latlng);
          logger.i("✅ 지도의 중심이 ${latlng.latitude}, ${latlng.longitude}로 설정됨");

          // 🛠 현재 지도 중심이 잘 반영되었는지 확인
          LatLng center = await mapController!.getCenter();
          logger
              .i("📌 getCenter() 결과: ${center.latitude}, ${center.longitude}");
        },
        markers: markers.toList(),
        center: latlng, // ✅ KakaoMap에서 직접 `latlng`을 적용
        currentLevel: 3, // 줌 기능 제거하고 기본 레벨 설정
      ),
    );
  }
}
