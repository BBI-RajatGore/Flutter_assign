import 'package:flutter/material.dart';
import 'package:weather_app/model/post_model.dart';
import 'package:weather_app/provider/post_provider.dart';
import 'package:weather_app/widgets/listview_widget.dart';

class PostSearchDelegate extends SearchDelegate {
  
  final PostProvider postProvider;
  final bool isDark;

  PostSearchDelegate({required this.postProvider, required this.isDark});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear,
          color: isDark ? Colors.white : Colors.black,
        ),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: isDark ? Colors.white : Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    postProvider.filterDataFromSearch(query);
    final filteredPosts = postProvider.searchedPost;
    return _buildSearchResults(filteredPosts, context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    postProvider.filterDataFromSearch(query);
    final filteredPosts = postProvider.searchedPost;
    return _buildSearchResults(filteredPosts, context);
  }

  Widget _buildSearchResults(List<Post> filteredPosts, BuildContext context) {
    if (filteredPosts.isEmpty) {
      return Center(
        child: Text(
          "No results found",
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black, 
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const  EdgeInsets.all(8.0),
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        final post = filteredPosts[index];
        return listViewWidget(post.id, post.title, post.body, isDark);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: isDark ? Colors.grey : Colors.orange,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.grey : Colors.orange,
      ),
    );
  }
}
