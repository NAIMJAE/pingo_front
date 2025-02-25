import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/data/repository/main_repository/main_repository.dart';

class MainPageViewModel extends StateNotifier<List<Profile>> {
  double posY = 0.0;
  int? highlightedButton;
  int? lastSwipedIndex;
  final MainRepository repository;
  int currentProfileIndex = 0; // 유저 리스트 num 관리
  bool noMoreUsers = false; // 인덱스가 끝

  MainPageViewModel(this.repository) : super([]);

  // 도장 관련 상태 추가
  String? stampText;
  Color stampColor = Colors.transparent;
  double rotation = 0.0;

  // 애니메이션 컨트롤러를 외부에서 설정
  AnimationController? _animationController;
  bool get isAnimationControllerSet => _animationController != null;

  void attachAnimationController(AnimationController controller) {
    _animationController = controller;
  }

  AnimationController get animationController {
    if (_animationController == null) {
      throw Exception("AnimationController가 설정되지 않았습니다.");
    }
    return _animationController!;
  }

  // 주변 멤버 로드
  Future<void> loadNearbyUsers(String userNo, int distanceKm) async {
    logger.i("🔍 [메인페이지] 주변 사용자 호출 : userNo=$userNo, distanceKm=$distanceKm");

    List<Profile> users = await repository.fetchNearbyUsers(userNo, distanceKm);
    state = users;
    currentProfileIndex = 0;
    noMoreUsers = users.isEmpty;
  }

  void onPanUpdate(DragUpdateDetails details) {
    animationController.value =
        (animationController.value + details.delta.dx / 500).clamp(-1.5, 1.5);
    posY = (posY + details.delta.dy / 500).clamp(-1.5, 1.5);
    _updateSwipeState();
    // ✅ UI 갱신을 위해 강제 상태 업데이트
    state = List<Profile>.from(state);
  }

  // 스와이프 애니메이션이 끝날을 때 방향을 담아 서버 전송 로직 호출
  void onPanEnd(Size size, String userNo) {
    if (userNo.isEmpty) {
      logger.e("[오류] 사용자 번호가 없음. 스와이프 데이터를 보낼 수 없습니다.");
      return;
    }

    double horizontalSwipe = animationController.value;
    double verticalSwipe = posY; // 수직 이동 값 사용

    if (verticalSwipe < -0.4) {
      // 🔼 위로 스와이프 시 SUPERPING 적용
      animateAndSwitchCard(-1.5, userNo, direction: 'SUPERPING');
    } else if (horizontalSwipe.abs() > 0.4) {
      if (horizontalSwipe > 0) {
        animateAndSwitchCard(1.5, userNo, direction: 'PANG');
      } else {
        animateAndSwitchCard(-1.5, userNo, direction: 'PING');
      }
    } else {
      resetPosition();
    }
    // ✅ 스와이프 완료 후 도장 상태 초기화
    stampText = null;
    stampColor = Colors.transparent;
    rotation = 0.0;

    highlightedButton = null;
    state = List<Profile>.from(state);
  }

  // 버튼 하이라이트 함수
  void _updateHighlightedButton() {
    int? newHighlightedButton;
    if (animationController.value <= -0.3)
      newHighlightedButton = 1; // 싫어요
    else if (animationController.value >= 0.3)
      newHighlightedButton = 0; // 좋아요
    else if (posY <= -0.3) newHighlightedButton = 2; // 슈퍼좋아요
    if (highlightedButton != newHighlightedButton)
      highlightedButton = newHighlightedButton;
  }

  void _updateSwipeState() {
    int? newHighlightedButton;
    String? newStampText;
    Color newStampColor = Colors.transparent;
    double newRotation = 0.0;

    double horizontalSwipe = animationController.value;
    double verticalSwipe = posY;

    // ✅ 수직 방향을 먼저 확인 (SUPERPING이 먼저 체크되도록)
    if (verticalSwipe <= -0.4) {
      newHighlightedButton = 2; // 슈퍼좋아요
      newStampText = "SUPERPING!";
      newStampColor = Colors.blue;
      newRotation = -0.3; // 🔹 좀 더 기울여서 명확하게 표시
    }
    // ✅ 그 다음 수평 방향 체크 (PING/PANG)
    else if (horizontalSwipe <= -0.4) {
      newHighlightedButton = 1; // 싫어요
      newStampText = "PING!";
      newStampColor = Colors.red;
      newRotation = -0.2;
    } else if (horizontalSwipe >= 0.4) {
      newHighlightedButton = 0; // 좋아요
      newStampText = "PANG!";
      newStampColor = Colors.green;
      newRotation = 0.2;
    }
    // ✅ 기본값 (도장 숨기기)
    else {
      newHighlightedButton = null;
      newStampText = null;
      newStampColor = Colors.transparent;
      newRotation = 0.0;
    }

    // ✅ 값이 변경된 경우만 업데이트
    if (highlightedButton != newHighlightedButton ||
        stampText != newStampText ||
        stampColor != newStampColor ||
        rotation != newRotation) {
      highlightedButton = newHighlightedButton;
      stampText = newStampText;
      stampColor = newStampColor;
      rotation = newRotation;

      // ✅ UI 강제 업데이트
      state = List<Profile>.from(state);
    }
  }

  void animateAndSwitchCard(double target, String userNo, {String? direction}) {
    final String? toUserNo =
        state.isNotEmpty && currentProfileIndex < state.length
            ? state[currentProfileIndex].userNo
            : null; // ✅ 스와이프 전의 userNo 저장

    animationController
        .animateTo(target, duration: const Duration(milliseconds: 300))
        .whenComplete(() {
      _moveToNextCard();
      if (direction != null && toUserNo != null) {
        _sendSwipeData(direction, userNo, toUserNo); // ✅ 저장한 toUserNo 사용
      }
    });
  }

// ✅ 수정된 _sendSwipeData 함수
  Future<void> _sendSwipeData(
      String direction, String fromUserNo, String toUserNo) async {
    print("보내는 놈 : " + toUserNo);
    await repository.insertSwipe({
      'fromUserNo': fromUserNo,
      'toUserNo': toUserNo,
      'swipeType': direction,
    });
  }

  void _moveToNextCard() {
    if (state.isNotEmpty && currentProfileIndex < state.length - 1) {
      currentProfileIndex++;
    } else {
      noMoreUsers = true;
    }

    // 프로필이 변경될 때 도장 상태를 초기화
    stampText = null;
    stampColor = Colors.transparent;
    rotation = 0.0;
    highlightedButton = null;
    posY = 0.0;
    animationController.value = 0.0;

    // ✅ UI 강제 업데이트
    state = List<Profile>.from(state);
  }

  void undoSwipe() {
    if (lastSwipedIndex != null) {
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

  // 키워드로 조회
  Future<void> changeStateForKeyword(List<Profile> users) async {
    state = users;
    logger.i('state 길이 : ${state.length}');
    currentProfileIndex = 0;
    noMoreUsers = users.isEmpty;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

final mainRepositoryProvider = Provider<MainRepository>((ref) {
  return MainRepository();
});

final mainPageViewModelProvider =
    StateNotifierProvider<MainPageViewModel, List<Profile>>((ref) {
  final repository = ref.read(mainRepositoryProvider);
  return MainPageViewModel(repository);
});
