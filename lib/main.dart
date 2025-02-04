import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:pingo_front/_core/utils/location.dart';
import 'package:pingo_front/data/model_views/global_view_model/session_gvm.dart';
import 'package:pingo_front/data/model_views/signup_view_model/signup_view_model.dart';
import 'package:pingo_front/data/model_views/stomp_view_model.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_in_page.dart';
import '_core/theme/theme.dart';
import 'ui/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화
  await LocationService.initializeLocation(); // ✅ 위치 정보 초기화 호출
  runApp(ProviderScope(child: PingoApp()));
}

class PingoApp extends ConsumerStatefulWidget {
  const PingoApp({super.key});

  @override
  ConsumerState<PingoApp> createState() => _PingoAppState();
}

class _PingoAppState extends ConsumerState<PingoApp> {
  late int screenIndex;

  @override
  void initState() {
    super.initState();
    screenIndex = ref.read(sessionGvmProvider.notifier).checkLoginState();

    // STOMP 웹소캣 연결
    // 현재 코드 실행이 끝난 직후에 실행할 비동기 작업을 예약
    Future.microtask(
        () => ref.read(stompViewModelProvider.notifier).stompConnect());
  }

  // 로그인 검증 후 화면 전환 함수
  void toggleScreenAfterLogin() {
    setState(() {
      screenIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mTheme(),
      home: SafeArea(
        child: screenIndex == 0
            ? SignInPage(toggleScreenAfterLogin)
            : MainScreen(),
      ),
    );
  }

  @override
  void dispose() {
    // 앱 꺼지면 웹소캣 해제
    ref.read(stompViewModelProvider.notifier).stompDisconnect();
    super.dispose();
  }
}
