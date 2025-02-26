class Membership {
  String? msNo;
  String? title;
  int? period;
  String? contents;
  int? price;

  Membership(this.msNo, this.title, this.period, this.contents, this.price);

  Membership.fromJson(Map<String, dynamic> json)
      : msNo = json['msNo'],
        title = json['title'],
        period = json['period'],
        contents = json['contents'],
        price = json['price'];
}
