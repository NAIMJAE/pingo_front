import 'package:flutter/material.dart';

class KeywordPage extends StatelessWidget {
  const KeywordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8.0,
              children: [
                box(),
                box(),
                box(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget box() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
