class Keyword {
  String keywordNo;
  String keywordName;
  String keywordCateNo;

  Keyword(
      {required this.keywordNo,
      required this.keywordName,
      required this.keywordCateNo});

  @override
  String toString() {
    return 'keyword{keywordNo: $keywordNo, keywordName: $keywordName, keywordCate: $keywordCateNo}';
  }
}

List<Keyword> keywordList = [
  Keyword(keywordNo: 'ky100', keywordName: '외향적', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky101', keywordName: '활발함', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky102', keywordName: '모험적', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky103', keywordName: '낙천적', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky104', keywordName: '친화력', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky105', keywordName: '열정적', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky106', keywordName: '유머러스함', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky107', keywordName: '자신감', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky108', keywordName: '긍정적', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky109', keywordName: '호기심', keywordCateNo: 'kc11'),
  Keyword(keywordNo: 'ky110', keywordName: '리더십', keywordCateNo: 'kc11'),
];
