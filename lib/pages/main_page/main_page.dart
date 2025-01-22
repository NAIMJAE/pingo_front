import 'package:flutter/material.dart';
import 'package:pingo_font/theme/theme.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('MainPage',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: Colors.blue, fontWeight: FontWeight.bold)),
            Text('MainPage', style: Theme.of(context).textTheme.displayMedium),
            Text('MainPage', style: textTheme().displaySmall),
            Text('MainPage', style: textTheme().headlineLarge),
            Text('MainPage', style: textTheme().headlineMedium),
            Text('MainPage', style: textTheme().headlineSmall),
            Text('MainPage', style: textTheme().bodyLarge),
            Text('MainPage', style: textTheme().bodyMedium),
            Text('MainPage', style: textTheme().bodySmall),
            Container(
              height: 200,
              width: 200,
              color: Colors.purple,
              child: Image.asset('assets/images/bb.png'),
            )
          ],
        ),
      ),
    );
  }
}
