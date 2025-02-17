import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/ui/pages/community_page/components/dating_guide_page.dart';
import 'package:pingo_front/ui/pages/community_page/components/place_suggest_page.dart';
import 'package:pingo_front/ui/pages/community_page/components/user_recommend_page.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(buildContext, "장소추천", 0),
                _buildTabButton(buildContext, "가이드", 1),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: const [
                PlaceSuggestPage(),
                DatingGuidePage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(buildContext, String text, int index) {
    double width = MediaQuery.of(buildContext).size.width;
    return SizedBox(
      width: width / 2 - 6,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.all(8),
          child: Text(
            text,
            style: Theme.of(buildContext).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _currentIndex == index ? Colors.red : Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
