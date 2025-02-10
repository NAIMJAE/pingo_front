import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/repository/root_url.dart';
import 'package:pingo_front/ui/pages/community_page/components/place_write_page.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class PlaceSuggestPage extends ConsumerStatefulWidget {
  const PlaceSuggestPage({super.key});

  @override
  ConsumerState<PlaceSuggestPage> createState() => _PlaceSuggestPageState();
}

class _PlaceSuggestPageState extends ConsumerState<PlaceSuggestPage>
    with AutomaticKeepAliveClientMixin<PlaceSuggestPage> {
  int _sortIndex = 0;

  void selectPlaceListWithSort(int sortIndex) {
    setState(() {
      _sortIndex = sortIndex;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext buildContext) {
    super.build(buildContext);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Row(
                children: [
                  _placeSortBtn(buildContext, '인기순', 0),
                  _placeSortBtn(buildContext, '거리순', 1),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    _placeBox(),
                  ],
                ),
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
                buildContext,
                MaterialPageRoute(
                  builder: (context) => const PlaceWritePage(),
                ),
              );
            },
            backgroundColor: Colors.red,
            child: const Icon(Icons.add, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _placeSortBtn(buildContext, title, index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: _sortIndex == index ? Colors.red : Colors.grey),
      onPressed: () {
        selectPlaceListWithSort(index);
      },
      child: Text(title, style: Theme.of(buildContext).textTheme.headlineSmall),
    );
  }

  Widget _placeBox() {
    return Container(
      padding: EdgeInsets.all(10),
      width: 200,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusDirectional.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: CustomImage().token('/images/userImages/UI12345678.jpg'),
          ),
          Column(
            children: [
              Text('상호'),
              Text('위치'),
              Text('내용'),
            ],
          )
        ],
      ),
    );
  }
}
