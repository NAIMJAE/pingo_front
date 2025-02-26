import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/ui/pages/keyword_page/keyword_page.dart';

class PingCheckPage extends ConsumerStatefulWidget {
  const PingCheckPage({super.key});

  @override
  ConsumerState<PingCheckPage> createState() => _PingCheckPageState();
}

class _PingCheckPageState extends ConsumerState<PingCheckPage> {
  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.supervisor_account_outlined),
                    const SizedBox(width: 12),
                    Text(
                      '내가 받은 슈퍼핑 볼 수 있습니다~',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                _superPingBox(),
                Row(
                  children: [
                    Icon(Icons.security_outlined),
                    const SizedBox(width: 12),
                    Text(
                      '내가 받은 핑을 볼 수 있습니다. \n 모두 확인하려면 유료 결제 하쇼',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                _pingBox(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _superPingBox() {
    return Text('data');
  }

  Widget _pingBox() {
    return Text('data');
  }
}
