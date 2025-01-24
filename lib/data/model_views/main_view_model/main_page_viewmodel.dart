import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/main-model/profile.dart';

class MainPageViewModel extends StateNotifier<int> {
  MainPageViewModel() : super(0);

  late AnimationController animationController;
  double posY = 0.0; // 수직 위치 관리

  void initController(AnimationController controller) {
    animationController = controller;
  }

  void onPanUpdate(DragUpdateDetails details) {
    // 수평, 수직 이동 업데이트
    animationController.value += details.delta.dx; // 좌우 이동
    posY += details.delta.dy; // 위아래 이동
  }

  void onPanEnd(Size size) {
    final horizontalBound = size.width * 0.3; // 좌우 이동 임계값
    final verticalBound = size.height * 0.3; // 위아래 이동 임계값

    if (animationController.value.abs() >= horizontalBound) {
      print('좌우 스와이프');
      // 좌우 스와이프
      _animateAndSwitchCard(size, horizontal: true);
    } else if (posY.abs() >= verticalBound) {
      // 위아래 스와이프
      print('위아래 스와이프');
      _animateAndSwitchCard(size, horizontal: false);
    } else {
      print('원래위치로');
      // 원래 위치로 복귀
      resetPosition();
    }
  }

  void _animateAndSwitchCard(Size size, {required bool horizontal}) {
    final target = horizontal
        ? (animationController.value.isNegative ? -size.width : size.width)
        : (posY.isNegative ? -size.height : size.height);

    animationController.animateTo(target).whenComplete(() {
      animationController.value = 0.0; // 초기화
      posY = 0.0; // 초기화
      state = (state + 1) % profiles.length; // 다음 카드로 이동
    });
  }

  void resetPosition() {
    animationController.animateTo(0,
        curve: Curves.bounceOut, duration: const Duration(milliseconds: 500));
    posY = 0.0;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

final mainPageViewModelProvider =
    StateNotifierProvider<MainPageViewModel, int>((ref) {
  return MainPageViewModel();
});
