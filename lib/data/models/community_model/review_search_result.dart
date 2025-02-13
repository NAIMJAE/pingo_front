import 'package:pingo_front/data/models/community_model/place_review.dart';

class ReviewSearchResult {
  String? searchSort = 'popular';
  String? cateSort = '음식점';
  List<PlaceReview> placeReviewList;

  ReviewSearchResult(this.placeReviewList);

  @override
  String toString() {
    return 'ReviewSearchResult{searchSort: $searchSort, cateSort: $cateSort, placeReviewList: $placeReviewList}';
  }

  // 검색 결과 덮어쓰기
  void changePlaceReviewList(List<PlaceReview> newList) {
    placeReviewList.clear();
    placeReviewList.addAll(newList);
  }

  // SROT 변경
  void changeSearchSort(String? newSort) {
    searchSort = newSort;
  }

  // SROT 변경
  void changeCateSort(String? newSort) {
    cateSort = newSort;
  }
}
