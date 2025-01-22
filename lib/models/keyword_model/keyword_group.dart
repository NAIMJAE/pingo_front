class KeywordGroup {
  String kGroupId;
  String kGroupName;
  String kCategoryId;

  KeywordGroup(
      {required this.kGroupId,
      required this.kGroupName,
      required this.kCategoryId});

  @override
  String toString() {
    return 'KeywordGroup{kGroupId: $kGroupId, kGroupName: $kGroupName, kCategoryId: $kCategoryId}';
  }
}

List<KeywordGroup> KGroupList = [
  KeywordGroup(kGroupId: 'kg11', kGroupName: '내향적', kCategoryId: 'kc01'),
  KeywordGroup(kGroupId: 'kg12', kGroupName: '외향적', kCategoryId: 'kc01'),
  KeywordGroup(kGroupId: 'kg13', kGroupName: '분석적', kCategoryId: 'kc01'),
  KeywordGroup(kGroupId: 'kg14', kGroupName: '감성적', kCategoryId: 'kc01'),
  KeywordGroup(kGroupId: 'kg15', kGroupName: '리더쉽', kCategoryId: 'kc01'),
  KeywordGroup(kGroupId: 'kg21', kGroupName: '실외 활동', kCategoryId: 'kc02'),
  KeywordGroup(kGroupId: 'kg22', kGroupName: '실내 활동', kCategoryId: 'kc02'),
  KeywordGroup(kGroupId: 'kg23', kGroupName: '창의적 활동', kCategoryId: 'kc02'),
  KeywordGroup(kGroupId: 'kg24', kGroupName: '오락 및 게임', kCategoryId: 'kc02'),
  KeywordGroup(kGroupId: 'kg25', kGroupName: '학습 및 탐구', kCategoryId: 'kc02'),
  KeywordGroup(kGroupId: 'kg31', kGroupName: '개인주의', kCategoryId: 'kc03'),
  KeywordGroup(kGroupId: 'kg32', kGroupName: '공동체주의', kCategoryId: 'kc03'),
  KeywordGroup(kGroupId: 'kg33', kGroupName: '성취 지향적', kCategoryId: 'kc03'),
  KeywordGroup(kGroupId: 'kg34', kGroupName: '안정 추구형', kCategoryId: 'kc03'),
  KeywordGroup(kGroupId: 'kg35', kGroupName: '모험 지향적', kCategoryId: 'kc03'),
];
