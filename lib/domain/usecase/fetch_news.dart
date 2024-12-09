// import 'package:fpdart/fpdart.dart';
// import 'package:news_app_clean_archi/core/error/failure.dart';
// import 'package:news_app_clean_archi/domain/entities/news.dart';
// import 'package:news_app_clean_archi/domain/repository/news_repository.dart';

// class FetchNews {
//   NewsRepository newsRepository;

//   FetchNews({required this.newsRepository});

//   Future<Either<Failure, List<NewsArticle>>> call() async {
//     return newsRepository.fetchNews();
//   }
  
// }


// fetch_news.dart (Use case)
import 'package:fpdart/fpdart.dart';
import 'package:news_app_clean_archi/core/error/failure.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/domain/repository/news_repository.dart';

class FetchNews {
  final NewsRepository newsRepository;

  FetchNews({required this.newsRepository});

  Future<Either<Failure, List<NewsArticle>>> call(int page, int pageSize) {
    return newsRepository.fetchNews(page: page, pageSize:  pageSize);
  }
}
