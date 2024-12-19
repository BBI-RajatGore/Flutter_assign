

// part of 'news_bloc.dart';

// abstract class NewsState {}

// class NewsInitialState extends NewsState {}

// class NewsLoadingState extends NewsState {}

// class NewsLoadedState extends NewsState {
//   final List<NewsArticle> articles;
//   final bool hasMore;

//   NewsLoadedState({
//     required this.articles,
//     required this.hasMore,
//   });
// }

// class NewsErrorState extends NewsState {
//   final String message;

//   NewsErrorState(this.message);
// }


part of 'news_bloc.dart';

abstract class NewsState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsState;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class NewsInitialState extends NewsState {
  @override
  bool operator ==(Object other) {
    return other is NewsInitialState;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class NewsLoadingState extends NewsState {
  @override
  bool operator ==(Object other) {
    return other is NewsLoadingState;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

class NewsLoadedState extends NewsState {
  final List<NewsArticle> articles;
  final bool hasMore;

  NewsLoadedState({
    required this.articles,
    required this.hasMore,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NewsLoadedState &&
        other.articles == articles &&
        other.hasMore == hasMore;
  }

  @override
  int get hashCode => Object.hash(runtimeType, articles, hasMore);
}

class NewsErrorState extends NewsState {
  final String message;

  NewsErrorState(this.message);

  @override
  bool operator ==(Object other) {
    return other is NewsErrorState && other.message == message;
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);
}
