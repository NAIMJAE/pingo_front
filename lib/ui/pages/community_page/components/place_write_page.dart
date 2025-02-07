import 'package:flutter/material.dart';
import 'package:pingo_front/ui/widgets/naver_map.dart';

class PlaceWritePage extends StatefulWidget {
  const PlaceWritePage({super.key});

  @override
  State<PlaceWritePage> createState() => _PlaceWritePageState();
}

class _PlaceWritePageState extends State<PlaceWritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("추천 장소 등록")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('네이버맵'),
            Expanded(child: NaverMapApp()),
          ],
        ),
      ),
    );
  }
}
