import 'package:flutter/material.dart';
import 'package:pingo_font/models/keyword_model/keyword_category.dart';
import 'package:pingo_font/models/keyword_model/keyword_group.dart';

class KeywordPage extends StatefulWidget {
  const KeywordPage({super.key});

  @override
  State<KeywordPage> createState() => _KeywordPageState();
}

class _KeywordPageState extends State<KeywordPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<KeywordCategory> categoryList = [];
  List<KeywordGroup> groupList = [];

  @override
  void initState() {
    super.initState();
    categoryList = kCategoryList;
    groupList = KGroupList;
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
              style: Theme.of(context).textTheme.displayMedium),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                filteredList.length,
                (index) => _keywordCard(filteredList[index]),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _keywordCard(KeywordGroup kGroup) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(20),
        color: Colors.deepPurpleAccent,
      ),
      child: Column(
        children: [
          Text(kGroup.kGroupName,
              style: Theme.of(context).textTheme.displaySmall)
        ],
      ),
    );
  }
}
