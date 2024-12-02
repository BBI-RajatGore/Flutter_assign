import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {

  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const CircleAvatar(
        backgroundImage:  NetworkImage(
          "https://www.aiscribbles.com/img/variant/large-preview/33815/?v=101f25",
        ),
        radius: 100,
        backgroundColor: Color.fromARGB(255, 255, 254, 254),
      ),
    );
  }
}