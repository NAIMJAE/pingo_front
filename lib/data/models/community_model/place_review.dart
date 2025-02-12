class PlaceReview {
  String? prNo;
  String? placeName;
  String? thumb;
  String? addressName;
  String? roadAddressName;
  String? userNo;
  String? contents;
  String? category;
  double? latitude;
  double? longitude;
  int? heart;

  PlaceReview(
      this.prNo,
      this.placeName,
      this.thumb,
      this.addressName,
      this.roadAddressName,
      this.userNo,
      this.contents,
      this.category,
      this.latitude,
      this.longitude,
      this.heart);

  PlaceReview.fromJson(Map<String, dynamic> json)
      : prNo = json['prNo'],
        placeName = json['placeName'],
        thumb = json['thumb'],
        addressName = json['addressName'],
        roadAddressName = json['roadAddressName'],
        userNo = json['userNo'],
        contents = json['contents'],
        category = json['category'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        heart = json['heart'];
}
