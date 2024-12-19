import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_archi/core/error/failure.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/domain/repository/news_repository.dart';
import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';

// Mock the NewsRepository
class MockFetchNews extends Mock implements NewsRepository {}

void main() {
  
  late FetchNews usecase;
  late NewsRepository repository;

  // Set up the instances of the usecase and repository
  setUp(() {
    repository = MockFetchNews();
    usecase = FetchNews(newsRepository: repository);
  });

  // Test case for Right (success)
  test('should return Right with a list of NewsArticle when fetchNews is successful', () async {
    final List<NewsArticle> mockNewsArticles = [
      NewsArticle(title: 'titl1', description: 'desc1', urlToImage: 'urltoimage1', publishedAt: 'publishedat1'),
      NewsArticle(title: 'titl2', description: 'desc2', urlToImage: 'urltoimage2', publishedAt: 'publishedat2'),
    ];

    // Arrange 
    when(() => repository.fetchNews(
      query: any(named: 'query'),
      language: any(named: 'language'),
      sortBy: any(named: 'sortBy'),
      page: any(named: 'page'),
      pageSize: any(named: 'pageSize'),
    )).thenAnswer((_) async => Right(mockNewsArticles));

    // Act
    final result = await usecase.call('query', 'language', 'asc', 1, 10);

    // Assert
    expect(result.isRight(), true); // Check if it's Right

    result.fold(
      (left) => fail('Expected a successful result, but got a failure.'),
      (right) => expect(right, mockNewsArticles), // Ensure the mock data is returned
    );

     // Verify fetchNews was called once with the correct arguments
    verify(() => repository.fetchNews(
      query: 'query',
      language: 'language',
      sortBy: 'asc',
      page: 1,
      pageSize: 10,
    )).called(1);  // Ensure that the fetchNews method is called once with the specified arguments


  });

  // Test case for Left (failure)
  test('should return Left with a Failure when fetchNews fails', () async {

    // Arrange
    when(() => repository.fetchNews(
      query: any(named: 'query'),
      language: any(named: 'language'),
      sortBy: any(named: 'sortBy'),
      page: any(named: 'page'),
      pageSize: any(named: 'pageSize'),
    )).thenAnswer((_) async => Left(Failure('failed')));

    // Act
    final result_left = await usecase.call('query', 'language', 'asc', 1, 10);

    // Assert
    expect(result_left.isLeft(), true); // Check if it's Left

    result_left.fold(
      (left) => expect(left.message, 'failed'), // Ensure the failure message matches
      (right) => fail('Expected a failure, but got a successful result.'),
    );

    // Verify fetchNews was called once with the correct arguments
    verify(() => repository.fetchNews(
      query: 'query',
      language: 'language',
      sortBy: 'asc',
      page: 1,
      pageSize: 10,
    )).called(1);  // Ensure that the fetchNews method is called once with the specified arguments

  });

}
