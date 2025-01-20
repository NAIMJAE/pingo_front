import 'package:flutter/material.dart';

AppBar CommonAppBar() {
  return AppBar(
    title: Text('Pingo'),
    actions: [
      Padding(padding: const EdgeInsets.all(8.0), child: Icon(Icons.person))
    ],
  );
}
