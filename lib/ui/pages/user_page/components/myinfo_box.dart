import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/user_model/user_image.dart';
import 'package:pingo_front/data/models/user_model/user_mypage_info.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class MyinfoBox extends ConsumerStatefulWidget {
  UserMypageInfo userMypageInfo;
  MyinfoBox(this.userMypageInfo, {super.key});

  @override
  ConsumerState<MyinfoBox> createState() => _MyinfoBoxState();
}

class _MyinfoBoxState extends ConsumerState<MyinfoBox> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            _buildProfileRow(context, widget.userMypageInfo),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(BuildContext context, userMypageInfo) {
    List<UserImage> userImages = widget.userMypageInfo.userImageList ?? [];

    UserImage? mainImage;

    for (var userImage in userImages) {
      if (userImage.imageProfile == 'T') {
        mainImage = userImage;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(90),
            child: CustomImage().token(mainImage?.imageUrl ?? ''),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(userMypageInfo.users.userName,
                    style: Theme.of(context).textTheme.headlineLarge),
                Text(
                  ' | ',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(color: Colors.grey),
                ),
                Text(userMypageInfo.users.userNick,
                    style: Theme.of(context).textTheme.headlineLarge),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              userMypageInfo.userInfo.userAddress,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(userMypageInfo.userInfo.user1stJob,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('ㆍ', style: Theme.of(context).textTheme.headlineLarge),
                Text(userMypageInfo.userInfo.user2ndJob,
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              userMypageInfo.userInfo.userBirth.toString().split(' ')[0],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                    userMypageInfo.userInfo.userHeight.toString() +
                        'cm', // 정수형을 문자열로 변환하여 출력
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('ㆍ', style: Theme.of(context).textTheme.headlineLarge),
                Text(userMypageInfo.userInfo.userReligion,
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('ㆍ', style: Theme.of(context).textTheme.headlineLarge),
                Text(userMypageInfo.userInfo.userBloodType + '형',
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                _buildUserDrinkingParse(userMypageInfo.userInfo.userDrinking),
                Text('ㆍ', style: Theme.of(context).textTheme.headlineLarge),
                _buildUserSmokingParse(userMypageInfo.userInfo.userSmoking),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserDrinkingParse(drinking) {
    switch (drinking) {
      case 'N':
        return Text('비음주', style: Theme.of(context).textTheme.bodyLarge);
      case 'O':
        return Text('가끔 음주', style: Theme.of(context).textTheme.bodyLarge);
      case 'F':
        return Text('잦은 음주', style: Theme.of(context).textTheme.bodyLarge);
      default:
        return Text('', style: Theme.of(context).textTheme.bodyLarge);
    }
  }

  Widget _buildUserSmokingParse(smoking) {
    switch (smoking) {
      case 'F':
        return Text('비흡연', style: Theme.of(context).textTheme.bodyLarge);
      case 'T':
        return Text('흡연', style: Theme.of(context).textTheme.bodyLarge);
      default:
        return Text('', style: Theme.of(context).textTheme.bodyLarge);
    }
  }
}
