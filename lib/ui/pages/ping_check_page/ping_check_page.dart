import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/global_model/session_user.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';
import 'package:pingo_front/data/view_models/ping_check_view_model/ping_check_view_model.dart';
import 'package:pingo_front/data/view_models/sign_view_model/signin_view_model.dart';
import 'package:pingo_front/ui/pages/keyword_page/keyword_page.dart';
import 'package:pingo_front/ui/pages/ping_check_page/ping_detail_page.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class PingCheckPage extends ConsumerStatefulWidget {
  const PingCheckPage({super.key});

  @override
  ConsumerState<PingCheckPage> createState() => _PingCheckPageState();
}

class _PingCheckPageState extends ConsumerState<PingCheckPage> {
  bool isMembership = false;

  @override
  Widget build(BuildContext buildContext) {
    double cntWidth = MediaQuery.of(context).size.width;

    Map<String, List<Profile>> pingUsers =
        ref.watch(pingCheckViewModelProvider);

    SessionUser sessionUser = ref.watch(sessionProvider);
    if (sessionUser.expDate != null) {
      isMembership = sessionUser.expDate!.isAfter(DateTime.now());
    }

    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.supervisor_account_outlined),
                    const SizedBox(width: 12),
                    Text(
                      '내가 받은 슈퍼핑 볼 수 있습니다~',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                _superPingBox(
                    cntWidth: cntWidth, users: pingUsers['super'] ?? []),
                Row(
                  children: [
                    Icon(Icons.security_outlined),
                    const SizedBox(width: 12),
                    Text(
                      '내가 받은 핑을 볼 수 있습니다. \n 모두 확인하려면 유료 결제 하쇼',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                _pingBox(cntWidth: cntWidth, users: pingUsers['ping'] ?? []),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _superPingBox(
      {required double cntWidth, required List<Profile> users}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        height: cntWidth * 0.55,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: users.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return _superUser(cntWidth: cntWidth, user: users[index]);
          },
        ),
      ),
    );
  }

  Widget _pingBox({required double cntWidth, required List<Profile> users}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          ...List.generate(
            users.length,
            (index) => normalUser(cntWidth: cntWidth, user: users[index]),
          )
        ],
      ),
    );
  }

  Widget _superUser({required double cntWidth, required Profile user}) {
    return Container(
      width: cntWidth * 0.7,
      height: cntWidth * 0.55,
      margin: EdgeInsets.only(right: 16, bottom: 16),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PingDetailPage(
                    user: user,
                    type: 'super',
                  ),
                ),
              );
            },
            child: Container(
              width: cntWidth * 0.7,
              height: cntWidth * 0.55,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: CustomImage().provider(user.ImageList[0]),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(1.0),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 12,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  user.age,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 18,
            left: 8,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SUPER PING',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget normalUser({required double cntWidth, required Profile user}) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PingDetailPage(
                  user: user,
                  type: 'ping',
                ),
              ),
            );
          },
          child: Container(
            width: cntWidth / 2 - 24,
            height: cntWidth * 0.55,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: CustomImage().provider(user.ImageList[0]),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(1.0), // 아래
                  Colors.black.withOpacity(0.7), // 중간
                  Colors.black.withOpacity(0.0), // 위
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 12,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
              const SizedBox(width: 8),
              Text(
                user.age,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
              ),
            ],
          ),
        ),
        if (!isMembership)
          Positioned(
            top: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 블러 강도 조절
                child: Container(
                  width: cntWidth / 2 - 24,
                  height: cntWidth * 0.55,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 100,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.black54.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
