import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {

  final FetchNews _fetchNews;

  int _page = 1; 
  static const int _pageSize = 20;  

  NewsBloc({required FetchNews fetchNews})
      : _fetchNews = fetchNews,
        super(NewsInitialState()) {

    on<FetchNewsEvent>((event, emit) async {

      emit(NewsLoadingState());
    
      _page = 1;

      final res = await _fetchNews.call(_page, _pageSize); 

      res.fold(
        (l) {
          emit(NewsErrorState(l.message));
        },
        (r) {
          print(r.length);
          emit(NewsLoadedState(articles: r, hasMore: r.length == _pageSize));
        },
      );
    });

    on<LoadMoreNewsEvent>((event, emit) async {
      

      if (state is NewsLoadedState && (state as NewsLoadedState).hasMore && _page < 5) {


        final currentState = state as NewsLoadedState;

        _page++; 


        final res = await _fetchNews.call(_page, _pageSize); 

        res.fold(
          (l) {
            
            emit(NewsErrorState(l.message));
            
          },
          (r) {

            final updatedArticles = List<NewsArticle>.from(currentState.articles)..addAll(r);

            emit(NewsLoadedState(articles: updatedArticles, hasMore: r.length == _pageSize));

          },
        );
      }
      else{
        emit(NewsLoadedState(articles: (state as NewsLoadedState).articles, hasMore: false));
      }
    });
  }
}


