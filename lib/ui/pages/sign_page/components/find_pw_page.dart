import 'package:flutter/material.dart';
import 'package:pingo_front/ui/widgets/find_pw_appbar.dart';

class FindPwPage extends StatefulWidget {
  const FindPwPage({super.key});

  @override
  State<FindPwPage> createState() => _FindPwPageState();
}

class _FindPwPageState extends State<FindPwPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: findPwAppBar(context),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _textInputBox(
                    '아이디', '영문+숫자 (6~12자리)', false, _userIdController),
                const SizedBox(height: 20),
                _textInputBox(
                    '이메일', 'example@email.com', false, _userEmailController),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      '다음',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 아이디, 이메일 입력 위젯
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
