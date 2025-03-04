import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/data/models/main_model/ProfileDetail.dart';
import 'package:pingo_front/data/models/user_model/user_mypage_info.dart';
import 'package:pingo_front/data/view_models/main_view_model/main_page_viewmodel.dart';
import 'package:pingo_front/data/view_models/sign_view_model/signin_view_model.dart';
import 'package:pingo_front/data/view_models/user_view_model/user_view_model.dart';

import '../../widgets/custom_image.dart';

class ProfileDetailPage extends ConsumerStatefulWidget {
  final Profile profile;

  const ProfileDetailPage({required this.profile, Key? key}) : super(key: key);

  @override
  _ProfileDetailPageState createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends ConsumerState<ProfileDetailPage> {
  int currentImageIndex = 0; // 현재 표시 중인 이미지 인덱스
  late String userNo;

  @override
  void initState() {
    super.initState();
    userNo = ref.read(sessionProvider).userNo!;
    logger.i("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    logger.i(widget.profile);

    // 비동기 데이터 로드 함수 호출
    _loadProfileDetail();
  }

  Future<void> _loadProfileDetail() async {
    try {
      ProfileDetail profileDetail = await ref
          .read(mainPageViewModelProvider.notifier)
          .fetchMyDetail(userNo);

      setState(() {
        widget.profile.profileDetail = profileDetail;
      });

      logger.i("ProfileDetail 업데이트 완료: ${widget.profile.profileDetail}");
    } catch (e) {
      logger.e("ProfileDetail 로딩 실패: $e");
    }
  }

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
      extendBodyBehindAppBar: true, // 배경과 자연스럽게 연결
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.9), // 반투명 블랙 배경
        elevation: 0, // 그림자 제거
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.profile.name,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true, // 타이틀 중앙 정렬
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
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
                    height: 400,
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
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.profile.name}, ${widget.profile.age}",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "📍 ${widget.profile.profileDetail?.userInfo?.userAddress ?? ''}",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  Divider(color: Colors.white24),
                  _buildInfoRow(
                      "생년월일",
                      widget.profile.profileDetail?.userInfo?.userBirth
                              ?.toLocal()
                              .toString()
                              .split(' ')[0] ??
                          '정보 없음'),
                  _buildInfoRow("키",
                      "${widget.profile.profileDetail?.userInfo?.userHeight ?? '정보 없음'} cm"),
                  _buildInfoRow(
                      "주소",
                      widget.profile.profileDetail?.userInfo?.userAddress ??
                          '정보 없음'),
                  _buildInfoRow(
                      "1차 직업",
                      widget.profile.profileDetail?.userInfo?.user1stJob ??
                          '정보 없음'),
                  _buildInfoRow(
                      "2차 직업",
                      widget.profile.profileDetail?.userInfo?.user2ndJob ??
                          '정보 없음'),
                  _buildInfoRow(
                      "종교",
                      widget.profile.profileDetail?.userInfo?.userReligion ??
                          '정보 없음'),
                  _buildInfoRow(
                      "음주",
                      widget.profile.profileDetail?.userInfo?.userDrinking ==
                              'F'
                          ? '하지 않음'
                          : '가끔 마심'),
                  _buildInfoRow(
                      "흡연",
                      widget.profile.profileDetail?.userInfo?.userSmoking == 'F'
                          ? '비흡연'
                          : '흡연'),
                  Divider(color: Colors.white24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8,
                children: [
                  _buildTag("산책"),
                  _buildTag("맛집"),
                  _buildTag("자기 개발"),
                  _buildTag("여행"),
                  _buildTag("야구"),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(Icons.close, Colors.pink, () {}),
                _buildActionButton(Icons.star, Colors.blue, () {}),
                _buildActionButton(Icons.favorite, Colors.green, () {}),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    return Chip(
      label: Text(text, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.pinkAccent,
    );
  }

  Widget _buildActionButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: color,
      child: Icon(icon, size: 30, color: Colors.white),
    );
  }
}
