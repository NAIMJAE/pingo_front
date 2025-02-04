import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class LocationService {
  static final Logger _logger = Logger(); // Logger 인스턴스 생성

  // ✅ 앱 실행 시 위치 정보 가져오기 (초기화 기능 포함)
  static Future<void> initializeLocation() async {
    Position? position = await requestAndGetLocation();
    if (position != null) {
      _logger.i("앱 실행 시 위치 정보: ${position.latitude}, ${position.longitude}");
    } else {
      _logger.w("앱 실행 시 위치 정보를 가져오지 못했습니다.");
    }
  }

  // ✅ 위치 권한 요청 및 현재 위치 가져오기
  static Future<Position?> requestAndGetLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. 위치 서비스 활성화 확인
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _logger.e("위치 서비스가 비활성화됨.");
      return null;
    }

    // 2. 위치 권한 확인 및 요청
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _logger.w("위치 권한이 거부됨.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _logger.e("위치 권한이 영구적으로 거부됨. 설정에서 권한을 변경해야 합니다.");
      return null;
    }

    // 3. 현재 위치 가져오기
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    _logger.i("위치 가져오기 성공: ${position.latitude}, ${position.longitude}");
    return position;
  }
}
