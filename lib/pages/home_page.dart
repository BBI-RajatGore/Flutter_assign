import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/post_provider.dart';
import 'package:weather_app/utils/search.dart';
import 'package:weather_app/widgets/listview_widget.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<void> _fetchPostsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPostsFuture =
        Provider.of<PostProvider>(context, listen: false).fetchDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text(
          'Posts',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: PostSearchDelegate(postProvider: postProvider),
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _fetchPostsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
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
                return listViewWidget(post.id, post.title, post.body);
              },
            );
          }
          return const Center(child: Text('Unexpected Error'));
        },
      ),
    );
  }
}
