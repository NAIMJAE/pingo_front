import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/main-model/Profile.dart';
import 'package:pingo_front/data/repository/main_repository/main_repository.dart';

class MainPageViewModel extends StateNotifier<int> {
  late final AnimationController animationController;
  double posY = 0.0;
  int? highlightedButton;
  int? lastSwipedIndex;
  final MainRepository repository;

  MainPageViewModel(TickerProvider vsync, this.repository) : super(0) {
    animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 500),
      lowerBound: -1.5,
      upperBound: 1.5,
    );
  }

  void onPanUpdate(DragUpdateDetails details) {
    animationController.value =
        (animationController.value + details.delta.dx / 500).clamp(-1.5, 1.5);
    posY = (posY + details.delta.dy / 500).clamp(-1.5, 1.5);
    _updateHighlightedButton();
  }

  // 스와이프 애니메이션이 끝날을 때
  void onPanEnd(Size size, String userNo) {
    if (userNo.isEmpty) {
      logger.e("[오류] 사용자 번호가 없음. 스와이프 데이터를 보낼 수 없습니다.");
      return;
    }

    if (animationController.value.abs() > 0.4) {
      if (animationController.value > 0) {
        animateAndSwitchCard(1.5, userNo, direction: 'PANG');
      } else {
        animateAndSwitchCard(-1.5, userNo, direction: 'PING');
      }
    } else {
      resetPosition();
    }
    highlightedButton = null;
  }

  void _updateHighlightedButton() {
    int? newHighlightedButton;
    if (animationController.value <= -0.3)
      newHighlightedButton = 0;
    else if (animationController.value >= 0.3)
      newHighlightedButton = 1;
    else if (posY <= -0.3) newHighlightedButton = 2;
    if (highlightedButton != newHighlightedButton)
      highlightedButton = newHighlightedButton;
  }

  void animateAndSwitchCard(double target, String userNo, {String? direction}) {
    animationController
        .animateTo(target, duration: const Duration(milliseconds: 300))
        .whenComplete(() {
      _moveToNextCard();
      if (direction != null) {
        _sendSwipeData(direction, userNo); // 서버 요청은 애니메이션이 끝난 후 비동기 실행
      }
    });
  }

  // 스와이프 보내기
  Future<void> _sendSwipeData(String? direction, String userNo) async {
    if (direction != null) {
      await repository.insertSwipe({
        'fromUserNo': userNo,
        'toUserNo': profiles[state].userNo,
        'swipeType': direction,
        'swipeState': 'WAIT'
      });
    }
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
  }

  void setHighlightedButton(int index) {
    highlightedButton = index;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

final mainPageViewModelProvider =
    StateNotifierProvider.family<MainPageViewModel, int, TickerProvider>(
  (ref, vsync) => MainPageViewModel(vsync, MainRepository()),
);
