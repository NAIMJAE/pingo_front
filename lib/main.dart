import 'package:flutter/material.dart';
import 'package:pingo_front/pages/sign_page/sign_in_page.dart';
import 'pages/main_screen.dart';
import 'theme/theme.dart';

void main() {
  runApp(const PingoApp());
}

class PingoApp extends StatefulWidget {
  const PingoApp({super.key});

  @override
  State<PingoApp> createState() => _PingoAppState();
}

class _PingoAppState extends State<PingoApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mTheme(),
      home: SafeArea(
        child: MainScreen(),
      ),
    );
  }
}
