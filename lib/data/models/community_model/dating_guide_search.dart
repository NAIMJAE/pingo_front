import 'package:pingo_front/data/models/community_model/dating_guide.dart';

class DatingGuideSearch {
  String? category;
  String? cateNo;
  int? sort;
  List<DatingGuide>? datingGuideList;

  @override
  String toString() {
    return 'DatingGuideSearch{category: $category, cateNo: $cateNo, sort: $sort, datingGuideList: $datingGuideList}';
  }

  DatingGuideSearch.formJson(Map<String, dynamic> json)
      : category = json['category'],
        sort = json['sort'],
        cateNo = json['cateNo'],
        datingGuideList = (json['datingGuideList'] as List<dynamic>?)
            ?.map(
                (child) => DatingGuide.fromJson(child as Map<String, dynamic>))
            .toList();
}
