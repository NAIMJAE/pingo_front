import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/models/main-model/profile.dart';
import 'components/CircleButtons.dart';

// 변경 필요한 페이지라 stf
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0; // 프로필 인덱스
  final PageController _pageController =
      PageController(viewportFraction: 0.85); // 애니메이션 처리

  // 스와이프 동작 처리 메서드
  void onSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity;
    if (velocity == null) return;

    // 밑, 위 스와이프 및 기능 추가는 추후에정 틀만 만들어놓음
    setState(() {
      if (velocity > 0) {
        // 오른쪽 스와이프 -> 싫어요
        if (currentIndex > 0) currentIndex--;
        print("싫어요!");
      } else if (velocity < 0) {
        // 왼쪽 스와이프 -> 좋아요
        if (currentIndex < profiles.length - 1) currentIndex++;
        print("좋아요!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = profiles[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onHorizontalDragEnd: onSwipe,
        child: PageView.builder(
          controller: _pageController,
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            final profile = profiles[index];
            return Stack(
              children: [
                // 프로필 이미지
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(profile['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // 프로필 정보
                Positioned(
                  bottom: 100,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '근처',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${profile['name']} ${profile['age']} ${profile['status']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.location_solid,
                            color: Colors.white70,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            profile['distance']!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 재시도 버튼
            CircleButton(
              icon: Icons.replay,
              color: Colors.grey,
              size: 60,
            ),
            // 싫어요 버튼
            CircleButton(
              icon: Icons.close,
              color: Colors.pink,
              size: 70,
            ),
            // 슈퍼 좋아요 버튼
            CircleButton(
              icon: Icons.star,
              color: Colors.blue,
              size: 60,
            ),
            // 좋아요 버튼
            CircleButton(
              icon: Icons.favorite,
              color: Colors.green,
              size: 70,
            ),
            // 부스터 버튼
            CircleButton(
              icon: CupertinoIcons.paperplane_fill,
              color: Colors.purple,
              size: 60,
            ),
          ],
        ),
      ),
    );
  }
}
