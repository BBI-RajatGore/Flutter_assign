import 'package:flutter/material.dart';

class ErorWidget extends StatelessWidget {
  final String message;

  const ErorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 18),
      ),
    );
  }
}
