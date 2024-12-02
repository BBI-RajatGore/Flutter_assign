import 'package:flutter/material.dart';

class ProfileName extends StatelessWidget {
  const ProfileName({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20.0),
      child: Text(
        "Rajat Gore",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
      ),
    );
  }
}