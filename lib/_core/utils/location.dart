import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:pingo_front/data/repository/location_repository/location_repository.dart';

class LocationService {
  final Logger _logger = Logger(); // Logger 인스턴스 생성
  Position? _lastPosition; // 마지막 위치 저장
  final LocationRepository locationRepository;

  // 생성자
  LocationService(this.locationRepository);

  // 앱 실행 시 위치 초기화 및 업데이트 체크
  Future<void> initializeLocation() async {
    Position? position = await requestAndGetLocation();
    if (position != null) {
      _logger.i("앱 실행 시 위치 정보: ${position.latitude}, ${position.longitude}");
      _checkAndSendLocation(position); // 초기 위치 전송
    } else {
      _logger.w("앱 실행 시 위치 정보를 가져오지 못했습니다.");
    }
  }

  // 위치 권한 요청 및 현재 위치 가져오기
  Future<Position?> requestAndGetLocation() async {
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

  // 위치 변경 확인 후 서버 전송 (500m 이상 이동 시만 전송)
  void _checkAndSendLocation(Position newPosition) {
    if (_lastPosition != null) {
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      if (distance < 500) {
        _logger.i("위치 변경이 500m 미만이므로 전송하지 않음.");
        return;
      }
    }

    // 위치 변경 감지됨 → 서버 전송
    _sendLocationToServer(newPosition);
    _lastPosition = newPosition; // 최신 위치 저장
  }

  // 서버로 위치 전송 (API 연동 필요)
  Future<void> _sendLocationToServer(Position position) async {
    _logger.i("서버로 위치 정보 전송: ${position.latitude}, ${position.longitude}");

    await locationRepository.sendLocation({
      'userNo': 'US12345678',
      'latitude': position.latitude,
      'longitude': position.longitude,
    });
  }
}
