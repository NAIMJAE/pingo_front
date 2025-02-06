import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/model_views/main_view_model/main_page_viewmodel.dart';
import 'package:pingo_front/data/model_views/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/data/models/main-model/Profile.dart';
import 'components/ProfileCard.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage>
    with SingleTickerProviderStateMixin {
  late MainPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final sessionUser = ref.watch(sessionProvider);
    final viewModel = ref.watch(mainPageViewModelProvider(this).notifier);
    final currentIndex = ref.watch(mainPageViewModelProvider(this));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onPanUpdate: viewModel.onPanUpdate,
        onPanEnd: (_) => viewModel.onPanEnd(size, sessionUser?.userNo ?? ''),
        child: AnimatedBuilder(
          animation: viewModel.animationController,
          builder: (context, child) {
            final offset = Offset(
              viewModel.animationController.value * size.width,
              viewModel.posY * size.height,
            );

            return Stack(
              children: [
                ProfileCard(
                    profile: profiles[(currentIndex + 1) % profiles.length]),
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: offset,
                    child: ProfileCard(profile: profiles[currentIndex]),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(sessionUser?.userNo ?? ''),
    );
  }

  Widget _buildBottomNavigationBar(String userNo) {
    final viewModel = ref.watch(mainPageViewModelProvider(this).notifier);

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
    final viewModel = ref.watch(mainPageViewModelProvider(this).notifier);
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
