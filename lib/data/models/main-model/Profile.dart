class Profile {
  final String name;
  final String age;
  final String status;
  final String distance;
  final List<String> images; // 🔥 여러 개의 이미지 리스트

  Profile({
    required this.name,
    required this.age,
    required this.status,
    required this.distance,
    required this.images, // ✅ 리스트로 변경
  });
}

// 샘플 데이터
final List<Profile> profiles = [
  Profile(
    name: '박임제',
    age: '31',
    status: '접속 중',
    distance: '1km 거리',
    images: [
      'assets/images/aa.png',
      'assets/images/pingo1.png',
      'assets/images/pingo2.png'
    ], // ✅ 여러 개의 이미지
  ),
  Profile(
    name: '하나',
    age: '28',
    status: '접속 중',
    distance: '2km 거리',
    images: [
      'assets/images/bb.png',
      'assets/images/bb0005.jpg',
      'assets/images/pingo3.png'
    ],
  ),
];
