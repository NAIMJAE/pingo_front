class Membership {
  String? msNo;
  String? title;
  int? period;
  String? contents;

  Membership(this.msNo, this.title, this.period, this.contents);

  @override
  String toString() {
    return 'Membership{msNo: $msNo, title: $title, period: $period, contents: $contents}';
  }

  Membership.fromJson(Map<String, dynamic> json)
      : msNo = json['msNo'],
        title = json['title'],
        period = json['period'],
        contents = json['contents'];
}
