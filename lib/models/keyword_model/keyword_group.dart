class KeywordGroup {
  String kGroupId;
  String kGroupName;
  String kCategoryId;
  String kGroupMessage;

  KeywordGroup(
      {required this.kGroupId,
      required this.kGroupName,
      required this.kCategoryId,
      required this.kGroupMessage});

  @override
  String toString() {
    return 'KeywordGroup{kGroupId: $kGroupId, kGroupName: $kGroupName, kCategoryId: $kCategoryId, kGroupMessage: $kGroupMessage}';
  }
}

List<KeywordGroup> KGroupList = [
  KeywordGroup(
      kGroupId: 'kg11',
      kGroupName: '내향적',
      kCategoryId: 'kc01',
      kGroupMessage: '혼자 있는 시간을 즐기는 사람'),
  KeywordGroup(
      kGroupId: 'kg12',
      kGroupName: '외향적',
      kCategoryId: 'kc01',
      kGroupMessage: '사람들과의 교류를 즐기는 사람'),
  KeywordGroup(
      kGroupId: 'kg13',
      kGroupName: '분석적',
      kCategoryId: 'kc01',
      kGroupMessage: '논리와 데이터에 기반한 사고를 선호하는 사람'),
  KeywordGroup(
      kGroupId: 'kg14',
      kGroupName: '감성적',
      kCategoryId: 'kc01',
      kGroupMessage: '감정과 직관에 따라 행동하는 사람'),
  KeywordGroup(
      kGroupId: 'kg15',
      kGroupName: '리더쉽',
      kCategoryId: 'kc01',
      kGroupMessage: '조직과 사람을 이끄는 데 능숙한 사람'),
  KeywordGroup(
      kGroupId: 'kg21',
      kGroupName: '실외 활동',
      kCategoryId: 'kc02',
      kGroupMessage: '야외에서의 활동을 선호하는 사람'),
  KeywordGroup(
      kGroupId: 'kg22',
      kGroupName: '실내 활동',
      kCategoryId: 'kc02',
      kGroupMessage: '집안에서의 편안한 활동을 좋아하는 사람'),
  KeywordGroup(
      kGroupId: 'kg23',
      kGroupName: '창의적 활동',
      kCategoryId: 'kc02',
      kGroupMessage: '새로운 아이디어와 활동을 만들어내는 사람'),
  KeywordGroup(
      kGroupId: 'kg24',
      kGroupName: '오락 및 게임',
      kCategoryId: 'kc02',
      kGroupMessage: '게임과 여가 활동을 즐기는 사람'),
  KeywordGroup(
      kGroupId: 'kg25',
      kGroupName: '학습 및 탐구',
      kCategoryId: 'kc02',
      kGroupMessage: '지식을 배우고 탐구하는 것을 좋아하는 사람'),
  KeywordGroup(
      kGroupId: 'kg31',
      kGroupName: '개인주의',
      kCategoryId: 'kc03',
      kGroupMessage: '개인의 자유와 독립을 중시하는 사람'),
  KeywordGroup(
      kGroupId: 'kg32',
      kGroupName: '공동체주의',
      kCategoryId: 'kc03',
      kGroupMessage: '타인과의 협력과 공동체를 중시하는 사람'),
  KeywordGroup(
      kGroupId: 'kg33',
      kGroupName: '성취 지향적',
      kCategoryId: 'kc03',
      kGroupMessage: '목표를 설정하고 달성하려는 열망이 강한 사람'),
  KeywordGroup(
      kGroupId: 'kg34',
      kGroupName: '안정 추구형',
      kCategoryId: 'kc03',
      kGroupMessage: '안정적이고 예측 가능한 삶을 선호하는 사람'),
  KeywordGroup(
      kGroupId: 'kg35',
      kGroupName: '모험 지향적',
      kCategoryId: 'kc03',
      kGroupMessage: '새로운 경험과 도전을 즐기는 사람'),
];
