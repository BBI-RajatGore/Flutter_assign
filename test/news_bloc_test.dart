import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:news_app_clean_archi/core/error/failure.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';

// Mock class for FetchNews
class MockFetchNews extends Mock implements FetchNews {}

void main() {
  late MockFetchNews mockFetchNews;
  late NewsBloc newsBloc;

  setUp(() {
    mockFetchNews = MockFetchNews();
    newsBloc = NewsBloc(fetchNews: mockFetchNews);
  });

  test('initial state is NewsInitialState', () {
    expect(newsBloc.state, equals(NewsInitialState()));
  });

  blocTest<NewsBloc, NewsState>(
    'emits [NewsLoadingState, NewsLoadedState] when FetchNewsEvent is added',
    build: () {
      // Mocking the call method with exact parameters
      when(mockFetchNews.call(
        'latest', // query
        'en',     // language
        'adw',    // sortBy
        1,        // page, starting from page 1
        20,       // pageSize
      )).thenAnswer(
        (_) async => Right([
          NewsArticle(
            title: "Test",
            description: "Description",
            urlToImage: 'urlToImage',
            publishedAt: '1/2/3123',
          ),
        ]),
      );
      return newsBloc;
    },
    act: (bloc) => bloc.add(FetchNewsEvent(query: "latest", language: "en", sortBy: "adw")),
    expect: () => [
      NewsLoadingState(),
      NewsLoadedState(
        articles: [
          NewsArticle(
            title: "Test",
            description: "Description",
            urlToImage: 'urlToImage',
            publishedAt: '1/2/3123',
          ),
        ],
        hasMore: true,
      ),
    ],
  );

  blocTest<NewsBloc, NewsState>(
    'emits [NewsErrorState] when FetchNewsEvent fails',
    build: () {
      // Mocking the call method with failure
      when(mockFetchNews.call(
        'latest',  // query
        null,      // language
        null,      // sortBy
        1,         // page
        20,        // pageSize
      )).thenAnswer(
        (_) async => Left(Failure("Error")),
      );
      return newsBloc;
    },
    act: (bloc) => bloc.add(FetchNewsEvent(query: "latest")),
    expect: () => [
      NewsLoadingState(),
      NewsErrorState("Error"),
    ],
  );
}

