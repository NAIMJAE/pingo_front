import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/ui/pages/community_page/components/dating_guide_write_page.dart';

class DatingGuidePage extends ConsumerStatefulWidget {
  const DatingGuidePage({super.key});

  @override
  ConsumerState<DatingGuidePage> createState() => _DatingGuidePageState();
}

class _DatingGuidePageState extends ConsumerState<DatingGuidePage> {
  late final String sessionUserNo;

  @override
  void initState() {
    super.initState();
    sessionUserNo = ref.read(sessionProvider).userNo!;
  }

  @override
  Widget build(BuildContext context) {
    double cntWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 282,
                child: guideGroup(cntWidth),
              ),
              SizedBox(
                height: 282,
                child: guideGroup(cntWidth),
              ),
              SizedBox(
                height: 282,
                child: guideGroup(cntWidth),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DatingGuideWritePage(sessionUserNo),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget guideGroup(double cntWidth) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 16.0, bottom: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '연락 가이드?',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      print('인기');
                    },
                    child: Text(
                      '인기순',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      print('인기');
                    },
                    child: Text('최신순'),
                  ),
                ],
              )
            ],
          ),
        ),
        Expanded(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              guideBox(cntWidth),
              guideBox(cntWidth),
              guideBox(cntWidth),
              guideBox(cntWidth),
            ],
          ),
        ),
      ],
    );
  }

  Widget guideBox(double cntWidth) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: cntWidth * 6 / 10,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                width: cntWidth * 6 / 10,
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/sample/bb0003.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('먼저 연락하는 방법',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/images/sample/bb0003.jpg')),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('맹구',
                              style: Theme.of(context).textTheme.headlineSmall),
                        ],
                      ),
                      Icon(Icons.recommend_outlined),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
