import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRecommendPage extends ConsumerStatefulWidget {
  const UserRecommendPage({super.key});

  @override
  ConsumerState<UserRecommendPage> createState() => _UserRecommendPageState();
}

class _UserRecommendPageState extends ConsumerState<UserRecommendPage>
    with AutomaticKeepAliveClientMixin<UserRecommendPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Text('UserRecommendPage');
  }
}
