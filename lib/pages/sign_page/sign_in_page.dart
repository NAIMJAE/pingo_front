import 'package:flutter/material.dart';

import 'components/find_id_page.dart';
import 'components/find_pw_page.dart';
import 'components/sign_up_page.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  String _username = '';
  String _password = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/pingo1.png',
                  width: 200,
                  height: 200,
                ),
                // Form 위젯 추가
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildSignInTextField(
                        '사용자 이름을 입력하세요',
                        'username 을 입력하시오',
                        _username,
                      ),
                      const SizedBox(height: 24.0),
                      _buildSignInTextField(
                        '패스워드를 입력하세요',
                        '패스워드를 입력 하시오',
                        _password,
                      ),
                      const SizedBox(height: 16.0),
                      _buildSignInButton(
                        context,
                        () {
                          if (_formKey.currentState!.validate()) {
                            print('true을 반환');
                            _formKey.currentState!.save();
                            // 서버로 데이터 전송 코드 여기에 추가
                          }
                        },
                        Colors.deepOrangeAccent,
                        'Sign in',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
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
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '계정이 없으신가요? ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    _buildFindUserInfo(
                      context,
                      SignUpPage(),
                      'Sign up',
                    ),
                  ],
                ),
              ],
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

  Widget _buildFindUserInfo(
    context,
    link,
    findTitle,
  ) {
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
