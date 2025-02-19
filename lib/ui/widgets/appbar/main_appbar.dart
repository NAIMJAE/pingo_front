import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/ui/pages/main_page/SettingsPage.dart';
import 'package:pingo_front/ui/widgets/common_appbar_line.dart';

AppBar mainAppbar(context) {
  return AppBar(
    bottom: CommonAppbarLine(),
    scrolledUnderElevation: 0,
    title: Row(
      children: [
        Image.asset('assets/images/pingo1.png', width: 30),
        Text(
          'Pingo',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
          icon: Icon(Icons.settings),
        ),
      ),
    ],
    backgroundColor: Colors.white,
  );
}
