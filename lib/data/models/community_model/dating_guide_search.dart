import 'package:pingo_front/data/models/community_model/dating_guide.dart';

class DatingGuideSearch {
  String? category;
  int? cateNo;
  String? sort;
  List<DatingGuide>? datingGuideList;

  void changeDatingGuideListBySort(List<DatingGuide> newList, String newSort) {
    sort = newSort;
    datingGuideList?.clear();
    datingGuideList?.addAll(newList);
  }

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
