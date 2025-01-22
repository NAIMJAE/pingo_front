class KeywordCategory {
  String kCategoryId;
  String kCategoryName;

  KeywordCategory({required this.kCategoryId, required this.kCategoryName});

  @override
  String toString() {
    return 'KeywordCate{kCategoryId: $kCategoryId, kCategoryName: $kCategoryName}';
  }
}

List<KeywordCategory> kCategoryList = [
  KeywordCategory(kCategoryId: 'kc01', kCategoryName: '성격'),
  KeywordCategory(kCategoryId: 'kc02', kCategoryName: '취미'),
  KeywordCategory(kCategoryId: 'kc03', kCategoryName: '가치관'),
];
