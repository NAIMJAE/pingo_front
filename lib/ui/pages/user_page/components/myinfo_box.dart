import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'profile_page/profile_page.dart';

class MyinfoBox extends StatefulWidget {
  const MyinfoBox({super.key});

  @override
  _MyinfoBoxState createState() => _MyinfoBoxState();
}

class _MyinfoBoxState extends State<MyinfoBox> {
  String profileImageUrl = 'https://picsum.photos/200/100';
  String name = '이준석';
  String nickname = '이시로';
  String address = '부산광역시 연제구 토현로 10';

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
            _buildProfileRow(context),
            const SizedBox(height: 30),
            _buildProfileButton(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            SizedBox(
              width: 65,
              height: 65,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.5),
                child: Image.network(
                  profileImageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    profileImageUrl =
                        'https://picsum.photos/200/100?random=${DateTime.now().millisecondsSinceEpoch}';
                  });
                },
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.grey[100],
                  ),
                  child: const Icon(
                    CupertinoIcons.camera,
                    size: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(name, style: Theme.of(context).textTheme.headlineLarge),
                Text(' / ', style: Theme.of(context).textTheme.headlineLarge),
                Text(nickname,
                    style: Theme.of(context).textTheme.headlineLarge),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );

        if (result != null && result is Map<String, String>) {
          setState(() {
            name = result['name'] ?? name;
            nickname = result['nickname'] ?? nickname;
            address = result['address'] ?? address;
          });
        }
      },
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFD4D5DD),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Center(
          child: Text(
            '프로필',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
    );
  }
}
