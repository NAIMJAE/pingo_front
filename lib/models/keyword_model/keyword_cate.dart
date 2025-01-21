class KeywordCate {
  String keywordCateNo;
  String keywordCateName;

  KeywordCate({required this.keywordCateNo, required this.keywordCateName});

  @override
  String toString() {
    return 'KeywordCate{keywordCateNo: $keywordCateNo, keywordCateName: $keywordCateName}';
  }
}

List<KeywordCate> keywordCateList = [
  KeywordCate(keywordCateNo: 'kc11', keywordCateName: '성격'),
  KeywordCate(keywordCateNo: 'kc22', keywordCateName: '취미'),
  KeywordCate(keywordCateNo: 'kc33', keywordCateName: '가치관'),
];
