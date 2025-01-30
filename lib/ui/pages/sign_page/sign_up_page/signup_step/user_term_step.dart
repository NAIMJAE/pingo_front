import 'package:flutter/material.dart';

// step1 이용약관
Widget userTermStep(BuildContext context, Function _nextStep, userData) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 32.0),
    width: double.infinity,
    height: double.infinity,
    alignment: Alignment.center,
    child: Column(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(color: Colors.grey),
          ),
          child: SingleChildScrollView(
            child: Text(
                '이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n이용약관~\n'),
          ),
        ),
        const SizedBox(height: 10.0),
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
              _nextStep();
            },
            child: Text(
              '동의합니다.',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}
