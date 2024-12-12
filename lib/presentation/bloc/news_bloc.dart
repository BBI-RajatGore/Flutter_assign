
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {

  final FetchNews _fetchNews;
  int _page = 1;
  static const int _pageSize = 20;
  static const int _maxPages = 5;

  NewsBloc({required FetchNews fetchNews})
      : _fetchNews = fetchNews,
        super(NewsInitialState()) {
    on<FetchNewsEvent>(_onFetchNews);
    on<LoadMoreNewsEvent>(_onLoadMoreNews);
  }

  Future<void> _onFetchNews(FetchNewsEvent event, Emitter<NewsState> emit) async {
    emit(NewsLoadingState());
    _page = 1;  
    await _fetchAndEmitNews(event, emit);
  }

  Future<void> _onLoadMoreNews(LoadMoreNewsEvent event, Emitter<NewsState> emit) async {
    if (state is NewsLoadedState && (state as NewsLoadedState).hasMore && _page < _maxPages) {
      _page++;
      await _fetchAndEmitNews(event, emit, isLoadMore: true);
    } else {
      emit(NewsLoadedState(
        articles: (state as NewsLoadedState).articles,
        hasMore: false,
      ));
    }
  }

  Future<void> _fetchAndEmitNews(NewsEvent event, Emitter<NewsState> emit, {bool isLoadMore = false}) async {

    final query = (event is FetchNewsEvent) ? event.query : (event as LoadMoreNewsEvent).query;
    final language = (event is FetchNewsEvent) ? event.language : (event as LoadMoreNewsEvent).language;
    final sortBy = (event is FetchNewsEvent) ? event.sortBy : (event as LoadMoreNewsEvent).sortBy;

    final res = await _fetchNews.call(
      query,
      language,
      sortBy,
      _page,
      _pageSize,
    );

    res.fold(
      (l) {
        emit(NewsErrorState(l.message));
      },
      (r) {
        if (isLoadMore) {
          final currentState = state as NewsLoadedState;
          final updatedArticles = List<NewsArticle>.from(currentState.articles)..addAll(r);
          emit(NewsLoadedState(
            articles: updatedArticles,
            hasMore: r.length == _pageSize,
          ));
        } else {
          emit(NewsLoadedState(
            articles: r,
            hasMore: r.length == _pageSize,
          ));
        }
      },
    );
  }
}

