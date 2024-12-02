
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String name;
  const HomePage({super.key,required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome ${name}',
        ),
      ),
    );
  }
}