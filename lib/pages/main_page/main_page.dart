import 'package:flutter/material.dart';
import 'package:pingo_font/theme/text_theme.dart';
import 'package:pingo_font/theme/theme.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('MainPage', style: Theme.of(context).textTheme.displayLarge),
            Text('MainPage', style: Theme.of(context).textTheme.displayMedium),
            Text('MainPage', style: textTheme().displaySmall),
            Text('MainPage', style: textTheme().headlineLarge),
            Text('MainPage', style: textTheme().headlineMedium),
            Text('MainPage', style: textTheme().headlineSmall),
            Text('MainPage', style: textTheme().bodyLarge),
            Text('MainPage', style: textTheme().bodyMedium),
            Text('MainPage', style: textTheme().bodySmall),

            // 0xFF009990 0xFF15B392 0xFF73EC8B 0xFF48CFCB 0xFF9DDE8B 0xFF64CCC5
            Text('Color',
                style: TextStyle(color: Color(0xFF009990), fontSize: 30)),
            Text('Color',
                style: TextStyle(color: Color(0xFF15B392), fontSize: 30)),
            Text('Color',
                style: TextStyle(color: Color(0xFF73EC8B), fontSize: 30)),
            Text('Color',
                style: TextStyle(color: Color(0xFF48CFCB), fontSize: 30)),
            Text('Color',
                style: TextStyle(color: Color(0xFF9DDE8B), fontSize: 30)),
            Text('Color',
                style: TextStyle(color: Color(0xFF64CCC5), fontSize: 30)),
            Image.asset(
              'assets/images/bb0005.jpg',
              width: 100,
            )
          ],
        ),
      ),
    );
  }
}
