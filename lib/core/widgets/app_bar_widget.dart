import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final title, subtitle;

  const AppBarWidget({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.teal,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: subtitle,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
