import 'package:flutter/material.dart';

AppBar CommonAppBar() {
  return AppBar(
    title: Row(
      children: [
        Image.asset('assets/images/bb.png', width: 30),
        Text('Pingo'),
      ],
    ),
    actions: [
      Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.settings))
    ],
    backgroundColor: Colors.white,
  );
}
