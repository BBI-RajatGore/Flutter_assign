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
  late FetchNews mockFetchNews;

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

    test(
      'should emit NewsLoadingState and then NewsLoadedState when fetch news succeeds',
      () async {
        final mockNews = [
          NewsArticle(
            title: 'Flutter 3.0 released',
            description: 'The latest version of Flutter.',
            urlToImage: 'https://image.url',
            publishedAt: '2021-01-01',
          ),
        ];

        // Mock the fetchNews call to return success
        when(() => mockFetchNews.call(query, language, sortBy, page, pageSize))
            .thenAnswer((_) async => Right(mockNews));

        // Define the expected states
        final expectedStates = [
          NewsLoadingState(), // Emit loading state
          NewsLoadedState(articles: mockNews, hasMore: false), // Emit loaded state
        ];

        // Listen for the state stream and check the sequence of states
        expectLater(newsBloc.stream, emitsInOrder(expectedStates));

        // Trigger the FetchNewsEvent to simulate news fetching
        newsBloc.add(FetchNewsEvent(
          query: query,
          language: language,
          sortBy: sortBy,
        ));
      },
    );

    test(
      'should emit NewsLoadingState and then NewsErrorState when fetch news fails',
      () async {
        const errorMessage = 'Failed to load news';

        // Mock the fetchNews call to return an error
        when(() => mockFetchNews.call(query, language, sortBy, page, pageSize))
            .thenAnswer((_) async => Left(Failure(errorMessage)));

        // Define the expected states
        final expectedStates = [
          NewsLoadingState(), // Emit loading state
          NewsErrorState(errorMessage), // Emit error state
        ];

        // Listen for the state stream and check the sequence of states
        expectLater(newsBloc.stream, emitsInOrder(expectedStates));

        // Trigger the FetchNewsEvent to simulate news fetching
        newsBloc.add(FetchNewsEvent(
          query: query,
          language: language,
          sortBy: sortBy,
        ));
      },
    );

    // test(
    //   'should emit NewsLoadingState and then load more news correctly',
    //   () async {
    //     final mockNews = [
    //       NewsArticle(
    //         title: 'Flutter 3.0 released',
    //         description: 'The latest version of Flutter.',
    //         urlToImage: 'https://image.url',
    //         publishedAt: '2021-01-01',
    //       ),
    //     ];

    //     final newMockNews = [
    //       NewsArticle(
    //         title: 'Dart 2.13 released',
    //         description: 'The latest version of Dart.',
    //         urlToImage: 'https://image.url',
    //         publishedAt: '2021-01-02',
    //       ),
    //     ];

    //     // First, mock the first fetch
    //     when(() => mockFetchNews.call(query, language, sortBy, page, pageSize))
    //         .thenAnswer((_) async => Right(mockNews));

    //     // Then, mock the subsequent "load more" fetch
    //     when(() => mockFetchNews.call(query, language, sortBy, 2, pageSize))
    //         .thenAnswer((_) async => Right(newMockNews));

    //     // Define the expected states for the initial fetch and load more
    //     final initialFetchStates = [
    //       NewsLoadingState(), // First, emit loading state for initial fetch
    //       NewsLoadedState(articles: mockNews, hasMore: true), // Then, emit loaded state with more news to load
    //     ];

    //     final loadMoreStates = [
    //       NewsLoadedState(articles: mockNews, hasMore: true), // Before loading more
    //       NewsLoadedState(articles: [...mockNews, ...newMockNews], hasMore: false), // After loading more, no more news
    //     ];

    //     // Fetch initial news
    //     expectLater(newsBloc.stream, emitsInOrder(initialFetchStates));
    //     newsBloc.add(FetchNewsEvent(
    //       query: query,
    //       language: language,
    //       sortBy: sortBy,
    //     ));

    //     // Load more news
    //     expectLater(newsBloc.stream, emitsInOrder(loadMoreStates));
    //     newsBloc.add(LoadMoreNewsEvent(
    //       query: query,
    //       language: language,
    //       sortBy: sortBy,
    //     ));
    //   },
    // );

    // test(
    //   'should not emit NewsLoadedState if there is no more news to load',
    //   () async {
    //     final mockNews = [
    //       NewsArticle(
    //         title: 'Flutter 3.0 released',
    //         description: 'The latest version of Flutter.',
    //         urlToImage: 'https://image.url',
    //         publishedAt: '2021-01-01',
    //       ),
    //     ];

    //     // Mock the fetchNews call to return only a small batch of news
    //     when(() => mockFetchNews.call(query, language, sortBy, page, pageSize))
    //         .thenAnswer((_) async => Right(mockNews));

    //     // Define the expected states
    //     final initialStates = [
    //       NewsLoadingState(), // Emit loading state
    //       NewsLoadedState(articles: mockNews, hasMore: false), // Emit loaded state with no more news
    //     ];

    //     // Listen for the state stream and check the sequence of states
    //     expectLater(newsBloc.stream, emitsInOrder(initialStates));

    //     // Trigger the FetchNewsEvent to simulate news fetching
    //     newsBloc.add(FetchNewsEvent(
    //       query: query,
    //       language: language,
    //       sortBy: sortBy,
    //     ));

    //     // Try loading more news when there are no more
    //     final loadMoreStates = [
    //       NewsLoadedState(articles: mockNews, hasMore: false), // No more news to load
    //     ];

    //     expectLater(newsBloc.stream, emitsInOrder(loadMoreStates));
    //     newsBloc.add(LoadMoreNewsEvent(
    //       query: query,
    //       language: language,
    //       sortBy: sortBy,
    //     ));
    //   },
    // );
    
  });

  tearDown(() {
    newsBloc.close();
  });

}
