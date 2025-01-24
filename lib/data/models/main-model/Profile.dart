class Profile {
  final String name;
  final String age;
  final String status;
  final String distance;
  final String image;

  Profile({
    required this.name,
    required this.age,
    required this.status,
    required this.distance,
    required this.image,
  });
}

// 샘플 데이터
final List<Profile> profiles = [
  Profile(
    name: '박임제',
    age: '31',
    status: '접속 중',
    distance: '1km 거리',
    image: 'assets/images/aa.png',
  ),
  Profile(
    name: '하나',
    age: '28',
    status: '접속 중',
    distance: '2km 거리',
    image: 'assets/images/bb.png',
  ),
];
