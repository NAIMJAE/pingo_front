class Keyword {
  String? kwId;
  String? kwName;
  String? kwParentId;
  String? kwMessage;
  String? kwLevel;

  Keyword(
      {required this.kwId,
      required this.kwName,
      required this.kwParentId,
      required this.kwMessage,
      required this.kwLevel});

  Keyword.fromJson(Map<String, dynamic> json)
      : kwId = json['kwId'],
        kwName = json['kwName'],
        kwParentId = json['kwParentId'],
        kwMessage = json['kwMessage'],
        kwLevel = json['kwLevel'];
}
