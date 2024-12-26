import 'package:get_it/get_it.dart';
import 'package:task_manager/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/repository/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/create_user.dart';
import 'package:task_manager/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager/features/task/data/datasource/remote_data_source.dart';
import 'package:task_manager/features/task/data/reposotory/repository_impl.dart';
import 'package:task_manager/features/task/domain/repositories/task_repository.dart';
import 'package:task_manager/features/task/domain/usecases/add_task.dart';
import 'package:task_manager/features/task/domain/usecases/delete_task.dart';
import 'package:task_manager/features/task/domain/usecases/edit_task.dart';
import 'package:task_manager/features/task/domain/usecases/fetch_task.dart';
import 'package:task_manager/features/task/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

void init() {
  // task
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<TaskRepository>(
    () => RepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<FetchTask>(
    () => FetchTask(
      taskRespository: sl(),
    ),
  );
  sl.registerLazySingleton<AddTask>(
    () => AddTask(
      taskRespository: sl(),
    ),
  );
  sl.registerLazySingleton<EditTask>(
    () => EditTask(
      taskRepository: sl(),
    ),
  );
  sl.registerLazySingleton<DeleteTask>(
    () => DeleteTask(
      taskRepository: sl(),
    ),
  );

  sl.registerFactory<TaskBloc>(
    () => TaskBloc(
      fetchTasks: sl(),
      addTask: sl(),
      editTask: sl(),
      deleteTask: sl(),
    ),
  );

  // auth
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<CreateUser>(
    () => CreateUser(
      authRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => AuthBloc(
      createUser: sl(),
    ),
  );
}
