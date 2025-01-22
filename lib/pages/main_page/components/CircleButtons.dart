import 'package:flutter/material.dart';

// 원형 버튼 위젯
class CircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const CircleButton({
    required this.icon,
    required this.color,
    required this.size,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.5,
      ),
    );
  }
}
