
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialIcons extends StatelessWidget {
  
  const SocialIcons({super.key});

  Widget iconWidget(IconData icon) {
    return Icon(icon, size: 20);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        iconWidget(FontAwesomeIcons.github),
        iconWidget(FontAwesomeIcons.twitter),
        iconWidget(FontAwesomeIcons.linkedin),
        iconWidget(FontAwesomeIcons.instagram),
        iconWidget(FontAwesomeIcons.whatsapp),
      ],
    );
  }
}