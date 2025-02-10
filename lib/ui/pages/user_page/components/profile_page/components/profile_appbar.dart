import 'package:flutter/material.dart';

import '../../../../../widgets/common_appbar_line.dart';
import 'edit_page/profile_edit_page.dart';

AppBar ProfileAppBar(context) {
  return AppBar(
    bottom: CommonAppbarLine(),
    backgroundColor: Colors.white,
    scrolledUnderElevation: 0,
    title: Text(
      '프로필',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    ),
    centerTitle: true,
    actions: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileEditPage()),
            );
          },
          icon: Icon(Icons.edit),
        ),
      ),
    ],
  );
}
