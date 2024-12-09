part of 'news_bloc.dart';

abstract class NewsState {}

class NewsInitialState extends NewsState {}

class NewsLoadingState extends NewsState {}

class NewsLoadedState extends NewsState {

  final List<NewsArticle> articles;
  final bool hasMore;

  NewsLoadedState({required this.articles, required this.hasMore});
}


class NewsErrorState extends NewsState {
  final String message;

  NewsErrorState(this.message);
}
