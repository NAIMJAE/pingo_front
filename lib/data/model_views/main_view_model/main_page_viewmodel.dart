import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/main-model/profile.dart';

class MainPageViewModel extends StateNotifier<int> {
  late final AnimationController animationController;
  double posY = 0.0;
  int? highlightedButton; //  현재 강조할 버튼 (0: 왼쪽, 1: 오른쪽, 2: 위쪽)
  int? lastSwipedIndex; //  되돌리기 기능을 위한 마지막 스와이프 인덱스

  MainPageViewModel(TickerProvider vsync) : super(0) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
      lowerBound: -1.5,
      upperBound: 1.5,
    );

    animationController.addListener(() {
      state = state; //  UI 강제 갱신
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    animationController.value =
        (animationController.value + details.delta.dx / 500).clamp(-1.5, 1.5);
    posY = (posY + details.delta.dy / 500).clamp(-1.5, 1.5);

    // 스와이프 방향에 따라 버튼 강조 효과 추가
    int? newHighlightedButton;
    if (animationController.value <= -0.3) {
      newHighlightedButton = 0; // ❌ 거절 버튼 강조
    } else if (animationController.value >= 0.3) {
      newHighlightedButton = 1; //  좋아요 버튼 강조
    } else if (posY <= -0.3) {
      newHighlightedButton = 2; // 슈퍼 좋아요 버튼 강조
    } else {
      newHighlightedButton = null; //  초기화
    }

    // 🔥 버튼 상태가 변경되었을 경우에만 UI 갱신 (최적화)
    if (highlightedButton != newHighlightedButton) {
      highlightedButton = newHighlightedButton;
      state = state; // ✅ 즉각적인 UI 갱신
    }
  }

  void onPanEnd(Size size) {
    final horizontalBound = 0.4;
    final verticalBound = 0.4;

    if (animationController.value <= -horizontalBound) {
      onSwipeLeft();
      print('거절 버튼');
    } else if (animationController.value >= horizontalBound) {
      onSwipeRight();
      print('좋아요 버튼');
    } else if (posY <= -verticalBound) {
      onSwipeUp();
      print('슈퍼좋아요 버튼');
    } else {
      resetPosition();
      print('초기화 버튼');
    }

    highlightedButton = null; //  초기화
    state = state; // ✅ UI 갱신
  }

  void onSwipeLeft() {
    lastSwipedIndex = state; //  되돌리기 위해 상태 저장
    _animateAndSwitchCard(-1.5);
  }

  void onSwipeRight() {
    lastSwipedIndex = state; //  되돌리기 위해 상태 저장
    _animateAndSwitchCard(1.5);
  }

  void onSwipeUp() {
    lastSwipedIndex = state; //  되돌리기 위해 상태 저장
    _animateAndSwitchCard(-1.5, vertical: true);
  }

  void _animateAndSwitchCard(double target, {bool vertical = false}) {
    animationController
        .animateTo(target, duration: const Duration(milliseconds: 300))
        .whenComplete(() {
      _moveToNextCard();
    });
  }

  void _moveToNextCard() {
    animationController.value = 0.0;
    posY = 0.0;
    state = (state + 1) % profiles.length;
  }

  void undoSwipe() {
    if (lastSwipedIndex != null) {
      state = lastSwipedIndex!;
      lastSwipedIndex = null;
    }
  }

  void resetPosition() {
    animationController.animateTo(0,
        curve: Curves.bounceOut, duration: const Duration(milliseconds: 500));
    posY = 0.0;
    highlightedButton = null; // ✅ 스와이프 복귀 시 버튼 크기도 원래대로
    state = state; // ✅ UI 갱신
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

final mainPageViewModelProvider =
    StateNotifierProvider.family<MainPageViewModel, int, TickerProvider>(
  (ref, vsync) => MainPageViewModel(vsync),
);
