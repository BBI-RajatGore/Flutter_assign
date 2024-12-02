import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Color.fromARGB(255, 255, 253, 245),
        title: const Text(
          "Profile UI",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 253, 245),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileImage(),
          ProfileName(),
          ProfileDescription(),
          DividerSection(),
          SocialIcons(),
        ],
      ),
    );
  }
}

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
        backgroundImage: NetworkImage("https://www.aiscribbles.com/img/variant/large-preview/33815/?v=101f25"),
        radius: 100,
        backgroundColor: Color.fromARGB(255, 255, 254, 254),
      ),
    );
  }
}

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

class DividerSection extends StatelessWidget {
  const DividerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        height: 2,
        color: Colors.red,
      ),
    );
  }
}

class SocialIcons extends StatelessWidget {
  const SocialIcons({super.key});

  Widget iconWidget(IconData icon) {
    return Icon(icon, size: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          iconWidget(FontAwesomeIcons.github),
          iconWidget(FontAwesomeIcons.twitter),
          iconWidget(FontAwesomeIcons.linkedin),
        ],
      ),
    );
  }
}
