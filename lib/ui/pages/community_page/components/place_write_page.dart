import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/community_model/kakao_search.dart';
import 'package:pingo_front/data/models/community_model/place_review.dart';
import 'package:pingo_front/data/view_models/community_view_model/place_review_search_view_model.dart';

class PlaceWritePage extends StatefulWidget {
  String userNo;
  PlaceReviewSearchViewModel kakaoSearchProvider;
  PlaceWritePage(this.kakaoSearchProvider, this.userNo, {super.key});

  @override
  State<PlaceWritePage> createState() => _PlaceWritePageState();
}

class _PlaceWritePageState extends State<PlaceWritePage> {
  late KakaoSearch kakaoSearch;
  final TextEditingController _textController = TextEditingController();
  File? _placeImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kakaoSearch = widget.kakaoSearchProvider.lastSearch;
  }

  // picker 라이브러리를 이용한 이미지 파일 처리 함수
  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _placeImage = File(pickedFile.path);
      });
    }
  }

  // 유효성 검증 후 게시글 작성
  void checkValidation() async {
    if (_placeImage == null || _textController.text.trim() == '') {
      logger.e('이미지와 한줄평을 등록하세요');
      return;
    }

    PlaceReview placeReview = PlaceReview(
      null,
      kakaoSearch.placeName,
      null,
      kakaoSearch.addressName,
      kakaoSearch.roadAddressName,
      widget.userNo,
      _textController.text.trim(),
      kakaoSearch.category,
      kakaoSearch.latitude,
      kakaoSearch.longitude,
      0,
      null,
      null,
    );

    Map<String, dynamic> data = {
      'placeReview': placeReview,
      'placeImage': _placeImage,
    };

    bool result = await widget.kakaoSearchProvider.insertPlaceReview(data);

    if (result) {
      // 작성 되었습니다 띄우고 네비게이션 스택 다 파괴하고 서치페이지에 뜨게하기?
      Navigator.pop(
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double cntWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("추천 장소 등록")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  '다른 사용자를 위해 장소를 추천해보세요!',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 32),
                _buildProfileBox(cntWidth),
                const SizedBox(height: 32),
                Text(
                  kakaoSearch.placeName ?? '이름 없음',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  kakaoSearch.addressName ?? '주소 없음',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '한 줄평 작성',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _placeImage == null ||
                              _textController.text.trim() == ''
                          ? Colors.grey
                          : Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () => checkValidation(),
                    child: Text(
                      '작성',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).viewInsets.bottom / 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileBox(double cntWidth) {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: Container(
        width: double.infinity,
        height: cntWidth * 2 / 3,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: _placeImage == null
            ? Center(
                child: Icon(
                  Icons.add_a_photo,
                  size: 50,
                  color: Colors.black38,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  _placeImage!,
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}
