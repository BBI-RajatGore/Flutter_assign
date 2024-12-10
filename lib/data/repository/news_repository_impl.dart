import 'package:fpdart/fpdart.dart';
import 'package:news_app_clean_archi/core/error/failure.dart';
import 'package:news_app_clean_archi/data/data_sources/news_remote_data_source.dart';
import 'package:news_app_clean_archi/domain/entities/news.dart';
import 'package:news_app_clean_archi/domain/repository/news_repository.dart';

class NewsRepositoryImpl extends NewsRepository {
  
  final NewsRemoteDataSource newsRemoteDataSource;

  NewsRepositoryImpl({required this.newsRemoteDataSource});

  @override
  Future<Either<Failure, List<NewsArticle>>> fetchNews({required int page, required int pageSize}) async {
    try {
      final result = await newsRemoteDataSource.fetchNews(page: page, pageSize: pageSize);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
