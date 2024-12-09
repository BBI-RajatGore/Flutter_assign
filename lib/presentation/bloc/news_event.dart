
part of 'news_bloc.dart';

abstract class NewsEvent {}

class FetchNewsEvent extends NewsEvent {
  FetchNewsEvent();
}

class LoadMoreNewsEvent extends NewsEvent {
  LoadMoreNewsEvent();
}
