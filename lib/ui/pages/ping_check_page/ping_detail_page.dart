import 'package:flutter/material.dart';
import 'package:pingo_front/data/models/main_model/Profile.dart';

class PingDetailPage extends StatefulWidget {
  final Profile user;
  final String type;
  const PingDetailPage({required this.user, required this.type, super.key});

  @override
  State<PingDetailPage> createState() => _PingDetailPageState();
}

class _PingDetailPageState extends State<PingDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('핑 디테일'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.user.name),
            Text(widget.user.profileDetail!.userInfo!.userAddress!),
            Text(widget.type),
          ],
        ),
      ),
    );
  }
}
