// import 'package:flutter_test/flutter_test.dart';
// import 'package:news_app_clean_archi/data/data_sources/news_remote_data_source.dart';
// import 'package:news_app_clean_archi/domain/entities/news.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:mockito/mockito.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class MockHttpClient extends Mock implements http.Client {}

// void main() {
//   late NewsRemoteDataSourceImpl newsRemoteDataSource;
//   late MockHttpClient mockHttpClient;

//   setUp(() {
//     mockHttpClient = MockHttpClient();
//     newsRemoteDataSource = NewsRemoteDataSourceImpl();
//   });

//   test('fetches news successfully', () async {
//     final mockResponse = json.encode({
//       "articles": [
//         {
//           "title": "Test News",
//           "description": "Test Description",
//           "urlToImage": "http://example.com/image.jpg"
//         }
//       ]
//     });

//     when(mockHttpClient.get(any)).thenAnswer(
//       (_) async => http.Response(mockResponse, 200),
//     );

//     final result = await newsRemoteDataSource.fetchNews(
//       query: 'latest',
//       language: 'en',
//       sortBy: 'publishedAt',
//       page: 1,
//       pageSize: 10,
//     );

//     expect(result, isA<List<NewsArticle>>());
//     expect(result.first.title, 'Test News');
//   });

//   test('throws an exception if the response is not successful', () async {
//     when(mockHttpClient.get(any)).thenAnswer(
//       (_) async => http.Response('Not Found', 404),
//     );

//     expect(
//       () async => await newsRemoteDataSource.fetchNews(
//         query: 'latest',
//         language: 'en',
//         sortBy: 'publishedAt',
//         page: 1,
//         pageSize: 10,
//       ),
//       throwsA(isA<Exception>()),
//     );
//   });
// }
