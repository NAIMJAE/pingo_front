import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/data/models/main_model/ProfileDetail.dart';

import '../../widgets/custom_image.dart';

class ProfileDetailPage extends StatefulWidget {
  final Profile profile;

  const ProfileDetailPage({required this.profile, Key? key}) : super(key: key);

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  int currentImageIndex = 0; // 현재 표시 중인 이미지 인덱스

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          _buildHeader(context),
          _buildImageSection(),
          Expanded(child: _buildProfileDetails()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            '${widget.profile.name}, ${widget.profile.age}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        final tapPosition = details.globalPosition.dx;
        final screenWidth = MediaQuery.of(context).size.width;

        if (tapPosition < screenWidth / 2) {
          _showPreviousImage();
        } else {
          _showNextImage();
        }
      },
      child: Column(
        children: [
          SizedBox(height: 10),
          Container(
            height: 500,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CustomImage().getImageProvider(
                    widget.profile.ImageList[currentImageIndex]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.profile.ImageList.length,
              (index) => Container(
                width: 20,
                height: 5,
                margin: EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: index == currentImageIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileDetails() {
    final details = [
      // ProfileDetail(
      //     icon: Icons.person, title: "자기소개", value: widget.profile.status),
      // ProfileDetail(
      //     icon: Icons.location_on, title: "거리", value: widget.profile.distance),
      // ProfileDetail(icon: Icons.school, title: "학력", value: "대학 졸업"),
      // ProfileDetail(icon: Icons.star, title: "성격 유형", value: "INTJ"),
      // ProfileDetail(icon: Icons.pets, title: "반려동물", value: "강아지 키움"),
      // ProfileDetail(icon: Icons.sports_soccer, title: "운동", value: "축구, 헬스"),
      // ProfileDetail(icon: Icons.music_note, title: "취미", value: "음악 감상, 피아노"),
      // ProfileDetail(icon: Icons.coffee, title: "좋아하는 음료", value: "아메리카노"),
      // ProfileDetail(icon: Icons.movie, title: "좋아하는 영화", value: "SF, 액션"),
      // ProfileDetail(icon: Icons.book, title: "관심 있는 책", value: "심리학 서적"),
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView.builder(
        itemCount: details.length,
        itemBuilder: (context, index) {
          final detail = details[index];
          return _buildInfoSection(detail.icon, detail.title, detail.value);
        },
      ),
    );
  }

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
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
