import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {

  final Function  function;
  final String text;

  const ButtonWidget({super.key, required this.function, required this.text});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()=>widget.function(),
      child: Text(
        widget.text,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
