import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app_clean_archi/core/error/failure.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';
import 'package:fpdart/fpdart.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';

class MockFetchNews extends Mock implements FetchNews {}

void main() {
  late NewsBloc newsBloc;
  late MockFetchNews mockFetchNews;

  const String query = 'flutter';
  const String language = 'en';
  const String sortBy = 'publishedAt';
  const int page = 1;
  const int pageSize = 20;

  setUp(() {
    mockFetchNews = MockFetchNews();
    newsBloc = NewsBloc(fetchNews: mockFetchNews);
  });

  group('NewsBloc', () {
    test('initial state is NewsInitialState', () {
      expect(newsBloc.state, equals(NewsInitialState()));
    });

    test('should emit NewsLoadingState and then NewsLoadedState when fetch news succeeds', () async {
      final mockNews = [
        NewsArticle(
          title: 'Flutter 3.0 released',
          description: 'The latest version of Flutter.',
          urlToImage: 'https://image.url',
          publishedAt: '2021-01-01',
        ),
      ];

      when(() => mockFetchNews.call(query, language, sortBy, page, pageSize))
          .thenAnswer((_) async => Right(mockNews));

      final expectedStates = [
        NewsLoadingState(),
        NewsLoadedState(articles: mockNews, hasMore: false),
      ];

      expectLater(newsBloc.stream, emitsInOrder(expectedStates));

      newsBloc.add(FetchNewsEvent(
        query: query,
        language: language,
        sortBy: sortBy,
      ));
    });

    test('should emit NewsLoadingState and then NewsErrorState when fetch news fails', () async {
      
      final errorMessage = 'Failed to load news';

      when(() => mockFetchNews.call(query, language, sortBy, page, pageSize))
          .thenAnswer((_) async => Left(Failure(errorMessage)));

      final expectedStates = [
        NewsLoadingState(),
        NewsErrorState(errorMessage),
      ];

      expectLater(newsBloc.stream, emitsInOrder(expectedStates));

      newsBloc.add(FetchNewsEvent(
        query: query,
        language: language,
        sortBy: sortBy,
      ));
    });

    test('should emit NewsLoadingState and then load more news correctly', () async {
      final mockNews = [
        NewsArticle(
          title: 'Flutter 3.0 released',
          description: 'The latest version of Flutter.',
          urlToImage: 'https://image.url',
          publishedAt: '2021-01-01',
        ),
      ];
      final newMockNews = [
        NewsArticle(
          title: 'Dart 2.13 released',
          description: 'The latest version of Dart.',
          urlToImage: 'https://image.url',
          publishedAt: '2021-01-02',
        ),
      ];

      when(() => mockFetchNews.call(query, language, sortBy, page, pageSize))
          .thenAnswer((_) async => Right(mockNews));
      when(() => mockFetchNews.call(query, language, sortBy, 2, pageSize))
          .thenAnswer((_) async => Right(newMockNews));

      final initialFetchStates = [
        NewsLoadingState(),
        NewsLoadedState(articles: mockNews, hasMore: true),
      ];

      final loadMoreStates = [
        NewsLoadedState(articles: mockNews, hasMore: true),
        NewsLoadedState(articles: [...mockNews, ...newMockNews], hasMore: false),
      ];

      // Fetch the initial news
      expectLater(newsBloc.stream, emitsInOrder(initialFetchStates));
      newsBloc.add(FetchNewsEvent(
        query: query,
        language: language,
        sortBy: sortBy,
      ));

      // Load more news
      expectLater(newsBloc.stream, emitsInOrder(loadMoreStates));
      newsBloc.add(LoadMoreNewsEvent(
        query: query,
        language: language,
        sortBy: sortBy,
      ));
    });

    test('should not emit NewsLoadedState if there is no more news to load', () async {
      final mockNews = [
        NewsArticle(
          title: 'Flutter 3.0 released',
          description: 'The latest version of Flutter.',
          urlToImage: 'https://image.url',
          publishedAt: '2021-01-01',
        ),
      ];

      when(() => mockFetchNews.call(query, language, sortBy, page, pageSize))
          .thenAnswer((_) async => Right(mockNews));

      final initialStates = [
        NewsLoadingState(),
        NewsLoadedState(articles: mockNews, hasMore: false),
      ];

      expectLater(newsBloc.stream, emitsInOrder(initialStates));

      // Fetch initial news
      newsBloc.add(FetchNewsEvent(
        query: query,
        language: language,
        sortBy: sortBy,
      ));

      // Try loading more news when no more news is available
      final loadMoreStates = [
        NewsLoadedState(articles: mockNews, hasMore: false),
      ];

      expectLater(newsBloc.stream, emitsInOrder(loadMoreStates));

      newsBloc.add(LoadMoreNewsEvent(
        query: query,
        language: language,
        sortBy: sortBy,
      ));
    });
  });

  tearDown(() {
    newsBloc.close();
  });
}
