import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/model_views/keyword_view_model/keyword_view_model.dart';

import '../../../_core/utils/logger.dart';
import '../../../data/models/keyword_model/keyword.dart';
import '../../../data/models/keyword_model/keyword_group.dart';

class KeywordPage extends ConsumerStatefulWidget {
  const KeywordPage({super.key});

  @override
  ConsumerState<KeywordPage> createState() => _KeywordPageState();
}

class _KeywordPageState extends ConsumerState<KeywordPage> {
  @override
  void initState() {
    super.initState();
    ref.read(KeywordViewModelProvider.notifier).fetchKeywords();
  }

  @override
  Widget build(BuildContext context) {
    final groupList = ref.watch(KeywordViewModelProvider);
    final kGNotifier = ref.read(KeywordViewModelProvider.notifier);

    return Scaffold(
      body: ListView(
        children: groupList.entries.map((entry) {
          final key = entry.key;
          final keywordGroup = entry.value;
          return _keywordBox(context, keywordGroup);
        }).toList(),
      ),
    );
  }

  // 키워드 그룹 List UI
  Widget _keywordBox(BuildContext buildContext, KeywordGroup keywordGroup) {
    List<Keyword> keywords = keywordGroup.childKeyword!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(keywordGroup.kwName!,
              style: Theme.of(buildContext).textTheme.displaySmall),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            cacheExtent: 2500,
            scrollDirection: Axis.horizontal,
            itemCount: keywords.length,
            itemBuilder: (context, index) {
              return _keywordCard(buildContext, keywords[index]);
            },
          ),
        ),
      ],
    );
  }

  // 개별 키워드 카드 UI
  Widget _keywordCard(BuildContext buildContext, Keyword keyword) {
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
                  style: Theme.of(buildContext)
                      .textTheme
                      .displaySmall!
                      .copyWith(color: Colors.white)),
              Text(
                keyword.kwMessage!,
                style: Theme.of(buildContext)
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
