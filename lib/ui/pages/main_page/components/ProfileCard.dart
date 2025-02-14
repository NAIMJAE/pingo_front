import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/ui/pages/main_page/ProfileDetailPage.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class ProfileCard extends StatefulWidget {
  final Profile profile;

  const ProfileCard({required this.profile, Key? key}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int currentImageIndex = 0; // 현재 표시 중인 이미지 인덱스
  bool isDetailVisible = false; // 상세 정보 표시 여부

  void _showNextImage() {
    setState(() {
      currentImageIndex =
          (currentImageIndex + 1) % widget.profile.ImageList.length;
    });
  }

  void _showPreviousImage() {
    setState(() {
      currentImageIndex =
          (currentImageIndex - 1) % widget.profile.ImageList.length;
      if (currentImageIndex < 0) {
        currentImageIndex = widget.profile.ImageList.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 📌 프로필 이미지 (좌우 터치로 넘기기)
        GestureDetector(
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
                Positioned.fill(
                  child: CustomImage()
                      .token(widget.profile.ImageList[currentImageIndex]),
                ),

                // 📌 하단 반투명 → 검정색 그라디언트 효과 추가
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                          Colors.black,
                        ],
                        stops: [0.6, 0.75, 0.9, 1.0],
                      ),
                    ),
                  ),
                ),

                // 📌 이미지 인디케이터 (현재 사진 위치)
                Positioned(
                  top: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        List.generate(widget.profile.ImageList.length, (index) {
                      return Container(
                        width: 20,
                        height: 5,
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: currentImageIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                ),

                // 📌 프로필 정보 (하단)
                Positioned(
                  bottom: 40,
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
                              '접속 중',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
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
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white70, size: 16),
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

                // 📌 상세 보기 버튼 (⬆️ 버튼)
                Positioned(
                  bottom: 50,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileDetailPage(profile: widget.profile),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.keyboard_arrow_up, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
