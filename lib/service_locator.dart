import 'package:get_it/get_it.dart';
import 'package:news_app_clean_archi/data/data_sources/news_remote_data_source.dart';
import 'package:news_app_clean_archi/data/repository/news_repository_impl.dart';
import 'package:news_app_clean_archi/domain/repository/news_repository.dart';
import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';

final getIt = GetIt.instance;

void initServiceLocator() {
  
  // the sequence doesnt matter while registering the Object

  // registerLazySingleton method registers an object that will be instantiated only when it is needed for the first time (lazily), not when the app starts ( The single instance of this can be used through out the app)
  getIt.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(),
  );

  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      newsRemoteDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<FetchNews>(
    () => FetchNews(
      newsRepository: getIt(),
    ),
  );

  // registerFactory ( create instance for each page beacause each page has it own event or states )
  getIt.registerFactory<NewsBloc>(
    () => NewsBloc(
      fetchNews: getIt(),
    ),
  );

  // register cubit (the single instance of ThemeCubit can we used within whole application using getIt)
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(),
  );

}
