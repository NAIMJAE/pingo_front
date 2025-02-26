import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pingo_front/ui/pages/keyword_page/keyword_page.dart';
import 'package:pingo_front/ui/pages/ping_check_page/ping_check_page.dart';

class SignalPage extends ConsumerStatefulWidget {
  final Function changePageForKeyword;
  const SignalPage(this.changePageForKeyword, {super.key});

  @override
  ConsumerState<SignalPage> createState() => _SignalPageState();
}

class _SignalPageState extends ConsumerState<SignalPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text('여기 이름 뭘로 하지'),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildTabButton(buildContext, "핑체크?", 0),
                _buildTabButton(buildContext, "키워드", 1),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                PingCheckPage(),
                KeywordPage(widget.changePageForKeyword),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(buildContext, String text, int index) {
    double width = MediaQuery.of(buildContext).size.width;
    return SizedBox(
      width: width / 2 - 6,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: BorderDirectional(
              bottom: BorderSide(
                  width: 2,
                  color:
                      _currentIndex == index ? Colors.redAccent : Colors.white),
            ),
          ),
          child: Text(
            text,
            style: Theme.of(buildContext).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _currentIndex == index ? Colors.red : Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
