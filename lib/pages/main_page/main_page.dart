import 'package:flutter/material.dart';

import '../../components/common_appbar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('MainPage'),
          ],
        ),
      ),
    );
  }
}
