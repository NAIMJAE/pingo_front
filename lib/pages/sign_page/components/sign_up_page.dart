import 'package:flutter/material.dart';
import 'package:pingo_front/pages/sign_page/sign_in_page.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  String _username = '';
  String _password = '';
  String _passwordcheck = '';
  String _name = '';
  String _nickname = '';
  String _birth = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '회원가입',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          // ListView로 변경
          padding: const EdgeInsets.all(32.0),
          children: [
            Align(
              alignment: Alignment.center,
              child: Wrap(
                spacing: 12.0, // 칸 사이의 가로 간격
                runSpacing: 12.0, // 칸 사이의 세로 간격
                children: [
                  _mainImage(context, false),
                  _subImage(context, false),
                  _subImage(context, false),
                  _subImage(context, false),
                  _subImage(context, false),
                  _subImage(context, false),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            _buildSignUpInfo(
              context,
              '아이디',
              '사용자 이름을 입력하세요',
              'username 을 입력하시오',
              _username,
            ),
            const SizedBox(height: 16.0),
            _buildSignUpInfo(
              context,
              '비밀번호',
              '패스워드를 입력하세요',
              '패스워드를 입력 하시오',
              _password,
            ),
            const SizedBox(height: 16.0),
            _buildSignUpInfo(
              context,
              '비밀번호 확인',
              '패스워드 재입력',
              '패스워드를 입력 하시오',
              _passwordcheck,
            ),
            const SizedBox(height: 16.0),
            _buildSignUpInfo(
              context,
              '이름',
              '이름을 입력하세요',
              '이름을 입력 하시오',
              _name,
            ),
            const SizedBox(height: 16.0),
            _buildSignUpInfo(
              context,
              '닉네임',
              '닉네임을 입력하세요',
              '닉네임을 입력 하시오',
              _nickname,
            ),
            const SizedBox(height: 16.0),
            _buildSignUpInfoSetting(
              context,
              '생년월일',
              _buildBirthInfo(context),
              '생년월일을 설정 하시오',
              _birth,
            ),
            const SizedBox(height: 16.0),
            _buildSignUpButton(
              context,
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              Colors.deepOrangeAccent,
              'Sign up',
            ),
          ],
        ),
      ),
    );
  }

  Widget _mainImage(BuildContext context, bool hasImage) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://picsum.photos/200/100',
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Container(
                    width: 60, // 플러스 아이콘을 감쌀 원의 크기
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // 사진 추가 로직
                      },
                    ),
                  ),
                ),
        ),
        if (hasImage)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero, // 패딩을 없애서 중앙에 맞춤
                  icon: Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // 대표 이미지로 지정 로직
                                  Navigator.of(context).pop();
                                },
                                child: Text('대표이미지로 지정'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // 삭제 로직
                                  Navigator.of(context).pop();
                                },
                                child: Text('삭제'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text('대표',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ],
    );
  }

  Widget _subImage(BuildContext context, bool hasImage) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: hasImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://picsum.photos/200/100',
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Container(
                    width: 60, // 플러스 아이콘을 감쌀 원의 크기
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        // 사진 추가 로직
                      },
                    ),
                  ),
                ),
        ),
        if (hasImage)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1.0),
              ),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero, // 패딩을 없애서 중앙에 맞춤
                  icon: Icon(
                    Icons.settings,
                    size: 20,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // 대표 이미지로 지정 로직
                                  Navigator.of(context).pop();
                                },
                                child: Text('대표이미지로 지정'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // 삭제 로직
                                  Navigator.of(context).pop();
                                },
                                child: Text('삭제'),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSignUpInfo(context, title, hintText, errorMsg, signInData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        _buildSignUpTextField(hintText, errorMsg, signInData),
      ],
    );
  }

  Widget _buildSignUpTextField(hintText, errorMsg, signInData) {
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

  Widget _buildSignUpInfoSetting(
      context, title, defalutValue, errorMsg, signInData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        _buildSignUpInfoContainer(context, defalutValue, errorMsg, signInData),
      ],
    );
  }

  Widget _buildSignUpInfoContainer(
      context, defaultValue, errorMsg, signInData) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          defaultValue,
        ],
      ),
    );
  }

  // 생년월일
  final ValueNotifier<DateTime> selectedDateNotifier =
      ValueNotifier(DateTime(1998, 5, 28));
  Widget _buildBirthInfo(context) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: ValueListenableBuilder<DateTime>(
        valueListenable: selectedDateNotifier,
        builder: (context, selectedDate, child) {
          return Row(
            children: [
              Text(
                '${selectedDate.toLocal()}'.split(' ')[0],
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 8.0),
              Icon(
                Icons.calendar_today,
                color: Colors.lightBlueAccent,
                size: 20,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _selectDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDateNotifier.value,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDateNotifier.value) {
      selectedDateNotifier.value = picked; // 날짜 선택 시 상태 업데이트
    }
  }

  Widget _buildSignUpButton(context, onPressed, backGroundColor, signText) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          backgroundColor: backGroundColor,
          shadowColor: Colors.grey,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(signText),
      ),
    );
  }
}
