class Keyword {
  String keywordId;
  String keywordName;
  String kGroupId;

  Keyword(
      {required this.keywordId,
      required this.keywordName,
      required this.kGroupId});

  @override
  String toString() {
    return 'keyword{keywordId: $keywordId, keywordName: $keywordName, kGroupId: $kGroupId}';
  }
}
