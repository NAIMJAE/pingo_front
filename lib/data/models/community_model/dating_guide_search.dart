import 'package:pingo_front/data/models/community_model/dating_guide.dart';

class DatingGuideSearch {
  String? category;
  String? sort;
  List<DatingGuide>? datingGuideList;

  @override
  String toString() {
    return 'DatingGuideSearch{category: $category, sort: $sort, datingGuideList: $datingGuideList}';
  }
}
