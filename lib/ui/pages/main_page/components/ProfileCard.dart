import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/main-model/Profile.dart';

class ProfileCard extends StatefulWidget {
  final Profile profile;

  const ProfileCard({required this.profile, Key? key}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int currentImageIndex = 0; // 🔥 현재 표시 중인 이미지의 인덱스

  void _showNextImage() {
    setState(() {
      currentImageIndex =
          (currentImageIndex + 1) % widget.profile.images.length;
    });
  }

  void _showPreviousImage() {
    setState(() {
      currentImageIndex =
          (currentImageIndex - 1) % widget.profile.images.length;
      if (currentImageIndex < 0) {
        currentImageIndex = widget.profile.images.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final tapPosition = details.globalPosition.dx;
        final screenWidth = size.width;

        if (tapPosition < screenWidth / 2) {
          _showPreviousImage(); // ⬅️ 왼쪽 탭 → 이전 이미지
        } else {
          _showNextImage(); // ➡️ 오른쪽 탭 → 다음 이미지
        }
      },
      child: Material(
        elevation: 10,
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // 🔥 현재 선택된 이미지 표시
            Positioned.fill(
              child: Image.asset(
                widget.profile.images[currentImageIndex],
                fit: BoxFit.cover,
              ),
            ),

            // 🔥 하단 반투명 → 검정색 그라디언트 효과 추가
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent, // 위쪽은 투명
                      Colors.black.withOpacity(0.3), // 중간은 살짝 어두움
                      Colors.black.withOpacity(0.7), // 더 어두워짐
                      Colors.black, // 완전 검정색 (버튼과 자연스럽게 연결)
                    ],
                    stops: [0.6, 0.75, 0.9, 1.0], // 색상이 변하는 지점 설정
                  ),
                ),
              ),
            ),

            // 🔥 이미지 위치를 표시하는 인디케이터
            Positioned(
              top: 40, // 상단에 배치
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.profile.images.length, (index) {
                  return Container(
                    width: 20,
                    height: 5,
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: currentImageIndex == index
                          ? Colors.white // 현재 이미지 → 흰색
                          : Colors.white.withOpacity(0.4), // 나머지 → 흐린색
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ),

            // 🔥 프로필 정보 (하단)
            Positioned(
              bottom: 40,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // "접속 중" 태그
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '접속 중',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      // 이름, 나이
                      Text(
                        '${widget.profile.name}, ${widget.profile.age}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // 위치 정보
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.white70, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${widget.profile.distance}',
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
}
