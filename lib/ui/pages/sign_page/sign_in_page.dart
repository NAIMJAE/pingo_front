import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/model_views/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_up_page/sign_up_page2.dart';
import 'components/find_id_page.dart';
import 'components/find_pw_page.dart';

class SignInPage extends ConsumerStatefulWidget {
  SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userPwController = TextEditingController();

  void test() {
    print('object');
  }

  @override
  Widget build(BuildContext context) {
    SigninViewModel signinViewModel = ref.read(sessionProvider.notifier);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 개발 단계 임시
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        '메인페이지로(임시)',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //
                  Image.asset(
                    'assets/images/pingo1.png',
                    width: 200,
                    height: 200,
                  ),
                  // Form 위젯 추가

                  TextField(
                    controller: _userIdController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '아이디를 입력하세요.',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userPwController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '비밀번호를 입력하세요.',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    obscureText: true,
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
                      onPressed: () => signinViewModel.login(
                          _userIdController.text.trim(),
                          _userPwController.text.trim()),
                      child: Text(
                        '로그인',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFindUserInfo(
                        context,
                        FindIdPage(),
                        '아이디 찾기',
                      ),
                      const SizedBox(width: 16.0),
                      _buildFindUserInfo(
                        context,
                        FindPwPage(),
                        '비밀번호 찾기',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '계정이 없으신가요? ',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      _buildFindUserInfo(
                        context,
                        SignUpPage2(),
                        '회원가입',
                      ),
                    ],
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).viewInsets.bottom / 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInTextField(hintText, errorMsg, signInData) {
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMsg;
        }
        return null;
      },
      onSaved: (value) {
        signInData = value!;
      },
    );
  }

  Widget _buildSignInButton(context, onPressed, backGroundColor, signText) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // 텍스트 스타일
          foregroundColor: Colors.white,
          textStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          // 배경 스타일
          backgroundColor: backGroundColor,
          // 그림자 스타일
          shadowColor: Colors.grey,
          elevation: 10,

          // 모서리 라운드
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        onPressed: onPressed,
        child: Text(signText),
      ),
    );
  }

  Widget _buildFindUserInfo(context, link, findTitle) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => link),
              );
            },
            child: Text(
              findTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
