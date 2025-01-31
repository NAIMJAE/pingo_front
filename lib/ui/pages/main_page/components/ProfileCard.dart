import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/main-model/Profile.dart';
import 'package:pingo_front/data/models/main-model/ProfileDetail.dart';

class ProfileCard extends StatefulWidget {
  final Profile profile;

  const ProfileCard({required this.profile, Key? key}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  int currentImageIndex = 0; // 현재 표시 중인 이미지 인덱스
  bool isDetailVisible = false; // 상세 정보 표시 여부

  // 📌 프로필 상세 정보를 반환하는 메서드
  List<ProfileDetail> _getProfileDetails() {
    return [
      ProfileDetail(
          icon: Icons.person, title: "자기소개", value: widget.profile.status),
      ProfileDetail(
          icon: Icons.location_on, title: "거리", value: widget.profile.distance),
      ProfileDetail(icon: Icons.school, title: "학력", value: "대학 졸업"),
      ProfileDetail(icon: Icons.star, title: "성격 유형", value: "INTJ"),
      ProfileDetail(icon: Icons.pets, title: "반려동물", value: "강아지 키움"),
      ProfileDetail(icon: Icons.sports_soccer, title: "운동", value: "축구, 헬스"),
      ProfileDetail(icon: Icons.music_note, title: "취미", value: "음악 감상, 피아노"),
      ProfileDetail(icon: Icons.coffee, title: "좋아하는 음료", value: "아메리카노"),
      ProfileDetail(icon: Icons.movie, title: "좋아하는 영화", value: "SF, 액션"),
      ProfileDetail(icon: Icons.book, title: "관심 있는 책", value: "심리학 서적"),
    ];
  }

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
                  child: Image.asset(
                    widget.profile.images[currentImageIndex],
                    fit: BoxFit.cover,
                  ),
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
                        List.generate(widget.profile.images.length, (index) {
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
                      setState(() {
                        isDetailVisible = true;
                      });
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

        // 📌 상세 정보 섹션 (이미지 아래에 위치)
        if (isDetailVisible)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildProfileDetails(),
          ),
      ],
    );
  }

  // 📌 프로필 상세 정보 위젯 (스크롤 가능)
  Widget _buildProfileDetails() {
    final details = _getProfileDetails(); // 동적으로 리스트 생성

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 📌 닫기 버튼 (⬇️ 버튼)
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isDetailVisible = false;
                });
              },
              child: Icon(Icons.keyboard_arrow_down,
                  color: Colors.white, size: 30),
            ),
          ),
          SizedBox(height: 10),

          // 📌 이름, 나이
          Text(
            '${widget.profile.name} ${widget.profile.age}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),

          // 📌 리스트뷰 적용 (스크롤 가능)
          Expanded(
            child: ListView.builder(
              itemCount: details.length,
              itemBuilder: (context, index) {
                final detail = details[index];
                return _buildInfoSection(
                    detail.icon, detail.title, detail.value);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 프로필 정보 항목 UI
  Widget _buildInfoSection(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 22),
          SizedBox(width: 8),
          Text(
            "$title: ",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.white70, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
