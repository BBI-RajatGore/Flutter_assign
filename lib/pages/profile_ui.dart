import 'package:flutter/material.dart';
import 'package:profile_ui/widget/divider.dart';
import 'package:profile_ui/widget/profile_desc.dart';
import 'package:profile_ui/widget/profile_image.dart';
import 'package:profile_ui/widget/profile_name.dart';
import 'package:profile_ui/widget/social_icons.dart';

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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();

}

class _ProfilePageState extends State<ProfilePage> {

  bool _showDetails = false;

  
  void toggleDetails(double width) {
    
    setState(() {
      _showDetails = !_showDetails;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

   
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 253, 245),
        title: const Text(
          "Profile UI",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 253, 245),
      body: (screenWidth > 600)
          ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: GestureDetector(
                      onTap: () => toggleDetails(screenWidth),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileImage(),
                          ProfileName(),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(height: screenHeight, width: 1, color: Colors.grey),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: AnimatedOpacity(
                      opacity: _showDetails ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.35,
                          horizontal: 16.0,
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileDescription(),
                            DividerSection(),
                            SocialIcons(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.1),
                child: const Column(
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
              ),
            ),
    );
  }
}
