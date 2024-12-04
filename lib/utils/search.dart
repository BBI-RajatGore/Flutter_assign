import 'package:flutter/material.dart';
import 'package:weather_app/model/post_model.dart';
import 'package:weather_app/provider/post_provider.dart';
import 'package:weather_app/widgets/listview_widget.dart';

class PostSearchDelegate extends SearchDelegate {
  final PostProvider postProvider;

  PostSearchDelegate({required this.postProvider});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.orange),
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
      icon: const Icon(Icons.arrow_back, color: Colors.orange),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    postProvider.filterDataFromSearch(query);
    final filteredPosts = postProvider.searchedPost;
    return _buildSearchResults(filteredPosts);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    postProvider.filterDataFromSearch(query);
    final filteredPosts = postProvider.searchedPost;
    return _buildSearchResults(filteredPosts);
  }

  Widget _buildSearchResults(List<Post> filteredPosts) {
    if (filteredPosts.isEmpty) {
      return const Center(
        child: Text(
          "No results found",
          style: TextStyle(color: Colors.red),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: filteredPosts.length,
      itemBuilder: (context, index) {
        final post = filteredPosts[index];
        return listViewWidget(post.id, post.title, post.body);
      },
    );
  }
  
}
