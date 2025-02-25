import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/models/membership_model/membership.dart';
import 'package:pingo_front/data/repository/membership_repository/membership_repository.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({super.key});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final MembershipRepository _repository = MembershipRepository();
  Future<List<Membership>>? _membershipFuture;

  @override
  void initState() {
    super.initState();
    _membershipFuture = _repository.fetchSelectMemberShip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('결제'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: _membershipFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator()); // 로딩 중
                } else if (snapshot.hasError) {
                  return Center(child: Text("데이터 로드 실패")); // 에러 처리
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: Text("멤버십 정보 없음")); // 데이터 없음 처리
                }

                return Column(
                  children: [
                    _couponBox(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _couponBox() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 160,
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.only(left: 40, right: 40),
          decoration: BoxDecoration(
            color: Colors.deepPurple,
          ),
          child: Text('data'),
        ),
        Positioned(
          top: 40,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
          ),
        ),
        Positioned(
          right: 20,
          top: 0,
          child: ClipPath(
            clipper: ZigZagClipper(),
            child: Container(
              width: 80,
              height: 160,
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class ZigZagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double zigzagHeight = 10; // 지그재그 높이
    double zigzagWidth = 10; // 지그재그 너비

    path.moveTo(0, 0);
    path.lineTo(size.width - zigzagWidth, 0);

    // 지그재그 패턴 생성
    for (double i = 0; i < size.height; i += zigzagHeight * 2) {
      path.lineTo(size.width, i + zigzagHeight);
      path.lineTo(size.width - zigzagWidth, i + zigzagHeight * 2);
    }

    path.lineTo(size.width - zigzagWidth, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
