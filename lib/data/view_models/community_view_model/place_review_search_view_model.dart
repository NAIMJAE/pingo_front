import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/community_model/kakao_search.dart';
import 'package:pingo_front/data/models/community_model/kakao_search_result.dart';
import 'package:pingo_front/data/models/community_model/place_review_search.dart';
import 'package:pingo_front/data/models/community_model/review_search_result.dart';
import 'package:pingo_front/data/repository/community_repository/place_review_search_repository.dart';

class PlaceReviewSearchViewModel extends Notifier<PlaceReviewSearch> {
  final PlaceReviewSearchRepository _repository;
  PlaceReviewSearchViewModel(this._repository);

  @override
  PlaceReviewSearch build() {
    state = PlaceReviewSearch(KakaoSearchResult([]), ReviewSearchResult([]));
    placeReviewInit();
    return state;
  }

  // init
  Future<ReviewSearchResult> placeReviewInit() async {
    ReviewSearchResult initData = ReviewSearchResult([]);

    dynamic response = await _repository.fetchSearchPlaceReview();

    // 이 response는 PlaceReviewSearch의 reviewSearchResult의 List<PlaceReview>
    initData.changePlaceReviewList(response);
    return initData;
  }

  // sort 변경
  void changeSearchSort(newSort) {
    state.reviewSearchResult.changeSearchSort(newSort);
  }

  void changeCateSort(newSort) {
    state.reviewSearchResult.changeCateSort(newSort);
  }

  // kakao search - 카카오 API 주소 검색
  Future<void> kakaoPlaceSearchApi(String keyword, int page) async {
    Map<String, dynamic> result =
        await _repository.fetchSearchKaKaoLocation(keyword, page: page);

    List<KakaoSearch> newList = (result['documents'] as List<dynamic>)
        .map((json) => KakaoSearch.fromJson(json))
        .toList();

    replaceKakaoSearchResultList(newList);
  }

  // 카카오 주소 검색 갱신
  void replaceKakaoSearchResultList(List<KakaoSearch> newList) {
    state =
        PlaceReviewSearch(KakaoSearchResult(newList), state.reviewSearchResult);
  }
}

final placeReviewSearchViewModelProvider =
    NotifierProvider<PlaceReviewSearchViewModel, PlaceReviewSearch>(
  () => PlaceReviewSearchViewModel(PlaceReviewSearchRepository()),
);
