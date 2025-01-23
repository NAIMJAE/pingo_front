import 'package:flutter/material.dart';
import 'package:pingo_front/commons/utils/logger.dart';
import 'package:pingo_front/models/keyword_model/keyword_category.dart';
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

    _tabController = TabController(length: categoryList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ...List.generate(
            categoryList.length,
            (index) => _keywordBox(categoryList[index], groupList),
          )
        ],
      ),
    );
  }

  Widget _keywordBox(KeywordCategory kCategory, List<KeywordGroup> groupList) {
    List<KeywordGroup> filteredList = groupList
        .where((group) => group.kCategoryId == kCategory.kCategoryId)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(kCategory.kCategoryName,
              style: Theme.of(context).textTheme.displaySmall),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            cacheExtent: 2500,
            scrollDirection: Axis.horizontal,
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              return _keywordCard(filteredList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _keywordCard(KeywordGroup kGroup) {
    return GestureDetector(
      onTap: () {
        logger.d('${kGroup.kGroupName} CLICK!');
      },
      child: Container(
        margin: EdgeInsets.only(left: 16.0, bottom: 8.0),
        width: 340,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(20),
          image: DecorationImage(
              image: AssetImage(
                  'assets/images/keyword_page/${kGroup.kGroupId}.jpg'),
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
              Text(kGroup.kGroupName,
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.white)),
              Text(
                kGroup.kGroupMessage,
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
