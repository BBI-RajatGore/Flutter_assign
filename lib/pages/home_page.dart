import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/post_provider.dart';
import 'package:weather_app/constants/app_constants.dart';
import 'package:weather_app/utils/search.dart';
import 'package:weather_app/utils/theme.dart';
import 'package:weather_app/widgets/custom_appbar_widget.dart';
import 'package:weather_app/widgets/post_card_widget.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late bool _isDarkMode;
  late Future<void> _fetchPostsFuture;

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _fetchPostsFuture =
        Provider.of<PostProvider>(context, listen: false).fetchDataFromApi();
  }

  void _loadTheme() async {
    _isDarkMode = await ThemeService.getSavedTheme();
    setState(() {});
  }

  void _toggle() async {
    _isDarkMode = !_isDarkMode;
    await ThemeService.saveTheme(_isDarkMode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      backgroundColor: _isDarkMode ? AppConstants.darkBackgroundColor : AppConstants.lightBackgroundColor,
      appBar: CustomAppBar(
        isDark: _isDarkMode,
        toggleTheme: _toggle,
        onSearch: () {
          showSearch(
            context: context,
            delegate: PostSearchDelegate(postProvider: postProvider, isDark: _isDarkMode),
          );
        },
      ),
      body: FutureBuilder(
        future: _fetchPostsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: _isDarkMode ? Colors.white : Colors.black),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: AppConstants.errorTextStyle,
              ),
            );
          } else {
            if (postProvider.allPost.isEmpty) {
              return const Center(
                child: Text(
                  AppConstants.noPostsAvailableText,
                  style: AppConstants.errorTextStyle,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: postProvider.allPost.length,
              itemBuilder: (context, index) {
                final post = postProvider.allPost[index];
                return postCard(post.id, post.title, post.body, _isDarkMode);
              },
            );
          }
        },
      ),
    );
  }
}
