import 'package:flutter/material.dart';
import 'package:pingo_front/ui/pages/sign_page/components/sign_up_page.dart';
import 'package:pingo_front/ui/pages/sign_page/sign_up_page/sign_up_page2.dart';

AppBar CommonAppBar(context) {
  return AppBar(
    title: Row(
      children: [
        Image.asset('assets/images/pingo1.png', width: 40),
        Text(
          'Pingo',
          style: TextStyle(fontSize: 30, color: Colors.black),
        ),
      ],
    ),
    actions: [
      Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.settings)),
    ],
    backgroundColor: Colors.white,
  );
}
