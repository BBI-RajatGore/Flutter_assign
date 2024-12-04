import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/model/post_model.dart';
import 'package:http/http.dart' as http;

class PostProvider with ChangeNotifier {

  List<Post> _allPost = [];

  List<Post> _searchedPost = [];

  List<Post> get searchedPost => _searchedPost;

  List<Post> get allPost => _allPost;


  Future<void> fetchDataFromApi() async {

    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {

      List jsonResponse = json.decode(response.body);


      // print(response.body);

      _allPost = jsonResponse
          .map(
            (data) => Post.fromJson(data),
          )
          .toList();

      _searchedPost = List.from(_allPost);

      notifyListeners();

    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> filterDataFromSearch(String input)  async {
    if (input.isEmpty) {
      _searchedPost = List.from(_allPost);
    } else {
      _searchedPost = _allPost
          .where(
              (post) => post.title.toLowerCase().contains(input.toLowerCase()),
            )
          .toList();
    }

    notifyListeners();
  }
}
