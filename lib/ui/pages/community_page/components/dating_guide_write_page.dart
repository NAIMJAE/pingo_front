import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DatingGuideWritePage extends StatefulWidget {
  const DatingGuideWritePage({super.key});

  @override
  State<DatingGuideWritePage> createState() => _DatingGuideWritePageState();
}

class _DatingGuideWritePageState extends State<DatingGuideWritePage> {
  File? _placeImage;

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

  @override
  Widget build(BuildContext context) {
    double cntWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('데이팅 가이드 작성'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('게시글 이미지'),
              _buildProfileBox(cntWidth),

              // controller 2개 만들어서 제목, 내용 작성

              // 작성하기 버튼
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileBox(double cntWidth) {
    return GestureDetector(
      onTap: _pickProfileImage,
      child: Container(
        width: cntWidth * 2 / 3,
        height: cntWidth * 1 / 3,
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
