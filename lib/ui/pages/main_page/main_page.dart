import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/models/main-model/profile.dart';
import 'components/CircleButtons.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  // 화면 크기를 가져오기 위해 초기화
  late final size = MediaQuery.of(context).size;

  // 애니메이션 컨트롤러 초기화
  // lowerBound와 upperBound는 카드 이동 범위를 설정
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500), // 애니메이션 지속 시간
    lowerBound: (size.width + 100) * -1, // 왼쪽으로 이동할 최대 거리
    upperBound: (size.width + 100), // 오른쪽으로 이동할 최대 거리
    value: 0.0, // 초기 위치 값
  );

  double posY = 0; // 수직 이동 값을 관리
  int currentIndex = 0; // 현재 표시 중인 프로필의 인덱스

  // 드래그 업데이트 처리
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _animationController.value += details.delta.dx; // 수평 이동 업데이트
      posY += details.delta.dy; // 수직 이동 업데이트
    });
  }

  // 드래그 종료 처리
  void _onPanEnd(DragEndDetails details) {
    final horizontalBound = size.width - 200; // 수평 이동 기준 거리
    final verticalBound = size.height / 4; // 수직 이동 기준 거리 (화면 높이의 1/4)

    if (_animationController.value.abs() >= horizontalBound) {
      if (_animationController.value.isNegative) {
        // 카드가 왼쪽으로 사라지는 경우
        _animationController
            .animateTo((size.width + 200) * -1)
            .whenComplete(() {
          _animationController.value = 0; // 초기화
          posY = 0; // 수직 이동 값 초기화
          currentIndex = (currentIndex + 1) % profiles.length; // 다음 프로필로 이동
          setState(() {});
        });
      } else {
        // 카드가 오른쪽으로 사라지는 경우
        _animationController.animateTo(size.width + 200).whenComplete(() {
          _animationController.value = 0; // 초기화
          posY = 0; // 수직 이동 값 초기화
          currentIndex = (currentIndex + 1) % profiles.length; // 다음 프로필로 이동
          setState(() {});
        });
      }
    } else if (posY.abs() >= verticalBound) {
      if (posY.isNegative) {
        // 카드가 위로 사라지는 경우
        _animationController.animateTo(0).whenComplete(() {
          posY = -size.height; // 화면 위로 이동
          currentIndex = (currentIndex + 1) % profiles.length; // 다음 프로필로 이동
          setState(() {
            posY = 0; // 위치 초기화
          });
        });
      } else {
        // 카드가 아래로 사라지는 경우
        _animationController.animateTo(0).whenComplete(() {
          posY = size.height; // 화면 아래로 이동
          currentIndex = (currentIndex + 1) % profiles.length; // 다음 프로필로 이동
          setState(() {
            posY = 0; // 위치 초기화
          });
        });
      }
    } else {
      // 카드가 원래 위치로 돌아옴
      _animationController.animateTo(0,
          curve: Curves.bounceOut,
          duration: const Duration(milliseconds: 500)); // bounceOut 덜덜
      setState(() {
        posY = 0; // 수직 이동 값 초기화
      });
    }
  }

  // 카드의 회전 각도와 크기를 조정하기 위한 Tween
  late final Tween<double> _rotation = Tween(
    begin: -15, // 왼쪽으로 최대 회전 각도
    end: 15, // 오른쪽으로 최대 회전 각도
  );

  late final Tween<double> _scale = Tween(
    begin: 0.8, // 뒷배경 카드의 크기 비율 (작게)
    end: 1.0, // 활성 카드의 크기 비율 (기본 크기)
  );

  @override
  void dispose() {
    // 애니메이션 컨트롤러 해제
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = profiles[currentIndex]; // 현재 프로필 가져오기

    return Scaffold(
      backgroundColor: Colors.black, // 배경색 설정
      body: GestureDetector(
        onPanUpdate: _onPanUpdate, // 모든 방향의 드래그 업데이트 처리
        onPanEnd: _onPanEnd, // 드래그 종료 처리
        child: AnimatedBuilder(
          animation: _animationController, // 애니메이션 컨트롤러를 사용하여 UI 업데이트
          builder: (context, child) {
            // 현재 애니메이션 값을 기반으로 카드의 회전 각도 계산
            final angle = _rotation.transform(
              (_animationController.value + size.width / 2) / size.width,
            );

            // 현재 애니메이션 값을 기반으로 카드 크기 조정
            final scale = _scale.transform(
              _animationController.value.abs() / size.width,
            );

            return Stack(
              children: [
                // 뒤쪽에 표시될 카드 (작은 크기로 표시)
                Positioned(
                  child: Transform.scale(
                    scale: min(scale, 1.0),
                    child: _buildProfileCard(
                      profiles[(currentIndex + 1) % profiles.length],
                    ),
                  ),
                ),

                // 현재 활성화된 카드 (중앙에 위치)
                Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset:
                        Offset(_animationController.value, posY), // 수평/수직 이동
                    child: Transform.rotate(
                      angle: angle * pi / 180, // 회전 각도를 라디안으로 변환
                      child: _buildProfileCard(profile),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildMainBottomNavigationBar(), // 하단 버튼
    );
  }

  // 프로필 카드를 빌드하는 메서드
  Widget _buildProfileCard(Map<String, String> profile) {
    return Material(
      elevation: 10, // 그림자 효과
      borderRadius: BorderRadius.circular(10), // 모서리 둥글게
      clipBehavior: Clip.hardEdge, // 내용 잘림 처리
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // 프로필 이미지 표시
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(profile['image']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // 프로필 정보 표시
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // "근처" 태그 표시
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      // 이름, 나이, 상태 표시
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
        ),
      ),
    );
  }

  // 하단 버튼 구성
  Widget _buildMainBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 재시도 버튼
          CircleButton(icon: Icons.replay, color: Colors.grey, size: 60),
          // 싫어요 버튼
          CircleButton(icon: Icons.close, color: Colors.pink, size: 70),
          // 슈퍼 좋아요 버튼
          CircleButton(icon: Icons.star, color: Colors.blue, size: 60),
          // 좋아요 버튼
          CircleButton(icon: Icons.favorite, color: Colors.green, size: 70),
        ],
      ),
    );
  }
}
