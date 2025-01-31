import 'package:flutter/material.dart';
import 'package:pingo_front/ui/pages/sign_page/components/sign_up_page.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_up_page/sign_up_page2.dart';

AppBar signupAppBar(context, currentStep, _prevStep) {
  return AppBar(
    title: Row(
      children: [
        Text(
          '회원 가입',
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ],
    ),
    backgroundColor: Colors.white,
    leading: IconButton(
      onPressed: () {
        if (currentStep == 0 || currentStep > 6) {
          Navigator.pop(context);
        } else {
          _prevStep();
        }
      },
      icon: Icon(Icons.arrow_back),
    ),
  );
}
