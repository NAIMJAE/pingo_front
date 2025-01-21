import 'package:flutter/material.dart';
import 'package:pingo_font/models/keyword_model/keyword_cate.dart';

class KeywordPage extends StatefulWidget {
  const KeywordPage({super.key});

  @override
  State<KeywordPage> createState() => _KeywordPageState();
}

class _KeywordPageState extends State<KeywordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<KeywordCate> cateList = [];

  @override
  void initState() {
    super.initState();
    cateList = keywordCateList;
    _tabController = TabController(length: cateList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            padding: EdgeInsets.zero,
            controller: _tabController,
            tabs: [
              ...List.generate(
                cateList.length,
                (index) => _keywordTab(cateList[index].keywordCateName),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ...List.generate(
                  cateList.length,
                  (index) => _keywordTabView(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _keywordTab(text) {
    return Tab(
      child: Text(text, style: Theme.of(context).textTheme.headlineMedium),
    );
  }

  Widget _keywordTabView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          box(),
          box(),
          box(),
        ],
      ),
    );
  }

  Widget box() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
