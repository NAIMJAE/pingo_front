import 'package:flutter/animation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final tickerProvider = Provider<TickerProvider>((ref) {
  throw Exception("TickerProvider가 설정되지 않았습니다."); // ✅ 강제 예외 발생 방지
});
