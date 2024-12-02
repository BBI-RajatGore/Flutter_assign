import 'package:flutter/material.dart';

class ProfileDescription extends StatelessWidget {
  const ProfileDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Text(
        "Hi, I'm Rajat Gore, a dedicated Software Developer currently working at BBI. I specialize in Flutter and Web Development, and I'm passionate about building beautiful, scalable applications that solve real-world problems.",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
        textAlign: TextAlign.center,
      ),
    );
  }
}