import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/main-model/Profile.dart';
import '../../../data/model_views/main_view_model/main_page_viewmodel.dart';
import 'components/ProfileCard.dart';
import 'components/CircleButtons.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // ViewModel에 AnimationController 초기화
    ref
        .read(mainPageViewModelProvider.notifier)
        .initController(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    ref.read(mainPageViewModelProvider.notifier).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(mainPageViewModelProvider.notifier);
    final currentIndex = ref.watch(mainPageViewModelProvider); // 현재 인덱스 상태
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onPanUpdate: (details) {
          viewModel.onPanUpdate(details);
        },
        onPanEnd: (_) {
          viewModel.onPanEnd(size);
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final offset = Offset(
              _animationController.value, // 수평 이동
              viewModel.posY, // 수직 이동
            );

            return Stack(
              children: [
                // 다음 카드 (뒷배경 카드)
                Positioned(
                  child: ProfileCard(
                    profile: profiles[(currentIndex + 1) % profiles.length],
                  ),
                ),
                // 현재 카드
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
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleButton(icon: Icons.replay, color: Colors.grey, size: 60),
          CircleButton(icon: Icons.close, color: Colors.pink, size: 70),
          CircleButton(icon: Icons.star, color: Colors.blue, size: 60),
          CircleButton(icon: Icons.favorite, color: Colors.green, size: 70),
        ],
      ),
    );
  }
}
