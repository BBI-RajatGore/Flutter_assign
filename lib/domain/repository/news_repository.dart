import 'package:fpdart/fpdart.dart';
import 'package:news_app_clean_archi/core/error/failure.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsArticle>>> fetchNews({
    required String? query,
    required String? language,
    required String? sortBy,
    required int page,
    required int pageSize,
  });
}
