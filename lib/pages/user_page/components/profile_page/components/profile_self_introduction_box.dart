import 'package:flutter/material.dart';

class ProfileSelfIntroductionBox extends StatelessWidget {
  const ProfileSelfIntroductionBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Text(
              '자기소개',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8.0),
            TextField(
              maxLines: 5, // 여러 줄 입력 가능
              maxLength: 1000, // 최대 1000자 입력 가능
              decoration: InputDecoration(
                border: OutlineInputBorder(), // 테두리 스타일
                hintText: '자기소개를 입력하세요', // 힌트 텍스트
                contentPadding: EdgeInsets.all(8.0), // 내부 여백
              ),
            ),
          ],
        ),
      ),
    );
  }
}
