import 'package:flutter/material.dart';

import '../../../../../widgets/common_appbar_line.dart';

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
          onPressed: () {},
          icon: Icon(Icons.save),
        ),
      ),
    ],
  );
}
