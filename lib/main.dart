import 'package:flutter/material.dart';

import 'components/common_appbar.dart';
import 'pages/main_page/main_page.dart';

void main() {
  runApp(const PingoApp());
}

class PingoApp extends StatelessWidget {
  const PingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: CommonAppBar(),
          body: MainPage(),
        ),
      ),
    );
  }
}
