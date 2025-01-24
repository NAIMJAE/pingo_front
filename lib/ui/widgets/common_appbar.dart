import 'package:flutter/material.dart';

AppBar CommonAppBar() {
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
      Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.settings))
    ],
    backgroundColor: Colors.white,
  );
}
