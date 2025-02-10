import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/location.dart';

import 'package:pingo_front/ui/pages/sign_page/sign_in_page.dart';
import 'package:pingo_front/ui/pages/splash_page.dart';
import '_core/theme/theme.dart';
import 'ui/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화
  LocationService.initializeLocation(); // 앱 실행 시 현재 위치만 저장 (서버 전송 X)
  runApp(ProviderScope(child: PingoApp()));
}

GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

class PingoApp extends StatefulWidget {
  const PingoApp({super.key});

  @override
  _PingoAppState createState() => _PingoAppState();
}

class _PingoAppState extends State<PingoApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      // 앱이 백그라운드로 가거나 종료될 때 실행
      LocationService.stopLocationTracking(); // 타이머 위치 추적 종료
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorkey,
      debugShowCheckedModeBanner: false,
      theme: mTheme(),
      home: SafeArea(
        child: SplashPage(),
      ),
      routes: {
        "/signin": (context) => SignInPage(),
        "/mainScreen": (context) => MainScreen(),
      },
    );
  }
}
