import 'package:flutter/material.dart';
import 'package:pingo_front/_core/utils/logger.dart';

class EditSelfIntroductionBox extends StatefulWidget {
  final String? userIntroduction;
  final Function(String) onIntroductionChanged; // 추가된 콜백

  const EditSelfIntroductionBox(this.userIntroduction,
      {super.key, required this.onIntroductionChanged});

  @override
  _EditSelfIntroductionBoxState createState() =>
      _EditSelfIntroductionBoxState();
}

class _EditSelfIntroductionBoxState extends State<EditSelfIntroductionBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userIntroduction ?? '');
  }

  @override
  Widget build(BuildContext context) {
    logger.i('자기소개 ${widget.userIntroduction}');

    return Card(
      elevation: 0.5,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: [
            Text(
              '자기소개',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 4.0),
            TextField(
              controller: _controller,
              maxLines: 5,
              maxLength: 1000,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                hintText: '자기소개를 입력하세요',
                contentPadding: EdgeInsets.all(8.0),
              ),
              onChanged: (value) {
                widget.onIntroductionChanged(value); // 입력값을 부모로 전달
                logger.i('입력된 자기소개 값: $value');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
