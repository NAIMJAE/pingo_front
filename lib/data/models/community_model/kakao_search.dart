class KakaoSearch {
  String? placeName;
  String? addressName;
  String? roadAddressName;
  String? category;
  double? latitude; // 위도
  double? longitude; // 경도

  KakaoSearch.fromJson(Map<String, dynamic> json)
      : placeName = json['place_name'],
        addressName = json['address_name'],
        roadAddressName = json['road_address_name'],
        category = json['category_group_name'],
        latitude = double.parse(json['x']),
        longitude = double.parse(json['y']);
}
