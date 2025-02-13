import 'package:flutter/material.dart';
import 'components/profile_appbar.dart';
import 'components/profile_personal_information_box.dart';
import 'components/profile_self_introduction_box.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: ProfileAppBar(context),
        body: ListView(
          children: [
            const SizedBox(height: 8.0),
            ProfilePersonalInformationBox(),
            const SizedBox(height: 8.0),
            ProfileSelfIntroductionBox(),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
