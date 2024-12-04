import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/post_provider.dart';
import 'package:weather_app/utils/search.dart';
import 'package:weather_app/utils/theme.dart';
import 'package:weather_app/widgets/listview_widget.dart';

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

    final isDark = _isDarkMode;
    final appBarColor = isDark ? Colors.grey : Colors.orange;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    const textColor = Colors.white;
    const iconColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text(
          'Posts',
          style: TextStyle(color: textColor),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.brightness_7 : Icons.brightness_2,
              color: iconColor,
            ),
            onPressed: _toggle,
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: iconColor,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(
                    postProvider: postProvider, isDark: _isDarkMode),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchPostsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(
              child: CircularProgressIndicator(color: (_isDarkMode) ? Colors.white : Colors.black),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (postProvider.allPost.isEmpty) {
              return const Center(
                child: Text(
                  'No Posts Available.',
                  style: TextStyle(color: Colors.red),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: postProvider.allPost.length,
              itemBuilder: (context, index) {
                final post = postProvider.allPost[index];
                return listViewWidget(post.id, post.title, post.body, isDark);
              },
            );
          }
          return const Center(
            child: Text('Unexpected Error'),
          );
        },
      ),
    );
  }
}
