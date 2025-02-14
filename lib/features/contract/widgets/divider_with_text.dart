import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 1, child: Divider()),
        const SizedBox(width: 10),
        Text(text),
        const SizedBox(width: 10),
        const Expanded(flex: 1, child: Divider()),
      ],
    );
  }
}
