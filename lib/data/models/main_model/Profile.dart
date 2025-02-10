class Profile {
  final String userNo; // 유저 번호
  final String name; // 이름
  final String age; // 나이
  final String status; // 상태
  final String distance; // 거리
  final List<String> ImageList; // 🔥 여러 개의 이미지 리스트

  Profile({
    required this.userNo,
    required this.name,
    required this.age,
    required this.status,
    required this.distance,
    required this.ImageList, // ✅ 리스트로 변경
  });
}

// 샘플 데이터
final List<Profile> profiles = [
  Profile(
    userNo: 'US12341234',
    name: '박임제',
    age: '31',
    status: '접속 중',
    distance: '1km 거리',
    ImageList: [
      'assets/images/aa.png',
      'assets/images/pingo1.png',
      'assets/images/pingo2.png'
    ], // ✅ 여러 개의 이미지
  ),
  Profile(
    userNo: 'US12341234',
    name: '하나',
    age: '28',
    status: '접속 중',
    distance: '2km 거리',
    ImageList: [
      'assets/images/bb.png',
      'assets/images/bb0005.jpg',
      'assets/images/pingo3.png'
    ],
  ),
];
