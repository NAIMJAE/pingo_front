import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/models/community_model/kakao_search.dart';
import 'package:pingo_front/data/models/community_model/kakao_search_result.dart';
import 'package:pingo_front/data/models/community_model/place_review.dart';
import 'package:pingo_front/data/models/community_model/place_review_search.dart';
import 'package:pingo_front/data/models/community_model/review_search_result.dart';
import 'package:pingo_front/data/repository/community_repository/place_review_search_repository.dart';

class PlaceReviewSearchViewModel extends Notifier<PlaceReviewSearch> {
  final PlaceReviewSearchRepository _repository;
  KakaoSearch lastSearch = KakaoSearch();
  PlaceReviewSearchViewModel(this._repository);

  @override
  PlaceReviewSearch build() {
    placeReviewInit();
    return PlaceReviewSearch(KakaoSearchResult([]), ReviewSearchResult([]));
  }

  // init
  Future<void> placeReviewInit() async {
    PlaceReviewSearch initData =
        PlaceReviewSearch(KakaoSearchResult([]), ReviewSearchResult([]));

    dynamic response = await _repository.fetchSearchPlaceReview(
        cateSort: initData.reviewSearchResult.cateSort,
        searchSort: initData.reviewSearchResult.searchSort);

    logger.i(response);

    // 이 response는 PlaceReviewSearch의 reviewSearchResult의 List<PlaceReview>
    initData.reviewSearchResult.changePlaceReviewList(response);
    state = initData;
  }

  // 검색 정렬 기준 변경
  Future<void> changeSearchSort(newSort) async {
    state.reviewSearchResult.changeSearchSort(newSort);

    List<PlaceReview> response = await _repository.fetchSearchPlaceReview(
        cateSort: state.reviewSearchResult.cateSort, searchSort: newSort);

    state.reviewSearchResult.changePlaceReviewList(response);
  }

  // 검색 카테고리 기준 변경
  Future<void> changeCateSort(newSort) async {
    state.reviewSearchResult.changeCateSort(newSort);

    List<PlaceReview> response = await _repository.fetchSearchPlaceReview(
        cateSort: newSort, searchSort: state.reviewSearchResult.searchSort);

    state.reviewSearchResult.changePlaceReviewList(response);
  }

  // 검색창이 비었을 때 마지막 검색 기록으로 돌리기
  void searchLastPlaceReview() async {
    List<PlaceReview> response = await _repository.fetchSearchPlaceReview(
        cateSort: state.reviewSearchResult.cateSort,
        searchSort: state.reviewSearchResult.searchSort);

    state.reviewSearchResult.changePlaceReviewList(response);
  }

  // 검색으로 리뷰 조회
  Future<void> searchPlaceReviewWithKeyword(KakaoSearch kakaoSearch) async {
    List<PlaceReview> response = await _repository.fetchSearchPlaceReview(
        cateSort: state.reviewSearchResult.cateSort,
        searchSort: state.reviewSearchResult.searchSort,
        keyword: kakaoSearch.addressName);

    if (response.isEmpty) {
      lastSearch = kakaoSearch;
    }

    state.reviewSearchResult.changePlaceReviewList(response);
  }

  // placeReview 작성
  Future<bool> insertPlaceReview(Map<String, dynamic> data) async {
    return await _repository.fetchInsertPlaceReview(data);
  }

  /// 검색 ///
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

  // // 검색창 비었을 때 마지막 검색으로 갱신
  // void renewalSearchResult() {
  //   state.reviewSearchResult.changePlaceReviewList(lastSearch);
  // }
}

final placeReviewSearchViewModelProvider =
    NotifierProvider<PlaceReviewSearchViewModel, PlaceReviewSearch>(
  () => PlaceReviewSearchViewModel(PlaceReviewSearchRepository()),
);
