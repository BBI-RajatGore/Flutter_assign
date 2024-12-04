import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/provider/post_provider.dart';
import 'package:weather_app/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool isDarkMode = await ThemeService.getSavedTheme();

  runApp(MyApp(isDarkMode: isDarkMode));
}

class MyApp extends StatelessWidget {
  
  final bool isDarkMode;

  const MyApp({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider(),
      child: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Posts',
            theme: isDarkMode ? ThemeData.light() : ThemeData.light(),
            home: const PostListScreen(),
          );
        },
      ),
    );
  }
}
