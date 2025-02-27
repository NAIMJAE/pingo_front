import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/view_models/community_view_model/place_review_search_view_model.dart';

class PlaceMap extends ConsumerStatefulWidget {
  const PlaceMap({super.key});

  @override
  ConsumerState<PlaceMap> createState() => _PlaceMapState();
}

class _PlaceMapState extends ConsumerState<PlaceMap> {
  @override
  void initState() {
    super.initState();
    ref.read(placeReviewSearchViewModelProvider.notifier).searchPlaceForChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '장소',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            children: [
              Text('data'),
            ],
          ),
        ),
      ),
    );
  }
}
