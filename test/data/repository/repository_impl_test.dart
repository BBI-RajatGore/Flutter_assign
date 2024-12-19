import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_archi/data/data_sources/news_remote_data_source.dart';
import 'package:news_app_clean_archi/data/repository/news_repository_impl.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';


// Mock the NewsRemoteDataSource
class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

void main() {
  late NewsRepositoryImpl repository;
  late NewsRemoteDataSource newsRemoteDataSource;

  setUp(() {
    newsRemoteDataSource = MockNewsRemoteDataSource();
    repository = NewsRepositoryImpl(newsRemoteDataSource: newsRemoteDataSource);
  });

  group('fetchNews', () {

    const String query = 'flutter';
    const String language = 'en';
    const String sortBy = 'publishedAt';
    const int page = 1;
    const int pageSize = 10;

    test('should return Right with list of NewsArticle when data is fetched successfully', () async {

      // Arrange
      final List<NewsArticle> mockNewsArticles = [
        NewsArticle(title: 'Title 1', description: 'Description 1', urlToImage: 'url1', publishedAt: '2021-01-01'),
        NewsArticle(title: 'Title 2', description: 'Description 2', urlToImage: 'url2', publishedAt: '2021-01-02'),
      ];
      
      // Mock the successful data fetch
      when(() => newsRemoteDataSource.fetchNews(
        query: query,
        language: language,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      )).thenAnswer((_) async => mockNewsArticles);

      // Act
      final result = await repository.fetchNews(
        query: query,
        language: language,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isRight(), true); // Check if it's a Right

      result.fold(
        (left) => fail('Expected success but got failure'),
        (right) => expect(right, mockNewsArticles), // Ensure the correct data is returned
      );

      // Verify that the fetchNews method was called with the correct parameters
      verify(() => newsRemoteDataSource.fetchNews(
        query: query,
        language: language,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      )).called(1);
    });

    test('should return Left with Failure when an exception is thrown', () async {
      // Arrange
      when(() => newsRemoteDataSource.fetchNews(
        query: query,
        language: language,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      )).thenThrow(Exception('Failed to load news'));

      // Act
      final result = await repository.fetchNews(
        query: query,
        language: language,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      );

      // Assert
      expect(result.isLeft(), true); // Check if it's a Left
      result.fold(
        (left) => expect(left.message, 'Exception: Failed to load news'),
        (right) => fail('Expected failure but got success'),
      );

      // Verify that the fetchNews method was called with the correct parameters
      verify(() => newsRemoteDataSource.fetchNews(
        query: query,
        language: language,
        sortBy: sortBy,
        page: page,
        pageSize: pageSize,
      )).called(1);
    });
  });
}
