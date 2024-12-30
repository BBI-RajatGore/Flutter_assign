import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/features/auth/data/datasource/auth_local_data_source.dart';
import 'package:task_manager/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:task_manager/features/auth/data/repository/auth_repository_impl.dart';
import 'package:task_manager/features/auth/domain/repositories/auth_repository.dart';
import 'package:task_manager/features/auth/domain/usecase/create_user.dart';
import 'package:task_manager/features/auth/domain/usecase/get_user_status.dart';
import 'package:task_manager/features/auth/domain/usecase/login_user.dart';
import 'package:task_manager/features/auth/domain/usecase/logout_user.dart';
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

Future<void> init() async {
  // task
  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(
      taskRef: FirebaseDatabase.instance.ref('tasks')
    ),
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

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferencesHelper>(
    () => SharedPreferencesHelper(sharedPreferences: sharedPreferences),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      sharedPreferencesHelper: sl(),
      userCounterRef: FirebaseDatabase.instance.ref('user_count'),
      usersRef: FirebaseDatabase.instance.ref('users'),
    ),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
        authRemoteDataSource: sl(), sharedPreferencesHelper: sl()),
  );

  sl.registerLazySingleton<CreateUser>(
    () => CreateUser(
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<LoginUser>(
    () => LoginUser(
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<GetUserStatus>(
    () => GetUserStatus(
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<LogoutUser>(
    () => LogoutUser(
      authRepository: sl(),
    ),
  );

  sl.registerFactory(
    () => AuthBloc(
        createUser: sl(),
        loginUser: sl(),
        getUserStatus: sl(),
        logoutUser: sl()),
  );
}
