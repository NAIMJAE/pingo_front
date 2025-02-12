import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/community_model/place_review.dart';
import 'package:pingo_front/data/models/community_model/place_review_search.dart';
import 'package:pingo_front/data/models/community_model/review_search_result.dart';
import 'package:pingo_front/data/view_models/community_view_model/place_review_search_view_model.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class PlaceList extends ConsumerStatefulWidget {
  final PlaceReviewSearch searchReviewState;
  final dynamic searchReviewProvider;
  const PlaceList(this.searchReviewState, this.searchReviewProvider,
      {super.key});

  @override
  ConsumerState<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends ConsumerState<PlaceList> {
  @override
  Widget build(BuildContext buildContext) {
    ReviewSearchResult searchResult =
        widget.searchReviewState.reviewSearchResult;

    List<PlaceReview> searchList =
        widget.searchReviewState.reviewSearchResult.placeReviewList;

    return Column(
      children: [
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...List.generate(
                kakaoCategory.length,
                (index) {
                  var key = kakaoCategory.keys.toList()[index];
                  var value = kakaoCategory[key];

                  return _placeCateBox(
                      buildContext, key, value, searchResult.cateSort);
                },
              )
            ],
          ),
        ),
        // sort
        Row(
          children: [
            _placeSortBtn(
                buildContext, '인기순', 'popular', searchResult.searchSort),
            _placeSortBtn(
                buildContext, '최신순', 'newest', searchResult.searchSort),
            _placeSortBtn(
                buildContext, '거리순', 'location', searchResult.searchSort),
          ],
        ),
        Expanded(
          child: ListView(
            children: [
              _placeBox(buildContext),
              _placeBox(buildContext),
              _placeBox(buildContext),
              _placeBox(buildContext),
              _placeBox(buildContext),
            ],
          ),
        ),
      ],
    );
  }

  Widget _placeCateBox(buildContext, text, icon, cateIndex) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: cateIndex == text ? Colors.red : Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              text,
              style: Theme.of(buildContext).textTheme.titleLarge?.copyWith(
                    color: cateIndex == text ? Colors.red : Colors.black,
                  ),
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          print('cateIndex : $cateIndex');
          print('cateIndex : $text');
          widget.searchReviewProvider.changeSearchSort(text); // 여기서 상태관리가 꼬임
        });
      },
    );
  }

  Widget _placeCateBtn(buildContext, title, index, cateIndex) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: const Size(0, 0),
            backgroundColor: cateIndex == index ? Colors.red : Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            )),
        onPressed: () {
          setState(() {
            widget.searchReviewProvider.changeCateSort(index);
          });
        },
        child: Text(title, style: Theme.of(buildContext).textTheme.titleMedium),
      ),
    );
  }

  Widget _placeSortBtn(buildContext, title, index, sortIndex) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: const Size(0, 0),
          backgroundColor: sortIndex == index ? Colors.red : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          setState(() {
            widget.searchReviewProvider.changeCateSort(index);
          });
        },
        child: Text(title, style: Theme.of(buildContext).textTheme.titleMedium),
      ),
    );
  }

  Widget _placeBox(buildContext) {
    double totalWidth = MediaQuery.of(buildContext).size.width;

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8.0),
      width: totalWidth * 0.9,
      height: totalWidth * 0.9 / 16 * 7,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CustomImage().provider('/images/userImages/UI6126683a.jpg'),
          fit: BoxFit.cover,
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 2), // 방향
            blurRadius: 4, // 흐림 정도
            spreadRadius: 0, // 확산 정도
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.transparent,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.thumb_up,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.ios_share_outlined,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '스타벅스 서면점',
                style: Theme.of(buildContext)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.white),
              ),
              Text(
                '부산광역시 부산진구 중앙대로 672 (부전동) 1층 2층',
                style: Theme.of(buildContext)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
