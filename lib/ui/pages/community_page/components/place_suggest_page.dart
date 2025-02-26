import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/view_models/community_view_model/place_review_search_view_model.dart';
import 'package:pingo_front/ui/pages/community_page/components/place_list.dart';
import 'package:pingo_front/ui/pages/community_page/components/place_search.dart';

class PlaceSuggestPage extends ConsumerStatefulWidget {
  const PlaceSuggestPage({super.key});

  @override
  ConsumerState<PlaceSuggestPage> createState() => _PlaceSuggestPageState();
}

class _PlaceSuggestPageState extends ConsumerState<PlaceSuggestPage>
    with AutomaticKeepAliveClientMixin<PlaceSuggestPage> {
  int _placeIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // 입력 감지 함수 (1초 동안 입력이 없으면 실행)
  void _onSearchChanged() async {
    _debounceTimer?.cancel(); // 기존 타이머 취소

    _debounceTimer = Timer(Duration(seconds: 1), () {
      String query = _searchController.text.trim();

      if (query.isNotEmpty) {
        print("자동 검색 실행: $query");

        ref
            .read(placeReviewSearchViewModelProvider.notifier)
            .kakaoPlaceSearchApi(query, 1)
            .then((_) {
          setState(() {
            _placeIndex = 1;
          });
        });
      } else {
        _onSearchCleared();
      }
    });
  }

  // 검색창이 비었을 때 실행할 함수
  void _onSearchCleared() {
    setState(() {
      _placeIndex = 0;
      ref
          .read(placeReviewSearchViewModelProvider.notifier)
          .searchLastPlaceReview();
      FocusScope.of(context).unfocus();
    });
  }

  // place suggest 내의 index 변경 함수
  void changePlaceIndex(int newIndex) {
    if (newIndex < 0 || newIndex >= 2) return;
    setState(() {
      _placeIndex = newIndex;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext buildContext) {
    final searchReviewState = ref.watch(placeReviewSearchViewModelProvider);
    final searchReviewProvider =
        ref.read(placeReviewSearchViewModelProvider.notifier);

    super.build(buildContext);
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // search
              _placeSearchBox(),
              Expanded(
                child: IndexedStack(
                  index: _placeIndex,
                  children: [
                    PlaceList(searchReviewState, searchReviewProvider),
                    PlaceSearch(searchReviewState, searchReviewProvider,
                        _onSearchCleared),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _placeSearchBox() {
    return TextField(
      controller: _searchController,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: "장소 검색",
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(Icons.search, color: Colors.grey, size: 24),
        filled: true,
        fillColor: Colors.black12,
        contentPadding: const EdgeInsets.symmetric(vertical: 6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: Colors.black12, width: 0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: Colors.black12, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: Colors.black12, width: 0),
        ),
      ),
    );
  }
}
