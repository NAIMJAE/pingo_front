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
  late final LatLng _latLng;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();

    // 초기 위도/경도 설정
    _latLng = LatLng(
      widget.kakaoSearch.latitude ?? 37.5665,
      widget.kakaoSearch.longitude ?? 126.9780,
    );

    logger.i(
        '초기 위도: ${widget.kakaoSearch.latitude}, 초기 경도: ${widget.kakaoSearch.longitude}');

    markers = {
      Marker(
        markerId: 'search_marker',
        latLng: _latLng,
      ),
    };
  }

  // 지도의 초기 화면을 위해 center 속성을 부모 위젯에서 받아온 위도 경도 값으로
  // 동적으로 할당했을때 위도, 경도가 KakaoMap에 전달되지 않는 이슈
  // onMapCreated 안에서 setCenter 메서드를 이용해 동적으로 위도 경도를 넣거나
  // center 속성에 동적으로 위도 경도를 넣었을 때 둘 모두 값이 들어가지 않고
  // kakaoMap의 기본 위도 경도인 이상한 값으로 계속 남음
  // 랜더링 시점의 문제인지 확인도 딜레이를 걸어 확인해 봤지만 아닌듯
  // 어디가 문제인지 모르겠어서 일단 보류하고 나중에 에러 잡기
  // https://github.com/johyunchol/kakao_map_plugin  -> 카카오맵플러그인 깃허브

  @override
  Widget build(BuildContext context) {
    return KakaoMap(
      center: LatLng(37.5665, 126.9780),
      onMapCreated: (controller) async {
        mapController = controller;
      },
      markers: markers.toList(),
      currentLevel: 3,
    );
  }
}
