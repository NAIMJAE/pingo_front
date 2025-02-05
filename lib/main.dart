import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/location.dart';

import 'package:pingo_front/data/model_views/global_view_model/session_gvm.dart';
import 'package:pingo_front/data/repository/location_repository/location_repository.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_in_page.dart';
import 'package:pingo_front/ui/pages/splash_page.dart';
import '_core/theme/theme.dart';
import 'ui/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 초기화

  final locationRepo = LocationRepository(); // ✅ LocationRepository 인스턴스 생성
  final locationService =
      LocationService(locationRepo); // ✅ LocationService 인스턴스 생성
  await locationService.initializeLocation(); // ✅ 인스턴스를 통해 호출

  runApp(ProviderScope(child: PingoApp()));
}

GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

class PingoApp extends StatelessWidget {
  const PingoApp({super.key});

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
