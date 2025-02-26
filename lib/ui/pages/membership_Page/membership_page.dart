import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pingo_front/data/models/membership_model/membership.dart';
import 'package:pingo_front/data/repository/membership_repository/membership_repository.dart';
import 'package:pingo_front/ui/pages/membership_Page/payment_page.dart';

class MembershipPage extends ConsumerStatefulWidget {
  const MembershipPage({super.key});

  @override
  ConsumerState<MembershipPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<MembershipPage> {
  final MembershipRepository _repository = MembershipRepository();
  Future<List<Membership>>? _membershipFuture;
  List<Color> couponColors = [
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.orangeAccent
  ];
  Membership? selectedMembership;

  @override
  void initState() {
    super.initState();
    _membershipFuture = _repository.fetchSelectMemberShip();
  }

  void _clickCoupon(Membership membership) {
    selectedMembership = membership;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Pingo 구독권 구매',
              style: TextStyle(fontSize: 16),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder(
                future: _membershipFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("데이터 로드 실패"));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text("멤버십 정보 없음"));
                  }

                  List<Membership> memberships = snapshot.data!;

                  return Column(
                    children: [
                      Text(
                        'Pingo 유료 구독으로 \n더 많은 기능을 경험해보세요!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(
                        memberships.length,
                        (index) {
                          return _couponBox(memberships[index], Colors.grey);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _explainRow('슈퍼핑 몇개?'),
                            const SizedBox(height: 8),
                            _explainRow('되돌리기 무한?'),
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: _paymentBtn(),
          ),
        ),
      ),
    );
  }

  Widget _explainRow(String explain) {
    return Row(
      children: [
        Icon(Icons.check),
        const SizedBox(width: 8),
        Text(explain, style: Theme.of(context).textTheme.headlineMedium)
      ],
    );
  }

  Widget _paymentBtn() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        onPressed: () {
          // 널 체크 추가
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(),
            ),
          );
        },
        child: Text(
          '${selectedMembership != null ? NumberFormat('#,###').format(selectedMembership?.price) : 0} 원  결제하기',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _couponBox(Membership membership, Color backColor) {
    return InkWell(
      splashColor: Colors.transparent, // ✅ 물결 효과 제거
      highlightColor: Colors.transparent, // ✅ 클릭 시 배경 강조 제거
      onTap: () {
        _clickCoupon(membership);
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 140,
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 45),
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            decoration: BoxDecoration(
              color: membership.msNo == selectedMembership?.msNo
                  ? Colors.red
                  : backColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  offset: Offset(2, 2),
                  blurRadius: 4,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  membership.title!,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${NumberFormat('#,###').format(membership.price)} 원',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 35,
            left: -20,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(35)),
              ),
            ),
          ),
          Positioned(
            right: 65,
            top: 0,
            child: Container(
              width: 5,
              height: 140,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          Positioned(
            right: 20,
            top: 0,
            child: Container(
              width: 40,
              height: 140,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          if (membership.msNo == selectedMembership?.msNo)
            Positioned(
              right: 20,
              top: 0,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(Icons.check),
              ),
            ),
        ],
      ),
    );
  }
}
