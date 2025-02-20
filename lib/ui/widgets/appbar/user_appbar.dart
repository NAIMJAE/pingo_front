import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/data/view_models/signup_view_model/signin_view_model.dart';
import 'package:pingo_front/ui/pages/main_page/SettingsPage.dart';
import 'package:pingo_front/ui/widgets/common_appbar_line.dart';

AppBar userAppbar(context, Function logout) {
  return AppBar(
    bottom: CommonAppbarLine(),
    scrolledUnderElevation: 0,
    title: Row(
      children: [
        Text(
          '마이페이지',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                logout();
              },
              child: Row(
                children: [
                  Icon(Icons.logout),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    ],
    backgroundColor: Colors.white,
  );
}
