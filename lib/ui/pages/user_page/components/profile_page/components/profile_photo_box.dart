import 'package:flutter/material.dart';

class ProfilePhotoBox extends StatelessWidget {
  const ProfilePhotoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Align(
          alignment: Alignment.center,
          child: Wrap(
            spacing: 12.0, // 칸 사이의 가로 간격
            runSpacing: 12.0, // 칸 사이의 세로 간격
            children: [
              _mainImage(),
              _subImage(context, true),
              _subImage(context, true),
              _subImage(context, true),
              _subImage(context, false),
              _subImage(context, false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mainImage() {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300], // 기본 배경색
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://picsum.photos/200/100',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('대표',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ],
    );
  }

  Widget _subImage(BuildContext context, bool hasImage) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://picsum.photos/200/100',
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Container(
                    width: 60, // 플러스 아이콘을 감쌀 원의 크기
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // 사진 추가 로직
                      },
                    ),
                  ),
                ),
        ),
        if (hasImage)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              child: Center(
                // 아이콘을 중앙에 배치
                child: IconButton(
                  padding: EdgeInsets.zero, // 패딩을 없애서 중앙에 맞춤
                  icon: Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.grey,
                  ), // 아이콘 크기 조정
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // 대표 이미지로 지정 로직
                                  Navigator.of(context).pop();
                                },
                                child: Text('대표이미지로 지정'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // 삭제 로직
                                  Navigator.of(context).pop();
                                },
                                child: Text('삭제'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
