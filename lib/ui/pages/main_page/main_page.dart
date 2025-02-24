import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/view_models/main_view_model/main_page_viewmodel.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/ui/widgets/appbar/main_appbar.dart';
import 'components/ProfileCard.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  late MainPageViewModel viewModel;

  // 멤버 로드
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(mainPageViewModelProvider.notifier);
      final sessionUser = ref.read(sessionProvider);

      // AnimationController가 설정되지 않았다면 설정 (다른 페이지에서도 유지됨)
      if (!viewModel.isAnimationControllerSet) {
        viewModel.attachAnimationController(AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 500),
          lowerBound: -1.5,
          upperBound: 1.5,
        ));
      }

      // ✅ sessionUser.userNo가 존재하면 바로 유저 데이터 로드
      if (sessionUser.userNo != null) {
        viewModel.loadNearbyUsers(sessionUser.userNo!, 10);
        logger.i("✅ loadNearbyUsers 실행됨: userNo=${sessionUser.userNo}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sessionUser = ref.watch(sessionProvider);
    final viewModel = ref.watch(mainPageViewModelProvider.notifier);
    final userList = ref.watch(mainPageViewModelProvider);
    final size = MediaQuery.of(context).size;

    logger.i("📌 [메인페이지] 현재 userList 길이: ${userList.length}");

    return Scaffold(
      appBar: mainAppbar(context),
      backgroundColor: Colors.white,
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator()) // 로딩 표시 추가
          : GestureDetector(
              onPanUpdate: viewModel.onPanUpdate,
              onPanEnd: (_) =>
                  viewModel.onPanEnd(size, sessionUser?.userNo ?? ''),
              child: AnimatedBuilder(
                animation: viewModel.animationController,
                builder: (context, child) {
                  final offset = Offset(
                    viewModel.animationController.value * size.width,
                    viewModel.posY * size.height,
                  );

                  return Stack(
                    children: [
                      if (viewModel.noMoreUsers)
                        Center(
                          child: Text(
                            "주변에 유저가 없습니다",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      else if (userList.isNotEmpty) ...[
                        if (userList.length > 1)
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: ProfileCard(
                                profile: userList[
                                    (viewModel.currentProfileIndex + 1) %
                                        userList.length],
                              ),
                            ),
                          ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Transform.translate(
                                offset: offset,
                                child: Stack(
                                  children: [
                                    ProfileCard(
                                        profile: userList[
                                            viewModel.currentProfileIndex]),
                                    _buildSwipeStamp(viewModel),
                                  ],
                                )),
                          ),
                        ),
                      ]
                    ],
                  );
                },
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(sessionUser?.userNo ?? ''),
    );
  }

  // ✅ PING/PANG/SUPERPING 도장 표시 위젯
  Widget _buildSwipeStamp(MainPageViewModel viewModel) {
    String? stampText;
    Color stampColor = Colors.transparent;
    double rotation = 0.0;

    if (viewModel.posY <= -0.4) {
      stampText = "SUPERPING!";
      stampColor = Colors.blue;
      rotation = 0.1;
    } else if (viewModel.animationController.value <= -0.4) {
      stampText = "PING!";
      stampColor = Colors.red;
      rotation = -0.2;
    } else if (viewModel.animationController.value >= 0.4) {
      stampText = "PANG!";
      stampColor = Colors.green;
      rotation = 0.2;
    }
    if (stampText == null)
      return SizedBox(); // ✅ stampText가 null이면 위젯을 렌더링하지 않음
    return Positioned(
      top: 100, // ✅ 프로필카드 위쪽에 배치
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: 1.0, // ✅ 항상 보이게 설정 후 애니메이션으로 변동
        child: Transform.rotate(
          angle: rotation,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: stampColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              stampText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(String userNo) {
    final viewModel = ref.watch(mainPageViewModelProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSwipeButton(Icons.replay, Colors.grey, -1, viewModel.undoSwipe),
          _buildSwipeButton(
              Icons.close,
              Colors.pink,
              0,
              () => viewModel.animateAndSwitchCard(-1.5, userNo,
                  direction: 'left')),
          _buildSwipeButton(
              Icons.star,
              Colors.blue,
              2,
              () => viewModel.animateAndSwitchCard(-1.5, userNo,
                  direction: 'up')),
          _buildSwipeButton(
              Icons.favorite,
              Colors.green,
              1,
              () => viewModel.animateAndSwitchCard(1.5, userNo,
                  direction: 'right')),
        ],
      ),
    );
  }

  Widget _buildSwipeButton(
      IconData icon, Color color, int index, VoidCallback onTap) {
    final viewModel = ref.watch(mainPageViewModelProvider.notifier);
    final isHighlighted = viewModel.highlightedButton == index;

    return GestureDetector(
      onTap: () {
        viewModel.setHighlightedButton(index);
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: isHighlighted ? 80 : 60,
        height: isHighlighted ? 80 : 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: isHighlighted
              ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 20)]
              : [],
        ),
        child: Icon(icon, color: Colors.white, size: 35),
      ),
    );
  }
}
