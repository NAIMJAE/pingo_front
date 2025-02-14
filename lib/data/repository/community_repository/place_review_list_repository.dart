import 'package:pingo_front/data/models/community_model/place_review.dart';
import 'package:pingo_front/data/network/custom_dio.dart';

class PlaceReviewListRepository {
  final CustomDio _customDio = CustomDio.instance;

  Future<List<PlaceReview>> selectPlaceReview(
      int sortIndex, int cateIndex) async {
    try {
      dynamic response = await _customDio.get('/community/place');

      if (response is List) {
        return response.map((json) => PlaceReview.fromJson(json)).toList();
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print("Error fetching place reviews: $e");
      return [];
    }
  }
}
