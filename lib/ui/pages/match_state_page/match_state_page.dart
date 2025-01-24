import 'package:flutter/material.dart';

class MatchStatePage extends StatefulWidget {
  const MatchStatePage({super.key});

  @override
  State<MatchStatePage> createState() => _MatchStatePageState();
}

class _MatchStatePageState extends State<MatchStatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext buildContext) {
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
                  _eachStateTabView(),
                  _eachStateTabView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eachStateTabView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        direction: Axis.horizontal,
        spacing: 12.0,
        runSpacing: 12.0,
        children: [...List.generate(4, (index) => _userInfoCard())],
      ),
    );
  }

  Widget _userInfoCard() {
    return Container(
      padding: EdgeInsets.all(12.0),
      width: 180,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
        image: DecorationImage(
          image: NetworkImage('https://picsum.photos/250/250'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('홍길동'),
          Text('27세'),
        ],
      ),
    );
  }
}
