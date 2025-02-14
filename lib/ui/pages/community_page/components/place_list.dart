import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/community_model/place_review.dart';
import 'package:pingo_front/data/models/community_model/place_review_search.dart';
import 'package:pingo_front/data/models/community_model/review_search_result.dart';
import 'package:pingo_front/data/view_models/community_view_model/place_review_search_view_model.dart';
import 'package:pingo_front/ui/pages/community_page/components/place_box.dart';
import 'package:pingo_front/ui/pages/community_page/components/place_write_page.dart';
import 'package:pingo_front/ui/widgets/custom_image.dart';

class PlaceList extends ConsumerStatefulWidget {
  final PlaceReviewSearch searchReviewState;
  final PlaceReviewSearchViewModel searchReviewProvider;
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
          child: searchList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '${widget.searchReviewProvider.lastSearch.keys.toString()}에 대한 리뷰가 없습니다.',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlaceWritePage()),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add),
                            Text('리뷰 작성'),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              : ListView.builder(
                  itemCount: searchList.length,
                  itemBuilder: (context, index) => PlaceBox(
                    placeReview: searchList[index],
                  ),
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
      onTap: () async {
        await widget.searchReviewProvider.changeCateSort(text);
        setState(() {});
      },
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
        onPressed: () async {
          await widget.searchReviewProvider.changeSearchSort(index);
          setState(() {});
        },
        child: Text(title, style: Theme.of(buildContext).textTheme.titleMedium),
      ),
    );
  }

  // Widget _placeBox(buildContext, PlaceReview placeReview) {
  //   double totalWidth = MediaQuery.of(buildContext).size.width;
  //
  //   return Container(
  //     padding: EdgeInsets.all(8),
  //     margin: EdgeInsets.only(bottom: 8.0),
  //     width: totalWidth * 0.9,
  //     height: totalWidth * 0.9 / 16 * 7,
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         image: CustomImage().provider(placeReview.thumb!),
  //         fit: BoxFit.cover,
  //       ),
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.2),
  //           offset: Offset(0, 2), // 방향
  //           blurRadius: 4, // 흐림 정도
  //           spreadRadius: 0, // 확산 정도
  //         ),
  //       ],
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: Colors.transparent,
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.end,
  //           children: [
  //             GestureDetector(
  //               onTap: () {},
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Icon(
  //                   Icons.thumb_up,
  //                   size: 20,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: () {},
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Icon(
  //                   Icons.ios_share_outlined,
  //                   size: 20,
  //                   color: Colors.white,
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               placeReview.placeName!,
  //               style: Theme.of(buildContext)
  //                   .textTheme
  //                   .headlineLarge
  //                   ?.copyWith(color: Colors.white),
  //             ),
  //             Text(
  //               placeReview.addressName!,
  //               style: Theme.of(buildContext)
  //                   .textTheme
  //                   .bodyLarge
  //                   ?.copyWith(color: Colors.white),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }
}
