import 'package:flutter/material.dart';

AppBar CommonAppBar() {
  return AppBar(
    title: Row(
      children: [
        Image.asset('assets/images/pingo3.png', width: 40),
        Text(
          'Pingo',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ],
    ),
    actions: [
      Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.settings))
    ],
    backgroundColor: Color(0xFFA895CC),
  );
}
