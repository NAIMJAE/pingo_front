import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/view_models/main_view_model/main_page_viewmodel.dart';

import '../../../data/models/main-model/Profile.dart';
import 'components/ProfileCard.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(mainPageViewModelProvider(this).notifier);
    final animationController = viewModel.animationController;
    final currentIndex = ref.watch(mainPageViewModelProvider(this));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onPanUpdate: viewModel.onPanUpdate,
        onPanEnd: (_) => viewModel.onPanEnd(size),
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final offset = Offset(animationController.value * size.width,
                viewModel.posY * size.height);

            return Stack(
              children: [
                Positioned(
                  child: ProfileCard(
                    profile: profiles[(currentIndex + 1) % profiles.length],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: offset,
                    child: ProfileCard(
                      profile: profiles[currentIndex],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(viewModel),
    );
  }

  // 하단 컨테이너 위젯
  Widget _buildBottomNavigationBar(MainPageViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildAnimatedButton(
              Icons.replay, Colors.grey, -1, viewModel.undoSwipe), //  되돌리기 버튼
          _buildAnimatedButton(
              Icons.close, Colors.pink, 0, viewModel.onSwipeLeft), //  거절 버튼
          _buildAnimatedButton(
              Icons.star, Colors.blue, 2, viewModel.onSwipeUp), //  슈퍼 좋아요 버튼
          _buildAnimatedButton(Icons.favorite, Colors.green, 1,
              viewModel.onSwipeRight), //  좋아요 버튼
        ],
      ),
    );
  }

  // 메인 하단 버튼 위젯
  Widget _buildAnimatedButton(
      IconData icon, Color color, int index, VoidCallback onTap) {
    final viewModel = ref.watch(mainPageViewModelProvider(this).notifier);
    final isHighlighted = viewModel.highlightedButton == index;

    return GestureDetector(
      onTap: () {
        viewModel.highlightedButton = index;
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: isHighlighted ? 80 : 60, //  스와이프할 때도 버튼 크기 변경
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
