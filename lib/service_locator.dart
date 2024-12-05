import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_clean_archit/features/todo/data/data_sources/todo_local_data_source.dart';
import 'package:todo_app_clean_archit/features/todo/data/repository/todo_repository_impl.dart';
import 'package:todo_app_clean_archit/features/todo/domain/repository/todo_repository.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/add_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/delete_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/get_todo.dart';
import 'package:todo_app_clean_archit/features/todo/domain/usecase/update_todo.dart';
import 'package:todo_app_clean_archit/features/todo/presentation/bloc/todo_bloc.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerFactory<TodoBloc>(() => TodoBloc(
    addTodo: locator(),
    deleteTodoById: locator(),
    updateTodo: locator(),
    getAllTodo: locator(),
  ));

  locator.registerLazySingleton<AddTodo>(() => AddTodo(locator()));
  locator.registerLazySingleton<DeleteTodo>(() => DeleteTodo(locator()));
  locator.registerLazySingleton<UpdateTodo>(() => UpdateTodo(locator()));
  locator.registerLazySingleton<GetTodos>(() => GetTodos(locator()));

  locator.registerLazySingleton<TodoRepository>(() => TodoRepositoryImpl(localDataSource: locator()));
  locator.registerLazySingleton<TodoLocalDataSource>(() => TodoLocalDataSourceImpl());

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
}
