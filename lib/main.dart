import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/model_views/global_view_model/session_gvm.dart';
import 'package:pingo_front/data/model_views/signup_view_model/signup_view_model.dart';
import 'package:pingo_front/data/model_views/stomp_view_model.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_in_page.dart';

import '_core/theme/theme.dart';
import 'ui/pages/main_screen.dart';

void main() {
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
    Future.microtask(
        () => ref.read(stompViewModelProvider.notifier).stompConnect());
  }

  // 로그인 검증시 화면 전환 함수
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

/**
 * ■ 추가할 기능
 * - golbalKey<NavigatorState>를 통해 페이지 관리 및 오류 처리
 * -
 */
