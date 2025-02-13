import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/user_model/user_image.dart';
import 'package:pingo_front/data/view_models/user_view_model/user_view_model.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class ProfilePhotoBox extends ConsumerStatefulWidget {
  final List<UserImage>? userImageList;

  ProfilePhotoBox(this.userImageList, {super.key});

  @override
  ConsumerState<ProfilePhotoBox> createState() => _ProfilePhotoBoxState();
}

class _ProfilePhotoBoxState extends ConsumerState<ProfilePhotoBox> {
  void _toggleImage(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    List<UserImage> images = widget.userImageList ?? [];

    // 대표 이미지와 일반 이미지 분리
    UserImage? mainImage;
    List<UserImage> subImages = [];

    for (var image in images) {
      if (image.imageProfile == 'T') {
        mainImage = image;
      } else {
        subImages.add(image);
      }
    }

    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Wrap(
          spacing: 4.0,
          runSpacing: 4.0,
          children: [
            _buildMainImage(totalWidth, mainImage),
            for (int i = 0; i < 5; i++)
              _buildSubImage(context, i,
                  i < subImages.length ? subImages[i] : null, totalWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildMainImage(double totalWidth, userImage) {
    return Stack(
      children: [
        Container(
          width: totalWidth / 3 - 6,
          height: (totalWidth / 3 - 6) / 3 * 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: userImage != null
              ? ClipRRect(
                  child: CustomImage().token(userImage.imageUrl),
                )
              : Center(
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
        ),
        Positioned(
          top: 4,
          left: 4,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              //border: Border.all(color: Colors.black, width: 1.0),
            ),
            child: Center(
              child: Icon(
                Icons.star_rounded,
                color: Colors.yellow,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubImage(
      BuildContext context, index, userImage, double totalWidth) {
    return Stack(
      children: [
        Container(
          width: totalWidth / 3 - 6,
          height: (totalWidth / 3 - 6) / 3 * 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
          ),
          child: userImage != null
              ? ClipRRect(
                  child: CustomImage().token(userImage.imageUrl),
                )
              : Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        ref
                            .read(userViewModelProvider.notifier)
                            .addUserImage(context);
                      },
                    ),
                  ),
                ),
        ),
        if (userImage != null)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                //border: Border.all(color: Colors.black, width: 1.0),
              ),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    CupertinoIcons.ellipsis,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  if (userImage != null) {
                                    final userViewModel = ref
                                        .read(userViewModelProvider.notifier);

                                    // 현재 대표 이미지 찾기
                                    String? currentMainImageNo = widget
                                        .userImageList
                                        ?.firstWhere(
                                            (img) => img.imageProfile == 'T',
                                            orElse: () => UserImage())
                                        .imageNo;

                                    // 대표 이미지로 설정할 이미지 찾기
                                    String? newMainImageNo = userImage.imageNo;

                                    if (currentMainImageNo != null &&
                                        newMainImageNo != null) {
                                      logger.d(
                                          "대표 이미지 변경 요청: $currentMainImageNo → $newMainImageNo");
                                      await userViewModel.setMainImage(
                                        currentMainImageNo,
                                        newMainImageNo,
                                        context,
                                      );
                                    }
                                  }

                                  Navigator.of(context).pop(); // 다이얼로그 닫기
                                },
                                child: Text('대표이미지로 지정'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _toggleImage(index);
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
