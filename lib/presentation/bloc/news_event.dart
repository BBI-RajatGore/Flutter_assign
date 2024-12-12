part of 'news_bloc.dart';

abstract class NewsEvent {}

class FetchNewsEvent extends NewsEvent {

  final String? query;
  final String? language;
  final String? sortBy;

  FetchNewsEvent({
    this.query,
    this.language,
    this.sortBy,
  });

}

class LoadMoreNewsEvent extends NewsEvent {
  final String? query;
  final String? language;
  final String? sortBy;

  LoadMoreNewsEvent({
    this.query,
    this.language,
    this.sortBy,
  });
}
