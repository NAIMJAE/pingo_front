import 'package:flutter/material.dart';
import 'package:pingo_front/commons/utils/logger.dart';
import 'package:pingo_front/models/keyword_model/keyword.dart';
import 'package:pingo_front/models/keyword_model/keyword_group.dart';

class KeywordPage extends StatefulWidget {
  const KeywordPage({super.key});

  @override
  State<KeywordPage> createState() => _KeywordPageState();
}

class _KeywordPageState extends State<KeywordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<KeywordGroup> groupList = [];

  @override
  void initState() {
    super.initState();

    groupList = [
      KeywordGroup(kwId: 'kc01', kwName: '성격', kwMessage: null, childKeyword: [
        Keyword(
            kwId: 'cg11',
            kwName: '외향',
            kwParentId: 'kc01',
            kwMessage: '외향적인 사람'),
        Keyword(
            kwId: 'cg12',
            kwName: '내향',
            kwParentId: 'kc01',
            kwMessage: '내향적인 사람'),
        Keyword(
            kwId: 'cg13',
            kwName: '분석',
            kwParentId: 'kc01',
            kwMessage: '분석적인 사람')
      ]),
    ];
    _tabController = TabController(length: groupList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ...List.generate(
            groupList.length,
            (index) => _keywordBox(groupList[index]),
          )
        ],
      ),
    );
  }

  Widget _keywordBox(KeywordGroup keywordGroup) {
    List<Keyword> keywords = keywordGroup.childKeyword!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(keywordGroup.kwName!,
              style: Theme.of(context).textTheme.displaySmall),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            cacheExtent: 2500,
            scrollDirection: Axis.horizontal,
            itemCount: keywords.length,
            itemBuilder: (context, index) {
              return _keywordCard(keywords[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _keywordCard(Keyword keyword) {
    return GestureDetector(
      onTap: () {
        logger.d('${keyword.kwName} CLICK!');
      },
      child: Container(
        margin: EdgeInsets.only(left: 16.0, bottom: 8.0),
        width: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(20),
          image: DecorationImage(
              image:
                  AssetImage('assets/images/keyword_page/${keyword.kwId}.jpg'),
              fit: BoxFit.cover),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(20),
            color: Color.fromRGBO(125, 125, 125, 0.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(keyword.kwName!,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.white)),
              Text(
                keyword.kwMessage!,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
