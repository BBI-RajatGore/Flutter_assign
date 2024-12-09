import 'package:get_it/get_it.dart';
import 'package:news_app_clean_archi/data/data_sources/news_remote_data_source.dart';
import 'package:news_app_clean_archi/data/repository/news_repository_impl.dart';
import 'package:news_app_clean_archi/domain/repository/news_repository.dart';
import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';

final getIt = GetIt.instance;

void initServiceLocator() {


  getIt.registerLazySingleton<NewsRemoteDataSource>(
      () => NewsRemoteDataSourceImpl());

  getIt.registerLazySingleton<NewsRepository>(
      () => NewsRepositoryImpl(newsRemoteDataSource: getIt()));

  getIt.registerLazySingleton<FetchNews>(
      () => FetchNews(newsRepository: getIt()));

  getIt.registerFactory<NewsBloc>(
    () => NewsBloc(
      fetchNews: getIt(),
    ),
  );


  // register cubit
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());

}
