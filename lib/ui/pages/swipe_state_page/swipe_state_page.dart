import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/model_views/swipe_state_view_model/swipe_state_view_model.dart';
import 'package:pingo_front/data/models/root_url.dart';
import 'package:pingo_front/data/models/swipe_state_model/user_swipe_details.dart';

// swipes 테이블에서 내가 스와이프한 유저, 나를 스와이프한 유저 조회

// 내가 swipe 한 유저
// SELECT * FROM "swipes" JOIN "users" ON "swipes.toUser" = "users.userNo"
// JOIN "userImages" ON "users.userNo" = "userImages.userNo"
// WHERE "swipes.fromUser" = "사용자" AND "swipeState" = "wait" AND "imageProfile" = "T"

// 내가 swipe 당한 유저
// SELECT * FROM "swipes" JOIN "users" ON "swipes.fromUser" = "users.userNo"
// JOIN "userImages" ON "users.userNo" = "userImages.userNo"
// WHERE "swipes.toUser" = "사용자" AND "swipeState" = "wait" AND "imageProfile" = "T"

// MAP<String, List<>>
// "Get swiped" : [{userNo, userAge, userName, userImage, }]

// "Swipe" :

class SwipeStatePage extends ConsumerStatefulWidget {
  const SwipeStatePage({super.key});

  @override
  ConsumerState<SwipeStatePage> createState() => _MatchStatePageState();
}

class _MatchStatePageState extends ConsumerState<SwipeStatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    ref.read(SwipeStateProvider.notifier).fetchSwipeState();
  }

  @override
  Widget build(BuildContext buildContext) {
    final userSwipeDetailMap = ref.watch(SwipeStateProvider);
    final usdNotifier = ref.read(SwipeStateProvider.notifier);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text('내가 보낸 핑?',
                      style: Theme.of(buildContext).textTheme.headlineMedium),
                ),
                Tab(
                  child: Text('내가 받은 핑?',
                      style: Theme.of(buildContext).textTheme.headlineMedium),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _eachStateTabView(
                      buildContext, userSwipeDetailMap['mySwipe']!),
                  _eachStateTabView(
                      buildContext, userSwipeDetailMap['getSwipe']!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eachStateTabView(
      BuildContext buildContext, List<UserSwipeDetails> swipeDetailList) {
    final double width = MediaQuery.of(context).size.width;
    final double cardWidth = ((width - 32) / 2) - 8;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        spacing: 12.0,
        runSpacing: 12.0,
        children: [
          ...List.generate(swipeDetailList.length,
              (index) => _userInfoCard(cardWidth, swipeDetailList[index]))
        ],
      ),
    );
  }

  Widget _userInfoCard(cardWidth, UserSwipeDetails swipeDetail) {
    return Container(
      padding: EdgeInsets.all(12.0),
      width: cardWidth,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
        image: DecorationImage(
          image: NetworkImage('$rootURL/uploads${swipeDetail.imageUrl}'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            swipeDetail.userName!,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '나이는 userInfo에서',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
