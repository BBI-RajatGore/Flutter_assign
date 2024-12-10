import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


abstract class NewsRemoteDataSource {
  Future<List<NewsArticle>> fetchNews({required int page, required int pageSize});
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final String _baseUrl = 'https://newsapi.org/v2/everything';
  final String? _apiKey = dotenv.env['API_KEY']; 
  


  @override
  Future<List<NewsArticle>> fetchNews({required int page, required int pageSize}) async {

    final Uri url = Uri.parse(
        '$_baseUrl?q=tesla&from=2024-11-09&sortBy=publishedAt&apiKey=$_apiKey&page=$page&pageSize=$pageSize');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articlesJson = data['articles'];

        return articlesJson.map((articleJson) => NewsArticle.fromJson(articleJson)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load news: $error');
    }
  }
}


