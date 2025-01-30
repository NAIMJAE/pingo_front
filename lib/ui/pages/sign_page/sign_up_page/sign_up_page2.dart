import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/_core/utils/logger.dart';
import 'package:pingo_front/data/model_views/signup_view_model/signup_view_model.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_up_page/signup_step/user_basic_info_step.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_up_page/signup_step/user_favorite_keyword_step.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_up_page/signup_step/user_my_keyword_step.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_up_page/signup_step/user_profile_step.dart';
import 'package:pingo_front/ui/widgets/common_appbar.dart';

import 'signup_step/user_detail_info_step.dart';
import 'signup_step/user_id_pw_step.dart';
import 'signup_step/user_term_step.dart';

// 새 회원가입 페이지
// 세세한 디테일 부족 -> 모든 예외 경우를 전부 검증하지 못함
class SignUpPage2 extends ConsumerStatefulWidget {
  const SignUpPage2({super.key});

  @override
  ConsumerState<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends ConsumerState<SignUpPage2>
    with SingleTickerProviderStateMixin {
  int currentStep = 0;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset.zero)
        .animate(_controller);
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  // 다음 step으로 넘기는 함수
  void _nextStep() {
    setState(() {
      currentStep++;
      _controller.reset();
      _controller.forward();
      logger.d(currentStep);
      logger.d(ref.watch(signupViewModelProvider).toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(signupViewModelProvider);
    final signupNotifier = ref.read(signupViewModelProvider.notifier);

    return Scaffold(
      appBar: CommonAppBar(context),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          _signupNavigation(currentStep),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildStepWidget(context, userData, signupNotifier),
                ),
              ),
            ),
          ),
        ],
      ),
      // 임시 개발용 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: _nextStep,
        child: Icon(Icons.arrow_forward),
      ),
    );
  }

  // currentStep에 따라 화면 전환하는 위젯
  Widget _buildStepWidget(BuildContext context, userData, signupNotifier) {
    switch (currentStep) {
      case 0:
        return userTermStep(context, _nextStep, userData);
      case 1:
        return UserIdPwStep(_nextStep, userData, signupNotifier);
      case 2:
        return UserBasicInfoStep(_nextStep, userData, signupNotifier);
      case 3:
        return UserProfileStep(_nextStep, userData, signupNotifier);
      case 4:
        return UserDetailInfoStep(_nextStep, userData, signupNotifier);
      case 5:
        return UserMyKeywordStep(_nextStep, userData, signupNotifier);
      case 6:
        return UserFavoriteKeywordStep(_nextStep, userData, signupNotifier);
      default:
        return _buildCompleteStep();
    }
  }

  // 상단의 회원가입 진행 상태 네비게이션 위젯
  Widget _signupNavigation(currentStep) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 4,
            color: Colors.redAccent,
          ),
          Positioned(
            top: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _stepIcon(currentStep, 0, Icons.assignment, "이용약관"),
                _stepIcon(currentStep, 1, Icons.lock_outline, "계정정보"),
                _stepIcon(currentStep, 2, Icons.person, "회원정보"),
                _stepIcon(currentStep, 5, Icons.interests, "취향정보"),
                _stepIcon(currentStep, 7, Icons.check_circle, "완료"),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 상단 네비게이션 위젯의 개별 아이콘 위젯
  Widget _stepIcon(int currentStep, int index, IconData icon, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color:
                index > currentStep ? Colors.grey.shade200 : Colors.redAccent,
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              color: index > currentStep ? Colors.grey.shade500 : Colors.white),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  // 마지막 완료 페이지
  Widget _buildCompleteStep() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        children: [
          Text(
            '회원가입 완료',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 20),
          SizedBox(
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
                // 아직 완료 이후의 함수 처리 안함
              },
              child: Text(
                '로그인 화면으로 이동',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
