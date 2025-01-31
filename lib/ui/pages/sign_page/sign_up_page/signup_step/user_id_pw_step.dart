import 'package:flutter/material.dart';

// step2 아이디 비밀번호 입력
class UserIdPwStep extends StatefulWidget {
  final Function nextStep;
  final dynamic userData;
  final dynamic signupNotifier;

  const UserIdPwStep(this.nextStep, this.userData, this.signupNotifier,
      {super.key});

  @override
  State<UserIdPwStep> createState() => _UserIdPwStepState();
}

class _UserIdPwStepState extends State<UserIdPwStep> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userPw1Controller = TextEditingController();
  final TextEditingController _userPw2Controller = TextEditingController();
  String information = '';

  // 입력된 아이디, 비밀번호의 유효성 검증 함수
  void checkValidation() async {
    String userId = _userIdController.text.trim();
    String userPw1 = _userPw1Controller.text.trim();
    String userPw2 = _userPw2Controller.text.trim();

    if (userId.isEmpty || userPw1.isEmpty || userPw2.isEmpty) {
      setState(() {
        information = '모든 항목을 입력해주세요.';
      });
      return;
    }

    int result = await widget.signupNotifier
        .validationIdPwStep(userId, userPw1, userPw2);

    setState(() {
      if (result == 1) {
        widget.nextStep();
      } else if (result == 2) {
        information = '아이디는 6~12자리의 영문, 숫자 조합만 가능합니다.';
      } else if (result == 3) {
        information = '이미 사용중인 중복된 아이디입니다.';
      } else if (result == 4) {
        information = '비밀번호는 8~14자리의 영문, 숫자, 특수문자만 가능합니다.';
      } else if (result == 5) {
        information = '입력한 비밀번호가 일치하지 않습니다.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _textInputBox('아이디', '영문+숫자 (6~12자리)', false, _userIdController),
          const SizedBox(height: 20),
          _textInputBox(
              '비밀번호', '영문+숫자+특수문자 (8~14자리)', true, _userPw1Controller),
          const SizedBox(height: 20),
          _textInputBox(
              '비밀번호 확인', '영문+숫자+특수문자 (8~14자리)', true, _userPw2Controller),
          const SizedBox(height: 20),
          information.isNotEmpty
              ? Text(
                  information,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.red),
                )
              : SizedBox(),
          const SizedBox(height: 10),
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
              onPressed: _userIdController.text.trim() != '' &&
                      _userPw1Controller.text.trim() != '' &&
                      _userPw2Controller.text.trim() != ''
                  ? () => checkValidation()
                  : null,
              child: Text(
                '다음',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 아이디, 비밀번호 입력 위젯
  Widget _textInputBox(String title, String textHint, bool obscure,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4.0),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            filled: true,
            fillColor: Colors.white,
            hintText: textHint,
            hintStyle: TextStyle(color: Colors.grey),
          ),
          obscureText: obscure,
        ),
      ],
    );
  }
}
